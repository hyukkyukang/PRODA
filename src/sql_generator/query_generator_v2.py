import numpy as np
import pandas as pd
import argparse
import datetime
import time
import json
import sqlite3
from glob import glob
from tqdm import tqdm
from pandas.api.types import is_string_dtype,is_numeric_dtype
import sql_gen_utils.query_graph
import sql_gen_utils.utils as utils
import tools.experiments
import sampler.common
import datasets.datasets as datasets
import sql_gen_utils.join_utils as join_utils
from tools.gen_schema_new import SCHEMA as spider_schema
from tools.gen_schema import SCHEMA as original_schema
from sql_gen_utils.sql_genetion_modules import query_generator
from sql_gen_utils.sql_genetion_utils import  alias_generator, \
                                    TEXTUAL_AGGS, \
                                    NUMERIC_AGGS
from datasets.type_dicts import imdbDtypeDict, tpcdsDtypeDict
from sampler.factorized_sampler import FactorizedSamplerIterDataset, JoinCountTableActor

SCHEMA = {k: v for k, v in list(spider_schema.items()) + list(original_schema.items())}
#SCHEMA = {k: v for k, v in list(original_schema.items())}

def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')


parser = argparse.ArgumentParser()
parser.add_argument('--num_queries', help='Number of queries', type=int, default=1)#10k
parser.add_argument('--output',type=str, default='result.out')
parser.add_argument('--sep',type=str,default='#')
parser.add_argument('--seed',type=int,default=1234)
parser.add_argument('--num_in_max',type=int,default=5)
parser.add_argument('--num_select_max',type=int,default=3)
parser.add_argument('--num_select_min',type=int,default=0)
parser.add_argument('--num_pred_max',type=int,default=3)
parser.add_argument('--num_pred_min',type=int,default=1)
parser.add_argument('--num_group_max',type=int,default=2)
parser.add_argument('--num_group_min',type=int,default=1)
parser.add_argument('--num_having_max',type=int,default=3)
parser.add_argument('--num_having_min',type=int,default=1)
parser.add_argument('--num_order_max',type=int,default=2)
parser.add_argument('--num_order_min',type=int,default=1)
parser.add_argument('--num_limit_max',type=int,default=5)
parser.add_argument('--num_limit_min',type=int,default=1)
parser.add_argument('--query_type', type=str,default='spj-mix',
    help="""One of (spj-non-nested, spj-nested, spj-mix, non-nested, nested, mix)\n
        Each type stands for non-nested spj query, 
        nested query consists of spj queries, 
        both non-nested and nested queires consist of spj queires,
        non-nested query consists of complex query,
        nested query consists of complex queries, 
        and both non-nested and nested queries consists of complex queries""")
parser.add_argument('--set_clause_by_clause', action='store_true')
parser.add_argument('--has_where', action='store_true')
parser.add_argument('--has_group', action='store_true')
parser.add_argument('--has_having', action='store_true')
parser.add_argument('--has_order', action='store_true')
parser.add_argument('--has_limit', action='store_true')
parser.add_argument('--set_nested_query_type', action='store_true')
parser.add_argument('--has_type_n', action='store_true')
parser.add_argument('--has_type_a', action='store_true')
parser.add_argument('--has_type_j', action='store_true')
parser.add_argument('--has_type_ja', action='store_true')
parser.add_argument('--log_path',type=str,default="query_generator.log")
parser.add_argument('--schema_name',type=str)
parser.add_argument('--db',type=str)
parser.add_argument('--join_key_pred',type=str2bool,default='False')
parser.add_argument('--inner_query_paths', nargs='+', default=None)
args = parser.parse_args()

ALIAS_TO_TABLE_NAME, TABLE_NAME_TO_ALIAS = alias_generator(args)

def check_sql_result (db_id, sql):
    conn = sqlite3.connect('data/database/' + db_id + '/' + db_id + '.sqlite')
    curs = conn.cursor()

    try:
        curs.execute(sql)
        result = curs.fetchall()
        if len(result) >= 1:
            return True
    except:
        curs.close()
        conn.close()
        return False

    curs.close()
    conn.close()
    return False


def alias_pred_caluse(txt):
    token = txt.split('.')
    assert len(token) == 2
    if TABLE_NAME_TO_ALIAS:
        table = TABLE_NAME_TO_ALIAS[token[0]]
    else:
        table = token[0]
    column = token[1]
    return f"{table}.{column}"


