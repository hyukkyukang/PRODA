"""Generates new queries on the JOB-light schema.

For each JOB-light join template, repeat #queries per template:
   - sample a tuple from this inner join result via factorized_sampler
   - sample #filters, and columns to put these filters on
   - query literals: use this tuple's values
   - sample ops: {>=, <=, =} for numerical columns and = for categoricals.

Uses either Spark or Postgres for actual execution to obtain true
cardinalities.  Both setups require data already be loaded.  For Postgres, the
server needs to be live.

Typical usage:

To generate queries:
    python make_job_queries.py --output_csv <csv> --num_queries <n>

To print selectivities of already generated queries:
    python make_job_queries.py \
      --print_sel --output_csv queries/job-light.csv --num_queries 70
"""

import os
import subprocess
import textwrap
import time

from absl import app
from absl import flags
from absl import logging
from mako import template
import numpy as np
import pandas as pd
from pyspark.sql import SparkSession
import argparse
import common
import datasets
from factorized_sampler import FactorizedSamplerIterDataset
import join_utils

import psycopg2
import datetime
import time
from glob import glob
import utils


def get_join_spec_from_file(csvfile, root):
    join_specs = []
    join_name = csvfile.split('/')[-1].split('.')[0]
    with open(csvfile, 'r') as f:
        lines = f.readlines()
        for i,line in enumerate(lines):
            tables = []
            join_keys = dict()
            join_clauses = line.replace('\n', '').split("|")
            for join_clause in join_clauses:
                assert len(join_clause.split('=')) == 2, len(join_clause.split('='))
                lhs, rhs = join_clause.split('=')

                ltable, lkey = lhs.split('.')
                rtable, rkey = rhs.split('.')

                if ltable not in tables:
                    tables.append(ltable)
                if rtable not in tables:
                    tables.append(rtable)

                if ltable in join_keys.keys():
                    if lkey not in join_keys[ltable]:
                        join_keys[ltable].append(lkey)
                else:
                    join_keys[ltable] = [lkey]
                if rtable in join_keys.keys():
                    if rkey not in join_keys[rtable]:
                        join_keys[rtable].append(rkey)
                else:
                    join_keys[rtable] = [rkey]
            try :
                join_spec = join_utils.get_join_spec({
                    "join_tables": tables,
                    "join_keys": join_keys,
                    "join_root": root,
                    "join_clauses": join_clauses,
                    "join_how": "inner",
                    "join_name": f"{join_name}_{i}"
                })
            except :
                print(f"{i} - join spec err")
            join_specs.append(join_spec)
    return join_specs


def MakeQueries(join_spec, tables_in_templates, use_cols, num_queries, rng, output_file,workload,
                template_num=0):
    """Sample a tuple from actual join result then place filters."""
    # spark.catalog.clearCache()

    # TODO: this assumes single equiv class.
    join_clauses_list = join_spec.join_clauses
    join_clauses = ' AND '.join(join_clauses_list)

    table_names = [n.name for n in tables_in_templates]


    range_workload_cols = []
    light_workload_cols = []
    categoricals = []
    numericals = []

    for table_name in join_spec.join_tables:
        categorical_cols = datasets.TPCDSBenchmark.CATEGORICAL_COLUMNS[
            table_name]
        for c in categorical_cols:
            disambiguated_name = common.JoinTableAndColumnNames(table_name,
                                                                c,
                                                                sep='.')
            range_workload_cols.append(disambiguated_name)
            light_workload_cols.append(disambiguated_name)
            categoricals.append(disambiguated_name)


        range_cols = datasets.TPCDSBenchmark.RANGE_COLUMNS[table_name]
        for c in range_cols:
            disambiguated_name = common.JoinTableAndColumnNames(table_name,
                                                                    c,
                                                                    sep='.')
            range_workload_cols.append(disambiguated_name)
            numericals.append(disambiguated_name)

    join_keys_list = []
    for table_name in join_spec.join_tables:

        for key in join_spec.join_keys[table_name]:
            join_keys_list.append(key)

    ds = FactorizedSamplerIterDataset(tables_in_templates,
                                      join_spec,
                                      data_dir='datasets/tpcds',
                                      dataset='tpcds',
                                      use_cols=use_cols,
                                      sample_batch_size=num_queries,
                                      disambiguate_column_names=False,
                                      add_full_join_indicators=False,
                                      add_full_join_fanouts=False,
                                      rust_random_seed=0,
                                      rng=rng)
    concat_table = common.ConcatTables(tables_in_templates,
                                       join_keys_list,
                                       sample_from_join_dataset=ds)

    print("sampler ")


    # range workload query
    range_output = f'./queries/{workload}/{output_file}'
    GenQuryFiles(range_output, ds, range_workload_cols, rng, concat_table, template_num, table_names,
                 join_clauses, join_clauses_list, numericals)

    return None


def GenQuryFiles(output_file, ds,content_cols,rng,concat_table,template_num,table_names,join_clauses,join_clauses_list,numericals=[]) :
    template_for_execution = template.Template(
        textwrap.dedent(
            "SELECT COUNT(*) FROM ${', '.join(table_names)} WHERE ${join_clauses} AND ${filter_clauses};").strip())

    ncols = len(content_cols)
    queries = []
    filter_strings = []
    sql_queries = []  # To get true cardinalities.

    while len(queries) < num_queries:
        sampled_df = ds.sampler.run()[content_cols]

        for r in sampled_df.iterrows():
            tup = r[1]
            try :
                num_filters = rng.randint( min(ncols,2) , max(( ncols //2)+2, ncols))
            except :
                num_filters = ncols
            # Positions where the values are non-null.
            non_null_indices = np.argwhere(~pd.isnull(tup).values).reshape(-1, )
            if len(non_null_indices) < num_filters:
                continue
            print('{} filters out of {} content cols'.format(
                num_filters, ncols))

            # Place {'<=', '>=', '='} on numericals and '=' on categoricals.
            idxs = rng.choice(non_null_indices, replace=False, size=num_filters)
            vals = tup[idxs].values
            cols = np.take(content_cols, idxs)
            ops = rng.choice(['<=', '>=', '='], size=num_filters)
            sensible_to_do_range = [c in numericals for c in cols]
            ops = np.where(sensible_to_do_range, ops, '=')

            print('cols', cols, 'ops', ops, 'vals', vals)

            queries.append((cols, ops, vals))
            filter_strings.append(','.join(
                [','.join((c, o, str(v))) for c, o, v in zip(cols, ops, vals)]))

            # Quote string literals & leave other literals alone.
            filter_clauses = ' AND '.join([
                '{} {} {}'.format(col, op, val)
                if concat_table[col].data.dtype in [np.int64, np.float64] else
                '{} {} \'{}\''.format(col, op, val)
                for col, op, val in zip(cols, ops, vals)
            ])

            sql = template_for_execution.render(table_names=table_names,
                                                join_clauses=join_clauses,
                                                filter_clauses=filter_clauses)
            sql_queries.append(sql)

            if len(queries) >= num_queries:
                break

    print(sql_queries)

    df = pd.DataFrame({
        'tables': [','.join(table_names)] * num_queries,
        'join_conds': [
                          ','.join(map(lambda s: s.replace(' ', ''), join_clauses_list))
                      ] * num_queries,
        'filters': filter_strings
    })
    df.to_csv(output_file, sep='|', mode='a', index=False, header=False)
    print('Template done.')

    with open(output_file.replace(".csv", ".sql"), 'at') as writer:
        writer.write(f'--templates : {template_num} \n')
        for sql in sql_queries:
            writer.write(sql + '\n')


def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1


def MakeTablesKey(table_names):
    sorted_tables = sorted(table_names)
    return '-'.join(sorted_tables)


def main(template_csv, output_csv, root, use_cols, num_queries,workload):

    tables = datasets.LoadTPCDS(use_cols=use_cols)
    print(f"\nLoad templates : {template_csv}\n")

    specs = get_join_spec_from_file(template_csv, root)
    print("Get join spec")

    rng = np.random.RandomState(1234)

    # Disambiguate to not prune away stuff during join sampling.
    for table_name, table in tables.items():
        for col in table.columns:
            col.name = common.JoinTableAndColumnNames(table.name,
                                                      col.name,
                                                      sep='.')
        table.data.columns = [col.name for col in table.columns]

    print(f"\nSave queries to {output_csv}\n")

    workload_dir = f'./queries/{workload}'
    try:
        if not os.path.exists(workload_dir): os.makedirs(workload_dir)
    except: print('Exist', workload_dir)

    for i, join_spec in enumerate(specs):
        assert num_queries > 0

        tables_in_templates = [tables[n] for n in join_spec.join_tables]
        print(f"\n\n===== # of Join : {i + 1}=====\n\n")


        MakeQueries(join_spec=join_spec, tables_in_templates=tables_in_templates, use_cols=use_cols,
                             num_queries=num_queries,
                             rng=rng, output_file=output_csv,workload=workload,
                             template_num=i)

    print("Queries are generated")

def get_root_from_file(path):
    root = None
    with open(path,'r') as file:
        txt = file.readline()
        root = txt.split('.')[0]
    assert root is not None
    return root

if __name__ == '__main__':


    parser = argparse.ArgumentParser()
    parser.add_argument('--template_csv', nargs="+",help='tmp file name')
    parser.add_argument('--output_csv', help='output file', default='output.csv')
    parser.add_argument('--root', default='item')
    parser.add_argument('--use_cols', default='full')
    parser.add_argument('--num_queries', help='Number of queries', type=int, default=1)
    args = parser.parse_args()

    template_csv = args.template_csv
    # output_csv = args.output_csv
    # root = args.root
    # use_cols = args.use_cols
    # num_queries = args.num_queries
    # workload = ''
    for input_csv in template_csv:
        t1 = time.time()
        output_csv = input_csv.split("/")[-1].replace('.csv','.out')
        root = get_root_from_file(input_csv)
        use_cols = 'full'
        num_queries = 10
        workload = f'tpcds-query'
        print(f"use root : {root} \nuse cols : {use_cols}")
        main(input_csv, output_csv, root, use_cols, num_queries, workload)
        print(f"{input_csv} done. takes {time.time()-t1:.2f}s")
    # main(template_csv, output_csv, root, use_cols,num_queries,workload)