def JoinTableAndColumnNames(table_name, column_name, sep=':'):
    return '{}{}{}'.format(table_name, sep, column_name)


def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1


def decode_key_column (df, db_id):
    spiderReplacement = json.load(open('data/spider_replacement.json'))
    rep = spiderReplacement[db_id]
    join_groups = rep['join_groups']

    for col in df.columns:
        cur_col_group = None
        for g_idx in join_groups.keys():
            group = join_groups[g_idx]
            if col in group:
                cur_col_group = g_idx
                break

        if cur_col_group:
            df[col] = df.apply(lambda x: rep['replacement'][cur_col_group][str(int(x[col]))] \
                if not np.isnan(x[col]) and str(int(x[col])) in rep['replacement'][cur_col_group].keys() else x[col],axis=1)

    return df


def main(schema, dvs, column_dtype_dict, num_queries, output_path,log_path,log_step = 1,sep='#',SEED=1234,join_key_pred=True,only_executable=False):
    
    all_table_set =  set(schema['join_tables'])
    join_clause_list = schema['join_clauses']
    join_keys = schema['join_keys']

    join_key_list = list()
    for table,cols in join_keys.items():
        for col in cols:
            join_key_list.append(f"{table}.{col}")

    rng = np.random.RandomState(SEED)

    t1 = time.time()
    t2 = time.time()
    df = sampler.run()
    if schema['dataset'] == 'spider':
        df = decode_key_column(df, schema['use_cols'])

    lines = list()
    graphs = list()
    objs = list()
    print("Query generation")

    if schema['dataset'] == 'imdb':
        dtype_dict = imdbDtypeDict
    elif schema['dataset'] == 'tpcds':
        dtype_dict = tpcdsDtypeDict
    elif schema['dataset'] == 'spider':
        dtype_dict = json.load(open('data/spider_dtype_dict.json'))[schema['use_cols']]
    
    # for n in range(1,num_queries+1):
    pbar = tqdm(total = num_queries)
    n = 1
    num_success = 0
    num_iter = 0
    # Loading non-nested or nested query from files in the given paths
    if args.inner_query_paths:
        inner_query_objs = list()
        inner_query_graphs = list()
        for inner_query_path in args.inner_query_paths:
            with open(inner_query_path, 'r') as fp:
                q_count = len(fp.readlines())
            inner_query_objs += load_objs(inner_query_path+".obj", q_count)
            inner_query_graphs += load_graphs(inner_query_path+".graph", q_count)
        # .obj type files
    else:
        inner_query_objs = None
        inner_query_graphs = None

    while num_success < num_queries:
        num_iter += 1
        if num_success == 0 and num_iter > 10000:
            print("[WARNING] this type might be cannot be generated..")
            break
        if n >= len(df.notna()):
            n = 1
        
        #line, graph, obj = query_generator(args, df, n, rng,
        #                             all_table_set, join_key_list, join_clause_list, join_key_pred,
        #                             dtype_dict, dvs)
        try:
        	line, graph, obj = query_generator(args, df, n, rng,
        							all_table_set, join_key_list, join_clause_list, join_key_pred,
        							dtype_dict, dvs, inner_query_objs, inner_query_graphs)
        except Exception as e:
            print(e)
            break
            #continue
        n += 1

        do_write = True
        if only_executable:
            do_write = check_sql_result(schema['use_cols'], line)

        if do_write:
            lines.append(line + '\n')
            graphs.append(graph)
            objs.append(obj)
            pbar.update(1)
            num_success += 1

        
        if (n+1)%log_step == 0:
            with open(output_path,'at') as writer:
                writer.writelines(lines)
                lines = list()
            with open(output_path+".graph", 'ab') as writer:
                utils.write_graphs(writer, graphs)
                graphs = list()
            with open(output_path+".obj", 'ab') as writer:
                utils.write_objs(writer, objs)
                objs = list()

            cur_time = time.time()
            txt = f"{n+1} done. takes {cur_time-t1:.2f}s\t{cur_time-t2:.2f}s per {log_step}\n"
            print(txt)
            with open(log_path,'at') as writer:
                writer.write(txt+'\n')	
            t2 = time.time()

    pbar.close()

    with open(output_path,'at') as writer:
        writer.writelines(lines)
    cur_time = time.time()
    txt = f"Done. takes {cur_time-t1:.2f}s\t{cur_time-t2:.2f}s\n"
    print(txt)
    with open(log_path,'at') as writer:
        writer.write(txt+'\n')


def print_full_outer_sample():
    sqls = open('imdb_2.sql')
    for sql in sqls:
        continue


def get_full_outer_sampler(schema,SEED=1234):
    loaded_tables = list()
    if schema['dataset'] == 'spider' and 'join_unique_values' not in schema.keys():
        schema['join_unique_values'] = {}
        join_groups = []
        for join_cond in schema['join_clauses']:
            c1, c2 = join_cond.split('=')

            make_new_group = True
            for join_group in join_groups:
                if c1 in join_group or c2 in join_group:
                    make_new_group = False
                    if c1 not in join_group:
                        join_group.append(c1)
                    if c2 not in join_group:
                        join_group.append(c2)
            
            if make_new_group:
                join_groups.append([c1, c2])

        for join_group in join_groups:		
            schema['join_unique_values'][tuple(join_group)] = {}

    for t in schema['join_tables']:
        print('Loading', t)
        if schema['dataset'] == 'imdb':
            table = datasets.LoadImdb(t, use_cols=schema['use_cols'])
        elif schema['dataset'] == 'tpcds':
            table = datasets.LoadTPCDS(t, use_cols=schema['use_cols'])
        elif schema['dataset'] == 'spider':
            table = datasets.LoadSpider(t, data_dir=schema['data_dir'], use_cols=schema['use_cols'], schema=schema)

        table.data.info()
        loaded_tables.append(table)


    join_spec = join_utils.get_join_spec({
        "join_tables": schema['join_tables'],
        "join_keys": schema['join_keys'],
        "join_root": schema['join_root'],
        "join_clauses": schema['join_clauses'],
        "join_how": "outer",
        "join_name": "Query_generator"
        })
    
    rng = np.random.RandomState(SEED)

    ds = FactorizedSamplerIterDataset(loaded_tables,
                                      join_spec,
                                      data_dir=schema['data_dir'],
                                      dataset=schema['dataset'],
                                      use_cols=schema['use_cols'],
                                      sample_batch_size=1000,#args.num_queries+1,
                                      disambiguate_column_names=False,
                                      add_full_join_indicators=False,
                                      add_full_join_fanouts=False,
                                      rust_random_seed=SEED,
                                      rng=rng)
    return ds.sampler,loaded_tables


def get_distinct_values_dict(loaded_tables, db_id=None):
    dvs_dict = dict()
    for table in loaded_tables:
        table_name = table.Name()
        for column in table.Columns():
            col_name = column.Name()
            dvs = column.all_distinct_values

            if db_id is not None:
                dvs_df = pd.DataFrame({table_name + '.' + col_name:dvs})
                dvs_df = decode_key_column(dvs_df, db_id)
                dvs = dvs_df[table_name + '.' + col_name].to_numpy()

            if is_numeric_dtype(dvs):
                dvs_dict[f"{table_name}.{col_name}"] = dvs[~np.isnan(dvs)]
            else:
                if pd.isnull(dvs[0]) or dvs[0] == 'nan':
                    dvs = dvs[1:]
                dvs_dict[f"{table_name}.{col_name}"] = dvs
                
    return dvs_dict

def get_column_dtype_dict(loaded_tables):
    column_dtype_dict = dict()
    for table in loaded_tables:
        for column in table.data.columns:
            column_dtype_dict[column] = table.data[column].dtype
    return column_dtype_dict
if __name__ == '__main__':

    schema = SCHEMA[args.schema_name]
    schema['data_dir'] = schema['data_dir'].replace('/csv/', '/csv_replaced/')
    sampler,loaded_tables = get_full_outer_sampler(schema,args.seed)
    # try:
    # 	sampler,loaded_tables = get_full_outer_sampler(schema,args.seed)
    # except:
    # 	print('Error in building full outer join table')
    # 	quit()
        
    dvs = get_distinct_values_dict(loaded_tables, db_id=schema['use_cols'] if schema['dataset'] == 'spider' else None)
    # column_dtype_dict = get_column_dtype_dict(loaded_tables)
    column_dtype_dict = None

    num_queries = args.num_queries
    output_path = args.output
    log_path = args.log_path

    if args.db =='imdb':
        sep = '#'
    elif args.db == 'tpcds':
        sep = '|'
    else:
        sep = '|'

    main(schema, dvs, column_dtype_dict,num_queries, output_path,log_path,sep=sep,SEED=args.seed,join_key_pred=args.join_key_pred)
