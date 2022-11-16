"""Experiment configurations.

EXPERIMENT_CONFIGS holds all registered experiments.

TEST_CONFIGS (defined at end of file) stores "unit tests": these are meant to
run for a short amount of time and to assert metrics are reasonable.

Experiments registered here can be launched using:

  >> python run.py --run <config> [ <more configs> ]
  >> python run.py  # Runs all tests in TEST_CONFIGS.
"""
import os

from ray import tune

EXPERIMENT_CONFIGS = {}
TEST_CONFIGS = {}

# Common config. Each key is auto set as an attribute (i.e. NeuroCard.<attr>)
# so try to avoid any name conflicts with members of that class.
BASE_CONFIG = {
    'cwd': os.getcwd(),
    'epochs_per_iteration': 1,
    'num_eval_queries_per_iteration': 100,
    'num_eval_queries_at_end': 2000,  # End of training.
    'num_eval_queries_at_checkpoint_load': 2000,  # Evaluate a loaded ckpt.
    'epochs': 10,
    'seed': None,
    'order_seed': None,
    'bs': 2048,
    'order': None,
    'layers': 2,
    'fc_hiddens': 128,
    'warmups': 1000,
    'constant_lr': None,
    'lr_scheduler': None,
    'custom_lr_lambda': None,
    'optimizer': 'adam',
    'residual': True,
    'direct_io': True,
    'input_encoding': 'embed',
    'output_encoding': 'embed',
    'query_filters': [5, 12],
    'force_query_cols': None,
    'embs_tied': True,
    'embed_size': 32,
    'input_no_emb_if_leq': True,
    'resmade_drop_prob': 0.,

    # Multi-gpu data parallel training.
    'use_data_parallel': False,

    # If set, load this checkpoint and run eval immediately. No training. Can
    # be glob patterns.
    # Example:
    # 'checkpoint_to_load': tune.grid_search([
    #     'models/*52.006*',
    #     'models/*43.590*',
    #     'models/*42.251*',
    #     'models/*41.049*',
    # ]),
    'checkpoint_to_load': None,
    # Dropout for wildcard skipping.
    'disable_learnable_unk': False,
    'per_row_dropout': True,
    'dropout': 1,
    'table_dropout': False,
    'fixed_dropout_ratio': False,
    'asserts': None,
    'special_orders': 0,
    'special_order_seed': 0,
    'join_tables': [],
    'label_smoothing': 0.0,
    'compute_test_loss': False,

    # Column factorization.
    'factorize': False,
    'factorize_blacklist': None,
    'grouped_dropout': True,
    'factorize_fanouts': False,

    # Eval.
    'eval_psamples': [100, 1000, 10000],
    'eval_join_sampling': None,  # None, or #samples/query.

    # Transformer.
    'use_transformer': False,
    'transformer_args': {},

    # Checkpoint.
    'save_checkpoint_at_end': True,
    'checkpoint_every_epoch': False,

    # Experimental.
    '_save_samples': None,
    '_load_samples': None,
    'num_orderings': 1,
    'num_dmol': 0,

    # +@ add mode, save result
    'mode' : 'TRAIN',
    'save_eval_result' : True,
    'rust_random_seed' : 0, # 0 make non-deterministic
'data_dir': './datasets/job_csv_export/',
    'epoch' :0,
    'sep' : '#',
    'verbose_mode' : False,
    'accum_iter' : 1,
    'col_dist_sizes' : None,
}

JOB_TOY = {
    'dataset': 'imdb',
    'join_tables': [
        'movie_companies','movie_keyword', 'title',
    ],
    'join_keys': {
        'movie_companies': ['movie_id'],
        'movie_keyword': ['movie_id'],
        'title': ['id'],
    },
    'join_clauses': [
        'title.id=movie_companies.movie_id',
        'title.id=movie_keyword.movie_id',
    ],
    'join_how': 'outer',
    'join_name': 'job-toy',
    # See datasets.py.
    'use_cols': 'toy',
    'queries_csv': './queries/job-toy.csv',
    'data_dir': 'datasets/job_csv_export/',
    'epochs' : 2,
    'bs' : 128,
    'max_steps': 10,
    'num_eval_queries_per_iteration': 2,
    'use_data_parallel' : True,
    'compute_test_loss': True
}
JOB_LIGHT_BASE = {
    'dataset': 'imdb',
    'join_tables': [
        'cast_info', 'movie_companies', 'movie_info', 'movie_keyword', 'title',
        'movie_info_idx'
    ],
    'join_keys': {
        'cast_info': ['movie_id'],
        'movie_companies': ['movie_id'],
        'movie_info': ['movie_id'],
        'movie_keyword': ['movie_id'],
        'title': ['id'],
        'movie_info_idx': ['movie_id']
    },
    # Sampling starts at this table and traverses downwards in the join tree.
    'join_root': 'title',
    # Inferred.
    'join_clauses': None,
    'join_how': 'outer',
    # Used for caching metadata.  Each join graph should have a unique name.
    'join_name': 'job-light',
    # See datasets.py.
    'use_cols': 'simple',
    'seed': 0,
    'per_row_dropout': False,
    'table_dropout': True,
    'embs_tied': True,
    # Num tuples trained =
    #   bs (batch size) * max_steps (# batches per "epoch") * epochs.
    'epochs': 1,
    'bs': 2048,
    'max_steps': 500,
    # Use this fraction of total steps as warmups.
    'warmups': 0.05,
    # Number of DataLoader workers that perform join sampling.
    'loader_workers': 8,
    # Options: factorized_sampler, fair_sampler (deprecated).
    'sampler': 'factorized_sampler',
    'sampler_batch_size': 1024 * 4,
    'layers': 4,
    # Eval:
    'compute_test_loss': True,
    'queries_csv': './queries/job-light.csv',
    'num_eval_queries_per_iteration': 0,
    'num_eval_queries_at_end': 70,
    'eval_psamples': [4000],

    # Multi-order.
    'special_orders': 0,
    'order_content_only': True,
    'order_indicators_at_front': False,
}

FACTORIZE = {
    'factorize': True,
    'word_size_bits': 10,
    'grouped_dropout': True,
}
TOY_TEST = {
    'join_tables' : ['A','B','C'],
    'join_keys' : { 'A' : ['x'], 'B':['x','y'], 'C':['y']},
    'join_clauses' : [ 'A.x=B.x', 'B.y=C.y'],
    'join_root': 'A',
    'join_how': 'outer',
    'join_name': 'toy-test',
    'use_cols': 'toy_test_col',
    'epochs': 3,
    'bs': 1,
    'resmade_drop_prob': 0.1,
    'max_steps': 50,
    'loader_workers': 8,
    'sampler': 'factorized_sampler',
    'sampler_batch_size': 1,
    'warmups': 0.15,
    # Eval:
    'compute_test_loss': False,
    'queries_csv': './queries/toy_test.csv',
    'num_eval_queries_per_iteration': 0,
    'num_eval_queries_at_end': 30,
    'eval_psamples': [5],
    'data_dir': 'datasets/test/',
    'sep': '#',
    'dataset':'toy',
    'use_data_parallel':True,
}


JOB_M = {
    'join_tables': [
        'title', 'aka_title', 'cast_info', 'complete_cast', 'movie_companies',
        'movie_info', 'movie_info_idx', 'movie_keyword', 'movie_link',
        'kind_type', 'comp_cast_type', 'company_name', 'company_type',
        'info_type', 'keyword', 'link_type'
    ],
    'join_keys': {
        'title': ['id', 'kind_id'],
        'aka_title': ['movie_id'],
        'cast_info': ['movie_id'],
        'complete_cast': ['movie_id', 'subject_id'],
        'movie_companies': ['company_id', 'company_type_id', 'movie_id'],
        'movie_info': ['movie_id'],
        'movie_info_idx': ['info_type_id', 'movie_id'],
        'movie_keyword': ['keyword_id', 'movie_id'],
        'movie_link': ['link_type_id', 'movie_id'],
        'kind_type': ['id'],
        'comp_cast_type': ['id'],
        'company_name': ['id'],
        'company_type': ['id'],
        'info_type': ['id'],
        'keyword': ['id'],
        'link_type': ['id']
    },
    'join_clauses': [
        'title.id=aka_title.movie_id',
        'title.id=cast_info.movie_id',
        'title.id=complete_cast.movie_id',
        'title.id=movie_companies.movie_id',
        'title.id=movie_info.movie_id',
        'title.id=movie_info_idx.movie_id',
        'title.id=movie_keyword.movie_id',
        'title.id=movie_link.movie_id',
        'title.kind_id=kind_type.id',
        'comp_cast_type.id=complete_cast.subject_id',
        'company_name.id=movie_companies.company_id',
        'company_type.id=movie_companies.company_type_id',
        'movie_info_idx.info_type_id=info_type.id',
        'keyword.id=movie_keyword.keyword_id',
        'link_type.id=movie_link.link_type_id',
    ],
    'join_root': 'title',
    'join_how': 'outer',
    'join_name': 'job-m',
    'use_cols': 'multi',
    'epochs': 10,
    'bs': 1000,
    'resmade_drop_prob': 0.1,
    'max_steps': 1000,
    'loader_workers': 8,
    'sampler': 'factorized_sampler',
    'sampler_batch_size': 1024 * 16,
    'warmups': 0.15,
    # Eval:



    'compute_test_loss': False,
    'queries_csv': './queries/job-m.csv',
    'num_eval_queries_per_iteration': 0,
    'num_eval_queries_at_end': 113,
    'eval_psamples': [1000],

    'join_fds' : ['movie_info_idx.info_type_id=info_type.id', 'complete_cast.movie_id=movie_info.movie_id', 'movie_info.movie_id=movie_keyword.movie_id', 'movie_info.movie_id=movie_info_idx.movie_id', 'complete_cast.movie_id=title.id', 'complete_cast.movie_id=movie_keyword.movie_id', 'cast_info.movie_id=movie_info_idx.movie_id', 'title.id=movie_info_idx.movie_id', 'cast_info.movie_id=movie_link.movie_id', 'keyword.id=movie_keyword.keyword_id', 'link_type.id=movie_link.link_type_id', 'movie_keyword.movie_id=title.id', 'movie_info.movie_id=title.id', 'movie_companies.company_id=company_name.id', 'movie_companies.movie_id=movie_info.movie_id', 'aka_title.movie_id=movie_info_idx.movie_id', 'cast_info.movie_id=movie_keyword.movie_id', 'title.kind_id=kind_type.id', 'title.id=movie_companies.movie_id', 'title.id=movie_keyword.movie_id', 'cast_info.movie_id=movie_info.movie_id', 'movie_keyword.keyword_id=keyword.id', 'movie_info.movie_id=movie_link.movie_id', 'aka_title.movie_id=cast_info.movie_id', 'cast_info.movie_id=complete_cast.movie_id', 'movie_companies.movie_id=title.id', 'comp_cast_type.id=complete_cast.subject_id', 'movie_keyword.movie_id=movie_link.movie_id', 'movie_info_idx.movie_id=movie_keyword.movie_id', 'movie_companies.company_type_id=company_type.id', 'movie_companies.movie_id=movie_link.movie_id', 'aka_title.movie_id=movie_companies.movie_id', 'movie_companies.movie_id=movie_keyword.movie_id', 'movie_info_idx.movie_id=movie_link.movie_id', 'complete_cast.movie_id=movie_info_idx.movie_id', 'aka_title.movie_id=movie_info.movie_id', 'cast_info.movie_id=movie_companies.movie_id', 'movie_companies.movie_id=movie_info_idx.movie_id', 'movie_link.movie_id=title.id', 'complete_cast.subject_id=comp_cast_type.id', 'cast_info.movie_id=title.id', 'complete_cast.movie_id=movie_link.movie_id', 'aka_title.movie_id=movie_keyword.movie_id', 'title.id=complete_cast.movie_id', 'aka_title.movie_id=movie_link.movie_id', 'title.id=cast_info.movie_id', 'aka_title.movie_id=title.id', 'title.id=movie_link.movie_id', 'info_type.id=movie_info_idx.info_type_id', 'movie_link.link_type_id=link_type.id', 'company_name.id=movie_companies.company_id', 'company_type.id=movie_companies.company_type_id', 'title.id=aka_title.movie_id', 'kind_type.id=title.kind_id', 'title.id=movie_info.movie_id', 'movie_info_idx.movie_id=title.id', 'aka_title.movie_id=complete_cast.movie_id', 'complete_cast.movie_id=movie_companies.movie_id'],
}

JOB_M_FACTORIZED = {
    'factorize': True,
    'factorize_blacklist': [],
    'factorize_fanouts': True,
    'word_size_bits': 14,
    'bs': 2048,
    'max_steps': 512,
    'epochs': 20,
    'checkpoint_every_epoch': True,
    'epochs_per_iteration': 1,
    'col_dist_sizes' :None,
}

# +@ add default config
TPCDS_DEFAULT = dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),
    **{
        'dataset': 'tpcds',
        'data_dir': 'datasets/tpcds_2_13_0/',
        'epoch' : 0,
        'epochs': 1000,
        'bs': 256,
        'max_steps': tune.grid_search([4000]),
        'eval_psamples': [1000],
        'sep' : '|',
        'use_data_parallel':True,
        'col_dist_sizes' :None,
    }
)

TPCDS_TOY = dict(TPCDS_DEFAULT,
    **{
        'dataset': 'tpcds',
        'join_tables': ['item','store_sales',  'store_returns'],
        'join_keys': {'store_sales': ['ss_item_sk'], 'item': ['i_item_sk'], 'store_returns': ['sr_item_sk']},
        'join_root': 'item',
        'join_clauses': ['item.i_item_sk=store_returns.sr_item_sk','item.i_item_sk=store_sales.ss_item_sk'],
        'use_cols': 'tpcds-toy',
        'data_dir': './datasets/tpcds_2_13_0/',
        'join_name': 'tpcds-db-tree-i',
        'accum_iter' : 8,



        'queries_csv': './queries/L-tpcds-item_full-item-i_full-65.out',
        # 'factorize_blacklist' : ['__fanout_store_sales', '__fanout_store_sales__ss_item_sk', '__fanout_item', '__fanout_item__i_item_sk', '__fanout_store_returns', '__fanout_store_returns__sr_item_sk', '__fanout_store_returns__sr_returned_date_sk', '__fanout_store_returns__sr_return_time_sk', '__fanout_store_returns__sr_customer_sk', '__fanout_store_returns__sr_cdemo_sk', '__fanout_store_returns__sr_hdemo_sk', '__fanout_store_returns__sr_addr_sk', '__fanout_store_returns__sr_store_sk', '__fanout_store_returns__sr_reason_sk', '__fanout_catalog_sales', '__fanout_catalog_sales__cs_item_sk', '__fanout_catalog_sales__cs_call_center_sk', '__fanout_catalog_sales__cs_catalog_page_sk', '__fanout_catalog_sales__cs_ship_mode_sk', '__fanout_catalog_sales__cs_warehouse_sk', '__fanout_catalog_returns', '__fanout_catalog_returns__cr_item_sk', '__fanout_web_sales', '__fanout_web_sales__ws_item_sk', '__fanout_web_sales__ws_web_page_sk', '__fanout_web_sales__ws_web_site_sk', '__fanout_web_returns', '__fanout_web_returns__wr_item_sk', '__fanout_inventory', '__fanout_inventory__inv_item_sk', '__fanout_promotion', '__fanout_promotion__p_item_sk', '__fanout_date_dim', '__fanout_date_dim__d_date_sk', '__fanout_time_dim', '__fanout_time_dim__t_time_sk', '__fanout_customer', '__fanout_customer__c_customer_sk', '__fanout_customer_demographics', '__fanout_customer_demographics__cd_demo_sk', '__fanout_household_demographics', '__fanout_household_demographics__hd_demo_sk', '__fanout_household_demographics__hd_income_band_sk', '__fanout_customer_address', '__fanout_customer_address__ca_address_sk', '__fanout_store', '__fanout_store__s_store_sk', '__fanout_reason', '__fanout_reason__r_reason_sk', '__fanout_call_center', '__fanout_call_center__cc_call_center_sk', '__fanout_catalog_page', '__fanout_catalog_page__cp_catalog_page_sk', '__fanout_ship_mode', '__fanout_ship_mode__sm_ship_mode_sk', '__fanout_warehouse', '__fanout_warehouse__w_warehouse_sk', '__fanout_web_page', '__fanout_web_page__wp_web_page_sk', '__fanout_web_site', '__fanout_web_site__web_site_sk', '__fanout_income_band', '__fanout_income_band__ib_income_band_sk']
        # 'factorize_blacklist' : ['__fanout_store_sales__ss_item_sk','__fanout_item__i_item_sk','__fanout_store_returns__sr_item_sk', '__fanout_store_returns__sr_returned_date_sk', '__fanout_store_returns__sr_return_time_sk', '__fanout_store_returns__sr_customer_sk', '__fanout_store_returns__sr_cdemo_sk', '__fanout_store_returns__sr_hdemo_sk', '__fanout_store_returns__sr_addr_sk', '__fanout_store_returns__sr_store_sk', '__fanout_store_returns__sr_reason_sk','__fanout_catalog_sales__cs_item_sk', '__fanout_catalog_sales__cs_call_center_sk', '__fanout_catalog_sales__cs_catalog_page_sk', '__fanout_catalog_sales__cs_ship_mode_sk', '__fanout_catalog_sales__cs_warehouse_sk','__fanout_catalog_returns__cr_item_sk','__fanout_web_sales__ws_item_sk', '__fanout_web_sales__ws_web_page_sk', '__fanout_web_sales__ws_web_site_sk','__fanout_web_returns__wr_item_sk','__fanout_inventory__inv_item_sk','__fanout_promotion__p_item_sk','__fanout_date_dim__d_date_sk','__fanout_time_dim__t_time_sk','__fanout_customer__c_customer_sk','__fanout_customer_demographics__cd_demo_sk','__fanout_household_demographics__hd_demo_sk', '__fanout_household_demographics__hd_income_band_sk','__fanout_customer_address__ca_address_sk','__fanout_store__s_store_sk','__fanout_reason__r_reason_sk','__fanout_call_center__cc_call_center_sk','__fanout_catalog_page__cp_catalog_page_sk','__fanout_ship_mode__sm_ship_mode_sk','__fanout_warehouse__w_warehouse_sk','__fanout_web_page__wp_web_page_sk','__fanout_web_site__web_site_sk','__fanout_income_band__ib_income_band_sk']
        # 'factorize_blacklist': ['store_sales:ss_item_sk', 'item:i_item_sk', 'store_returns:sr_item_sk', 'store_returns:sr_returned_date_sk', 'store_returns:sr_return_time_sk', 'store_returns:sr_customer_sk', 'store_returns:sr_cdemo_sk', 'store_returns:sr_hdemo_sk', 'store_returns:sr_addr_sk', 'store_returns:sr_store_sk', 'store_returns:sr_reason_sk', 'catalog_sales:cs_item_sk', 'catalog_sales:cs_call_center_sk', 'catalog_sales:cs_catalog_page_sk', 'catalog_sales:cs_ship_mode_sk', 'catalog_sales:cs_warehouse_sk', 'catalog_returns:cr_item_sk', 'web_sales:ws_item_sk', 'web_sales:ws_web_page_sk', 'web_sales:ws_web_site_sk', 'web_returns:wr_item_sk', 'inventory:inv_item_sk', 'promotion:p_item_sk', 'date_dim:d_date_sk', 'time_dim:t_time_sk', 'customer:c_customer_sk', 'customer_demographics:cd_demo_sk', 'household_demographics:hd_demo_sk', 'household_demographics:hd_income_band_sk', 'customer_address:ca_address_sk', 'store:s_store_sk', 'reason:r_reason_sk', 'call_center:cc_call_center_sk', 'catalog_page:cp_catalog_page_sk', 'ship_mode:sm_ship_mode_sk', 'warehouse:w_warehouse_sk', 'web_page:wp_web_page_sk', 'web_site:web_site_sk', 'income_band:ib_income_band_sk']
        })


JOB_UNION = {
    'join_tables': [
        'title', 'aka_title', 'cast_info', 'complete_cast', 'movie_companies',
        'movie_info', 'movie_info_idx', 'movie_keyword', 'movie_link',
        'kind_type', 'comp_cast_type', 'company_name', 'company_type',
        'info_type', 'keyword', 'link_type'
    ],
    'join_keys': {
        'title': ['id', 'kind_id'],
        'aka_title': ['movie_id'],
        'cast_info': ['movie_id'],
        'complete_cast': ['movie_id', 'subject_id'],
        'movie_companies': ['company_id', 'company_type_id', 'movie_id'],
        'movie_info': ['movie_id'],
        'movie_info_idx': ['info_type_id', 'movie_id'],
        'movie_keyword': ['keyword_id', 'movie_id'],
        'movie_link': ['link_type_id', 'movie_id'],
        'kind_type': ['id'],
        'comp_cast_type': ['id'],
        'company_name': ['id'],
        'company_type': ['id'],
        'info_type': ['id'],
        'keyword': ['id'],
        'link_type': ['id']
    },
    'join_clauses': [
        'title.id=aka_title.movie_id',
        'title.id=cast_info.movie_id',
        'title.id=complete_cast.movie_id',
        'title.id=movie_companies.movie_id',
        'title.id=movie_info.movie_id',
        'title.id=movie_info_idx.movie_id',
        'title.id=movie_keyword.movie_id',
        'title.id=movie_link.movie_id',
        'title.kind_id=kind_type.id',
        'comp_cast_type.id=complete_cast.subject_id',
        'company_name.id=movie_companies.company_id',
        'company_type.id=movie_companies.company_type_id',
        'movie_info_idx.info_type_id=info_type.id',
        'keyword.id=movie_keyword.keyword_id',
        'link_type.id=movie_link.link_type_id',
    ],
    'join_root': 'title',
    'join_how': 'outer',
    'join_name': 'job-union',
    # 'use_cols': 'multi-add-key',
    # 'epochs': 200,
    # 'bs': 2048,
    # 'max_steps': 512,
    # 'loader_workers': 8,
    # 'sampler': 'factorized_sampler',
    # 'sampler_batch_size': 1024 * 16,
    # 'compute_test_loss': False,
    # 'queries_csv': './queries/job-light-ranges.csv',
    # 'num_eval_queries_per_iteration': 0,
    # 'num_eval_queries_at_end': 1000,
    'eval_psamples': [512],
    'factorize_blacklist' :['__fanout_title', '__fanout_title__id', '__fanout_title__kind_id', '__fanout_aka_title', '__fanout_aka_title__movie_id', '__fanout_cast_info', '__fanout_cast_info__movie_id', '__fanout_complete_cast', '__fanout_complete_cast__movie_id', '__fanout_complete_cast__subject_id', '__fanout_movie_companies', '__fanout_movie_companies__company_id', '__fanout_movie_companies__company_type_id', '__fanout_movie_companies__movie_id', '__fanout_movie_info', '__fanout_movie_info__movie_id', '__fanout_movie_info_idx', '__fanout_movie_info_idx__info_type_id', '__fanout_movie_info_idx__movie_id', '__fanout_movie_keyword', '__fanout_movie_keyword__keyword_id', '__fanout_movie_keyword__movie_id', '__fanout_movie_link', '__fanout_movie_link__link_type_id', '__fanout_movie_link__movie_id', '__fanout_kind_type', '__fanout_kind_type__id', '__fanout_comp_cast_type', '__fanout_comp_cast_type__id', '__fanout_company_name', '__fanout_company_name__id', '__fanout_company_type', '__fanout_company_type__id', '__fanout_info_type', '__fanout_info_type__id', '__fanout_keyword', '__fanout_keyword__id', '__fanout_link_type', '__fanout_link_type__id'],
    'data_dir' : 'datasets/job_csv_export/',

    'use_cols': 'union',

}


IMDB_FULL = {
        'join_tables': ['title', 'aka_title', 'movie_link', 'cast_info', 'movie_info', 'movie_info_idx', 'kind_type', 'movie_keyword', 'movie_companies', 'complete_cast', 'link_type', 'char_name', 'role_type', 'name', 'info_type', 'keyword', 'company_name', 'company_type', 'comp_cast_type', 'aka_name', 'person_info'],
        'join_keys':{'title': ['id', 'kind_id'],
                     'aka_title': ['movie_id'],
                     'movie_link': ['link_type_id', 'movie_id'],
                     'cast_info': ['person_id', 'person_role_id', 'movie_id', 'role_id'],
                     'movie_info': ['movie_id'],
                     'movie_info_idx': ['movie_id', 'info_type_id'],
                     'kind_type': ['id'],
                     'movie_keyword': ['keyword_id', 'movie_id'],
                     'movie_companies': ['company_id', 'movie_id', 'company_type_id'],
                     'complete_cast': ['movie_id','subject_id'],
                     'link_type': ['id'],
                     'char_name': ['id'],
                     'role_type': ['id'],
                     'name': ['id'],
                     'info_type': ['id'],
                     'keyword': ['id'],
                     'company_name': ['id'],
                     'company_type': ['id'],
                     'comp_cast_type': ['id'],
                     'aka_name': ['person_id'],
                     'person_info': ['person_id']},
        'join_root': 'title',
        'join_clauses':
                    ['title.id=aka_title.movie_id',
                     'title.id=movie_link.movie_id',
                     'title.id=cast_info.movie_id',
                     'title.id=movie_info.movie_id',
                     'title.id=movie_info_idx.movie_id',
                     'title.kind_id=kind_type.id',
                     'title.id=movie_keyword.movie_id',
                     'title.id=movie_companies.movie_id',
                     'title.id=complete_cast.movie_id',
                     'movie_link.link_type_id=link_type.id',
                     'cast_info.person_role_id=char_name.id',
                     'cast_info.role_id=role_type.id',
                     'cast_info.person_id=name.id',
                     'movie_info_idx.info_type_id=info_type.id',
                     'movie_keyword.keyword_id=keyword.id',
                     'movie_companies.company_id=company_name.id',
                     'movie_companies.company_type_id=company_type.id',
                     'comp_cast_type.id=complete_cast.subject_id',
                     'name.id=aka_name.person_id',
                     'name.id=person_info.person_id'],
        'dataset': 'imdb',
        'use_cols': 'imdb-db',
        'data_dir': './datasets/job_csv_export/',
        'join_name': 'imdb-full',
        'queries_csv': './queries/job-light.csv',
        'accum_iter': 1,
        'layers': 4,
        'epochs':200,
        'loader_workers': 1,
        'compute_test_loss': False,
        'checkpoint_every_epoch': True,
        'eval_psamples': [512],
        'factorize_blacklist':['__fanout_title', '__fanout_title__id', '__fanout_title__kind_id', '__fanout_aka_title', '__fanout_aka_title__movie_id', '__fanout_movie_link', '__fanout_movie_link__link_type_id', '__fanout_movie_link__movie_id', '__fanout_cast_info', '__fanout_cast_info__person_id', '__fanout_cast_info__person_role_id', '__fanout_cast_info__movie_id', '__fanout_cast_info__role_id', '__fanout_movie_info', '__fanout_movie_info__movie_id', '__fanout_movie_info_idx', '__fanout_movie_info_idx__movie_id', '__fanout_movie_info_idx__info_type_id', '__fanout_kind_type', '__fanout_kind_type__id', '__fanout_movie_keyword', '__fanout_movie_keyword__keyword_id', '__fanout_movie_keyword__movie_id', '__fanout_movie_companies', '__fanout_movie_companies__company_id', '__fanout_movie_companies__movie_id', '__fanout_movie_companies__company_type_id', '__fanout_complete_cast', '__fanout_complete_cast__subject_id', '__fanout_complete_cast__movie_id', '__fanout_link_type', '__fanout_link_type__id', '__fanout_char_name', '__fanout_char_name__id', '__fanout_role_type', '__fanout_role_type__id', '__fanout_name', '__fanout_name__id', '__fanout_info_type', '__fanout_info_type__id', '__fanout_keyword', '__fanout_keyword__id', '__fanout_company_name', '__fanout_company_name__id', '__fanout_company_type', '__fanout_company_type__id', '__fanout_comp_cast_type', '__fanout_comp_cast_type__id', '__fanout_aka_name', '__fanout_aka_name__person_id', '__fanout_person_info', '__fanout_person_info__person_id'],

}



TPCDS_FULL = dict(TPCDS_DEFAULT,
    **{
        'dataset': 'tpcds',
        'join_tables': ['item','store_sales',  'store_returns', 'catalog_sales', 'catalog_returns', 'web_sales', 'web_returns', 'inventory', 'promotion', 'date_dim', 'time_dim', 'customer', 'customer_demographics', 'household_demographics', 'customer_address', 'store', 'reason', 'call_center', 'catalog_page', 'ship_mode', 'warehouse', 'web_page', 'web_site', 'income_band'],
        'join_keys': {'item': ['i_item_sk'], 'catalog_returns': ['cr_item_sk',  'cr_call_center_sk',  'cr_catalog_page_sk',  'cr_refunded_addr_sk',  'cr_returned_date_sk',  'cr_returning_customer_sk'], 'catalog_sales': ['cs_item_sk',  'cs_bill_cdemo_sk',  'cs_bill_hdemo_sk',  'cs_promo_sk',  'cs_ship_mode_sk',  'cs_sold_time_sk',  'cs_warehouse_sk'], 'inventory': ['inv_item_sk'], 'store_returns': ['sr_item_sk', 'sr_reason_sk', 'sr_store_sk'], 'store_sales': ['ss_item_sk'], 'web_returns': ['wr_item_sk', 'wr_web_page_sk'], 'web_sales': ['ws_item_sk', 'ws_web_site_sk'], 'call_center': ['cc_call_center_sk'], 'catalog_page': ['cp_catalog_page_sk'], 'customer_address': ['ca_address_sk'], 'date_dim': ['d_date_sk'], 'customer': ['c_customer_sk'], 'customer_demographics': ['cd_demo_sk'], 'household_demographics': ['hd_demo_sk', 'hd_income_band_sk'], 'promotion': ['p_promo_sk'], 'ship_mode': ['sm_ship_mode_sk'], 'time_dim': ['t_time_sk'], 'warehouse': ['w_warehouse_sk'], 'reason': ['r_reason_sk'], 'store': ['s_store_sk'], 'web_page': ['wp_web_page_sk'], 'web_site': ['web_site_sk'], 'income_band': ['ib_income_band_sk']},
        'join_root': 'item',
        'join_clauses': ['item.i_item_sk=catalog_returns.cr_item_sk','item.i_item_sk=catalog_sales.cs_item_sk','item.i_item_sk=inventory.inv_item_sk','item.i_item_sk=store_returns.sr_item_sk','item.i_item_sk=store_sales.ss_item_sk','item.i_item_sk=web_returns.wr_item_sk','item.i_item_sk=web_sales.ws_item_sk','catalog_returns.cr_call_center_sk=call_center.cc_call_center_sk','catalog_returns.cr_catalog_page_sk=catalog_page.cp_catalog_page_sk','catalog_returns.cr_refunded_addr_sk=customer_address.ca_address_sk','catalog_returns.cr_returned_date_sk=date_dim.d_date_sk','catalog_returns.cr_returning_customer_sk=customer.c_customer_sk','catalog_sales.cs_bill_cdemo_sk=customer_demographics.cd_demo_sk','catalog_sales.cs_bill_hdemo_sk=household_demographics.hd_demo_sk','catalog_sales.cs_promo_sk=promotion.p_promo_sk','catalog_sales.cs_ship_mode_sk=ship_mode.sm_ship_mode_sk','catalog_sales.cs_sold_time_sk=time_dim.t_time_sk','catalog_sales.cs_warehouse_sk=warehouse.w_warehouse_sk','store_returns.sr_reason_sk=reason.r_reason_sk','store_returns.sr_store_sk=store.s_store_sk','web_returns.wr_web_page_sk=web_page.wp_web_page_sk','web_sales.ws_web_site_sk=web_site.web_site_sk','household_demographics.hd_income_band_sk=income_band.ib_income_band_sk'],
        'use_cols': 'tpcds-db',
        'data_dir': './datasets/tpcds_2_13_0/',
        'join_name': 'tpcds-full',
        'queries_csv': './queries/TPCDS_BENCHMARK_1000.csv',
        'factorize_blacklist' : ['__fanout_item', '__fanout_item__i_item_sk', '__fanout_catalog_returns', '__fanout_catalog_returns__cr_item_sk', '__fanout_catalog_returns__cr_call_center_sk', '__fanout_catalog_returns__cr_catalog_page_sk', '__fanout_catalog_returns__cr_refunded_addr_sk', '__fanout_catalog_returns__cr_returned_date_sk', '__fanout_catalog_returns__cr_returning_customer_sk', '__fanout_catalog_sales', '__fanout_catalog_sales__cs_item_sk', '__fanout_catalog_sales__cs_bill_cdemo_sk', '__fanout_catalog_sales__cs_bill_hdemo_sk', '__fanout_catalog_sales__cs_promo_sk', '__fanout_catalog_sales__cs_ship_mode_sk', '__fanout_catalog_sales__cs_sold_time_sk', '__fanout_catalog_sales__cs_warehouse_sk', '__fanout_inventory', '__fanout_inventory__inv_item_sk', '__fanout_store_returns', '__fanout_store_returns__sr_item_sk', '__fanout_store_returns__sr_reason_sk', '__fanout_store_returns__sr_store_sk', '__fanout_store_sales', '__fanout_store_sales__ss_item_sk', '__fanout_web_returns', '__fanout_web_returns__wr_item_sk', '__fanout_web_returns__wr_web_page_sk', '__fanout_web_sales', '__fanout_web_sales__ws_item_sk', '__fanout_web_sales__ws_web_site_sk', '__fanout_call_center', '__fanout_call_center__cc_call_center_sk', '__fanout_catalog_page', '__fanout_catalog_page__cp_catalog_page_sk', '__fanout_customer_address', '__fanout_customer_address__ca_address_sk', '__fanout_date_dim', '__fanout_date_dim__d_date_sk', '__fanout_customer', '__fanout_customer__c_customer_sk', '__fanout_customer_demographics', '__fanout_customer_demographics__cd_demo_sk', '__fanout_household_demographics', '__fanout_household_demographics__hd_demo_sk', '__fanout_household_demographics__hd_income_band_sk', '__fanout_promotion', '__fanout_promotion__p_promo_sk', '__fanout_ship_mode', '__fanout_ship_mode__sm_ship_mode_sk', '__fanout_time_dim', '__fanout_time_dim__t_time_sk', '__fanout_warehouse', '__fanout_warehouse__w_warehouse_sk', '__fanout_reason', '__fanout_reason__r_reason_sk', '__fanout_store', '__fanout_store__s_store_sk', '__fanout_web_page', '__fanout_web_page__wp_web_page_sk', '__fanout_web_site', '__fanout_web_site__web_site_sk', '__fanout_income_band', '__fanout_income_band__ib_income_band_sk'],
        'join_fds' : ['inventory.inv_item_sk=store_sales.ss_item_sk', 'web_sales.ws_web_site_sk=web_site.web_site_sk', 'catalog_returns.cr_item_sk=inventory.inv_item_sk', 'item.i_item_sk=store_returns.sr_item_sk', 'customer_address.ca_address_sk=catalog_returns.cr_refunded_addr_sk', 'household_demographics.hd_income_band_sk=income_band.ib_income_band_sk', 'store_sales.ss_item_sk=item.i_item_sk', 'catalog_sales.cs_ship_mode_sk=ship_mode.sm_ship_mode_sk', 'inventory.inv_item_sk=web_returns.wr_item_sk', 'catalog_sales.cs_item_sk=store_sales.ss_item_sk', 'catalog_sales.cs_sold_time_sk=time_dim.t_time_sk', 'store.s_store_sk=store_returns.sr_store_sk', 'item.i_item_sk=web_sales.ws_item_sk', 'store_returns.sr_item_sk=store_sales.ss_item_sk', 'catalog_returns.cr_item_sk=store_sales.ss_item_sk', 'warehouse.w_warehouse_sk=catalog_sales.cs_warehouse_sk', 'item.i_item_sk=store_sales.ss_item_sk', 'store_returns.sr_item_sk=item.i_item_sk', 'web_site.web_site_sk=web_sales.ws_web_site_sk', 'catalog_sales.cs_promo_sk=promotion.p_promo_sk', 'call_center.cc_call_center_sk=catalog_returns.cr_call_center_sk', 'item.i_item_sk=catalog_sales.cs_item_sk', 'web_returns.wr_web_page_sk=web_page.wp_web_page_sk', 'catalog_sales.cs_item_sk=inventory.inv_item_sk', 'web_returns.wr_item_sk=web_sales.ws_item_sk', 'web_page.wp_web_page_sk=web_returns.wr_web_page_sk', 'household_demographics.hd_demo_sk=catalog_sales.cs_bill_hdemo_sk', 'catalog_returns.cr_item_sk=web_returns.wr_item_sk', 'catalog_sales.cs_bill_hdemo_sk=household_demographics.hd_demo_sk', 'promotion.p_promo_sk=catalog_sales.cs_promo_sk', 'inventory.inv_item_sk=web_sales.ws_item_sk', 'catalog_sales.cs_item_sk=store_returns.sr_item_sk', 'income_band.ib_income_band_sk=household_demographics.hd_income_band_sk', 'item.i_item_sk=web_returns.wr_item_sk', 'catalog_page.cp_catalog_page_sk=catalog_returns.cr_catalog_page_sk', 'customer_demographics.cd_demo_sk=catalog_sales.cs_bill_cdemo_sk', 'customer.c_customer_sk=catalog_returns.cr_returning_customer_sk', 'catalog_returns.cr_item_sk=store_returns.sr_item_sk', 'time_dim.t_time_sk=catalog_sales.cs_sold_time_sk', 'reason.r_reason_sk=store_returns.sr_reason_sk', 'inventory.inv_item_sk=store_returns.sr_item_sk', 'store_returns.sr_store_sk=store.s_store_sk', 'store_sales.ss_item_sk=web_sales.ws_item_sk', 'catalog_returns.cr_item_sk=catalog_sales.cs_item_sk', 'catalog_sales.cs_item_sk=web_sales.ws_item_sk', 'store_returns.sr_item_sk=web_returns.wr_item_sk', 'ship_mode.sm_ship_mode_sk=catalog_sales.cs_ship_mode_sk', 'item.i_item_sk=inventory.inv_item_sk', 'catalog_sales.cs_item_sk=web_returns.wr_item_sk', 'inventory.inv_item_sk=item.i_item_sk', 'store_sales.ss_item_sk=web_returns.wr_item_sk', 'catalog_returns.cr_returned_date_sk=date_dim.d_date_sk', 'catalog_returns.cr_returning_customer_sk=customer.c_customer_sk', 'store_returns.sr_reason_sk=reason.r_reason_sk', 'web_sales.ws_item_sk=item.i_item_sk', 'date_dim.d_date_sk=catalog_returns.cr_returned_date_sk', 'store_returns.sr_item_sk=web_sales.ws_item_sk', 'catalog_returns.cr_item_sk=web_sales.ws_item_sk', 'catalog_returns.cr_item_sk=item.i_item_sk', 'item.i_item_sk=catalog_returns.cr_item_sk', 'catalog_returns.cr_refunded_addr_sk=customer_address.ca_address_sk', 'catalog_sales.cs_item_sk=item.i_item_sk', 'catalog_returns.cr_call_center_sk=call_center.cc_call_center_sk', 'catalog_sales.cs_bill_cdemo_sk=customer_demographics.cd_demo_sk', 'web_returns.wr_item_sk=item.i_item_sk', 'catalog_returns.cr_catalog_page_sk=catalog_page.cp_catalog_page_sk', 'catalog_sales.cs_warehouse_sk=warehouse.w_warehouse_sk'],

 })
TPCDS_BENCHMARK = dict(TPCDS_DEFAULT,
    **{
        'dataset': 'tpcds',
        'join_tables': ['item','store_sales',  'store_returns', 'catalog_sales', 'catalog_returns', 'web_sales', 'web_returns', 'inventory', 'promotion', 'date_dim', 'time_dim', 'customer', 'customer_demographics', 'household_demographics', 'customer_address', 'store', 'reason', 'call_center', 'catalog_page', 'ship_mode', 'warehouse', 'web_page', 'web_site', 'income_band'],
        'join_keys': {'item': ['i_item_sk'], 'catalog_returns': ['cr_item_sk',  'cr_call_center_sk',  'cr_catalog_page_sk',  'cr_refunded_addr_sk',  'cr_returned_date_sk',  'cr_returning_customer_sk'], 'catalog_sales': ['cs_item_sk',  'cs_bill_cdemo_sk',  'cs_bill_hdemo_sk',  'cs_promo_sk',  'cs_ship_mode_sk',  'cs_sold_time_sk',  'cs_warehouse_sk'], 'inventory': ['inv_item_sk'], 'store_returns': ['sr_item_sk', 'sr_reason_sk', 'sr_store_sk'], 'store_sales': ['ss_item_sk'], 'web_returns': ['wr_item_sk', 'wr_web_page_sk'], 'web_sales': ['ws_item_sk', 'ws_web_site_sk'], 'call_center': ['cc_call_center_sk'], 'catalog_page': ['cp_catalog_page_sk'], 'customer_address': ['ca_address_sk'], 'date_dim': ['d_date_sk'], 'customer': ['c_customer_sk'], 'customer_demographics': ['cd_demo_sk'], 'household_demographics': ['hd_demo_sk', 'hd_income_band_sk'], 'promotion': ['p_promo_sk'], 'ship_mode': ['sm_ship_mode_sk'], 'time_dim': ['t_time_sk'], 'warehouse': ['w_warehouse_sk'], 'reason': ['r_reason_sk'], 'store': ['s_store_sk'], 'web_page': ['wp_web_page_sk'], 'web_site': ['web_site_sk'], 'income_band': ['ib_income_band_sk']},
        'join_root': 'item',
        'join_clauses': ['item.i_item_sk=catalog_returns.cr_item_sk','item.i_item_sk=catalog_sales.cs_item_sk','item.i_item_sk=inventory.inv_item_sk','item.i_item_sk=store_returns.sr_item_sk','item.i_item_sk=store_sales.ss_item_sk','item.i_item_sk=web_returns.wr_item_sk','item.i_item_sk=web_sales.ws_item_sk','catalog_returns.cr_call_center_sk=call_center.cc_call_center_sk','catalog_returns.cr_catalog_page_sk=catalog_page.cp_catalog_page_sk','catalog_returns.cr_refunded_addr_sk=customer_address.ca_address_sk','catalog_returns.cr_returned_date_sk=date_dim.d_date_sk','catalog_returns.cr_returning_customer_sk=customer.c_customer_sk','catalog_sales.cs_bill_cdemo_sk=customer_demographics.cd_demo_sk','catalog_sales.cs_bill_hdemo_sk=household_demographics.hd_demo_sk','catalog_sales.cs_promo_sk=promotion.p_promo_sk','catalog_sales.cs_ship_mode_sk=ship_mode.sm_ship_mode_sk','catalog_sales.cs_sold_time_sk=time_dim.t_time_sk','catalog_sales.cs_warehouse_sk=warehouse.w_warehouse_sk','store_returns.sr_reason_sk=reason.r_reason_sk','store_returns.sr_store_sk=store.s_store_sk','web_returns.wr_web_page_sk=web_page.wp_web_page_sk','web_sales.ws_web_site_sk=web_site.web_site_sk','household_demographics.hd_income_band_sk=income_band.ib_income_band_sk'],
        'use_cols': 'tpcds-benchmark',
        'data_dir': './datasets/tpcds_2_13_0/',
        'join_name': 'tpcds-benchmark',
        'queries_csv': './queries/TPCDS_BENCHMARK_1000.csv',
        'factorize_blacklist' : ['__fanout_item', '__fanout_item__i_item_sk', '__fanout_catalog_returns', '__fanout_catalog_returns__cr_item_sk', '__fanout_catalog_returns__cr_call_center_sk', '__fanout_catalog_returns__cr_catalog_page_sk', '__fanout_catalog_returns__cr_refunded_addr_sk', '__fanout_catalog_returns__cr_returned_date_sk', '__fanout_catalog_returns__cr_returning_customer_sk', '__fanout_catalog_sales', '__fanout_catalog_sales__cs_item_sk', '__fanout_catalog_sales__cs_bill_cdemo_sk', '__fanout_catalog_sales__cs_bill_hdemo_sk', '__fanout_catalog_sales__cs_promo_sk', '__fanout_catalog_sales__cs_ship_mode_sk', '__fanout_catalog_sales__cs_sold_time_sk', '__fanout_catalog_sales__cs_warehouse_sk', '__fanout_inventory', '__fanout_inventory__inv_item_sk', '__fanout_store_returns', '__fanout_store_returns__sr_item_sk', '__fanout_store_returns__sr_reason_sk', '__fanout_store_returns__sr_store_sk', '__fanout_store_sales', '__fanout_store_sales__ss_item_sk', '__fanout_web_returns', '__fanout_web_returns__wr_item_sk', '__fanout_web_returns__wr_web_page_sk', '__fanout_web_sales', '__fanout_web_sales__ws_item_sk', '__fanout_web_sales__ws_web_site_sk', '__fanout_call_center', '__fanout_call_center__cc_call_center_sk', '__fanout_catalog_page', '__fanout_catalog_page__cp_catalog_page_sk', '__fanout_customer_address', '__fanout_customer_address__ca_address_sk', '__fanout_date_dim', '__fanout_date_dim__d_date_sk', '__fanout_customer', '__fanout_customer__c_customer_sk', '__fanout_customer_demographics', '__fanout_customer_demographics__cd_demo_sk', '__fanout_household_demographics', '__fanout_household_demographics__hd_demo_sk', '__fanout_household_demographics__hd_income_band_sk', '__fanout_promotion', '__fanout_promotion__p_promo_sk', '__fanout_ship_mode', '__fanout_ship_mode__sm_ship_mode_sk', '__fanout_time_dim', '__fanout_time_dim__t_time_sk', '__fanout_warehouse', '__fanout_warehouse__w_warehouse_sk', '__fanout_reason', '__fanout_reason__r_reason_sk', '__fanout_store', '__fanout_store__s_store_sk', '__fanout_web_page', '__fanout_web_page__wp_web_page_sk', '__fanout_web_site', '__fanout_web_site__web_site_sk', '__fanout_income_band', '__fanout_income_band__ib_income_band_sk'],
        'join_fds' : ['inventory.inv_item_sk=store_sales.ss_item_sk', 'web_sales.ws_web_site_sk=web_site.web_site_sk', 'catalog_returns.cr_item_sk=inventory.inv_item_sk', 'item.i_item_sk=store_returns.sr_item_sk', 'customer_address.ca_address_sk=catalog_returns.cr_refunded_addr_sk', 'household_demographics.hd_income_band_sk=income_band.ib_income_band_sk', 'store_sales.ss_item_sk=item.i_item_sk', 'catalog_sales.cs_ship_mode_sk=ship_mode.sm_ship_mode_sk', 'inventory.inv_item_sk=web_returns.wr_item_sk', 'catalog_sales.cs_item_sk=store_sales.ss_item_sk', 'catalog_sales.cs_sold_time_sk=time_dim.t_time_sk', 'store.s_store_sk=store_returns.sr_store_sk', 'item.i_item_sk=web_sales.ws_item_sk', 'store_returns.sr_item_sk=store_sales.ss_item_sk', 'catalog_returns.cr_item_sk=store_sales.ss_item_sk', 'warehouse.w_warehouse_sk=catalog_sales.cs_warehouse_sk', 'item.i_item_sk=store_sales.ss_item_sk', 'store_returns.sr_item_sk=item.i_item_sk', 'web_site.web_site_sk=web_sales.ws_web_site_sk', 'catalog_sales.cs_promo_sk=promotion.p_promo_sk', 'call_center.cc_call_center_sk=catalog_returns.cr_call_center_sk', 'item.i_item_sk=catalog_sales.cs_item_sk', 'web_returns.wr_web_page_sk=web_page.wp_web_page_sk', 'catalog_sales.cs_item_sk=inventory.inv_item_sk', 'web_returns.wr_item_sk=web_sales.ws_item_sk', 'web_page.wp_web_page_sk=web_returns.wr_web_page_sk', 'household_demographics.hd_demo_sk=catalog_sales.cs_bill_hdemo_sk', 'catalog_returns.cr_item_sk=web_returns.wr_item_sk', 'catalog_sales.cs_bill_hdemo_sk=household_demographics.hd_demo_sk', 'promotion.p_promo_sk=catalog_sales.cs_promo_sk', 'inventory.inv_item_sk=web_sales.ws_item_sk', 'catalog_sales.cs_item_sk=store_returns.sr_item_sk', 'income_band.ib_income_band_sk=household_demographics.hd_income_band_sk', 'item.i_item_sk=web_returns.wr_item_sk', 'catalog_page.cp_catalog_page_sk=catalog_returns.cr_catalog_page_sk', 'customer_demographics.cd_demo_sk=catalog_sales.cs_bill_cdemo_sk', 'customer.c_customer_sk=catalog_returns.cr_returning_customer_sk', 'catalog_returns.cr_item_sk=store_returns.sr_item_sk', 'time_dim.t_time_sk=catalog_sales.cs_sold_time_sk', 'reason.r_reason_sk=store_returns.sr_reason_sk', 'inventory.inv_item_sk=store_returns.sr_item_sk', 'store_returns.sr_store_sk=store.s_store_sk', 'store_sales.ss_item_sk=web_sales.ws_item_sk', 'catalog_returns.cr_item_sk=catalog_sales.cs_item_sk', 'catalog_sales.cs_item_sk=web_sales.ws_item_sk', 'store_returns.sr_item_sk=web_returns.wr_item_sk', 'ship_mode.sm_ship_mode_sk=catalog_sales.cs_ship_mode_sk', 'item.i_item_sk=inventory.inv_item_sk', 'catalog_sales.cs_item_sk=web_returns.wr_item_sk', 'inventory.inv_item_sk=item.i_item_sk', 'store_sales.ss_item_sk=web_returns.wr_item_sk', 'catalog_returns.cr_returned_date_sk=date_dim.d_date_sk', 'catalog_returns.cr_returning_customer_sk=customer.c_customer_sk', 'store_returns.sr_reason_sk=reason.r_reason_sk', 'web_sales.ws_item_sk=item.i_item_sk', 'date_dim.d_date_sk=catalog_returns.cr_returned_date_sk', 'store_returns.sr_item_sk=web_sales.ws_item_sk', 'catalog_returns.cr_item_sk=web_sales.ws_item_sk', 'catalog_returns.cr_item_sk=item.i_item_sk', 'item.i_item_sk=catalog_returns.cr_item_sk', 'catalog_returns.cr_refunded_addr_sk=customer_address.ca_address_sk', 'catalog_sales.cs_item_sk=item.i_item_sk', 'catalog_returns.cr_call_center_sk=call_center.cc_call_center_sk', 'catalog_sales.cs_bill_cdemo_sk=customer_demographics.cd_demo_sk', 'web_returns.wr_item_sk=item.i_item_sk', 'catalog_returns.cr_catalog_page_sk=catalog_page.cp_catalog_page_sk', 'catalog_sales.cs_warehouse_sk=warehouse.w_warehouse_sk'],
    })

SYN_MULTI = {
        'join_tables': ['table0','table1','table2','table3','table4','table5','table6','table7','table8','table9'],
        'join_keys': {'table0' : ['PK'], 'table1' : ['PK','FK'], 'table2' : ['PK','FK'], 'table3' : ['PK','FK'], 'table4' : ['PK','FK'], 'table5' : ['PK','FK'], 'table6' : ['PK','FK'], 'table7' : ['PK','FK'], 'table8' : ['PK','FK'], 'table9' : ['FK']},
        'join_root': 'table0',
        'join_clauses': ['table0.PK=table1.FK', 'table1.PK=table2.FK', 'table2.PK=table3.FK', 'table3.PK=table4.FK', 'table4.PK=table5.FK', 'table5.PK=table6.FK', 'table6.PK=table7.FK', 'table7.PK=table8.FK', 'table8.PK=table9.FK'],
        'use_cols': 'multi',
        'join_how': 'outer',
        'dataset': 'synthetic',
        'join_name' : 'syn_multi',
        'data_dir': 'datasets/table10_dom100_skew1.0_seed0/',
        'queries_csv': './queries/syn_multi_toy.csv' ,
        'eval_psamples': [512],
        'factorize_blacklist' : ['__fanout_table0',  '__fanout_table0__PK',  '__fanout_table1',  '__fanout_table1__PK',  '__fanout_table1__FK',  '__fanout_table2',  '__fanout_table2__PK',  '__fanout_table2__FK',  '__fanout_table3',  '__fanout_table3__PK',  '__fanout_table3__FK',  '__fanout_table4',  '__fanout_table4__PK',  '__fanout_table4__FK',  '__fanout_table5',  '__fanout_table5__PK',  '__fanout_table5__FK',  '__fanout_table6',  '__fanout_table6__PK',  '__fanout_table6__FK',  '__fanout_table7',  '__fanout_table7__PK',  '__fanout_table7__FK',  '__fanout_table8',  '__fanout_table8__PK',  '__fanout_table8__FK',  '__fanout_table9',  '__fanout_table9__FK'],
}

SYN_SINGLE = {
        'join_tables': ['table0'],
        'join_keys': {},
        'join_root': 'table0',
        'join_clauses': [],
        'use_cols': 'single',
        'join_how': 'outer',
        'dataset': 'synthetic',
        'join_name' : 'syn_single',
        'data_dir': 'datasets/col10_dom1000_skew1.0_corr0.8_seed0/',
        'queries_csv': './queries/syn_single_toy.csv',
        'eval_psamples': [512],
        'sep' :'#',
        'table_dropout' : False,
}

UPDATE_TEST = {
           'join_tables': ['title',  'movie_keyword'],
        'join_keys':{'title': ['id'],
                     'movie_keyword': [ 'movie_id'],
                     },
        'join_root': 'title',
        'join_clauses': ['title.id=movie_keyword.movie_id'],

        'dataset': 'imdb',
        'use_cols': 'imdb-db',
        'data_dir': './datasets/job_csv_export/',
        'join_name': 'imdb-full',
        'queries_csv': './queries/job-update-test.csv',
        'sampler_batch_size' : 128,
        'loader_workers': 1,
        'checkpoint_every_epoch': True,
        'eval_psamples': [512],
        'factorize_blacklist':['__fanout_title', '__fanout_title__id',  '__fanout_movie_keyword', '__fanout_movie_keyword__keyword_id', '__fanout_movie_keyword__movie_id'],
        'epochs': 1,
        'bs': 10,
        'max_steps' : 10,
        'accum_iter': 1,
        'fc_hiddens': 512,
        'layers' : 4,
        'embed_size' : 16,
        'word_size_bits': 14,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
}

### EXPERIMENT CONFIGS ###
EXPERIMENT_CONFIGS = {
    'update-t' : dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**UPDATE_TEST),**{
        'data_dir': './datasets/job_csv_export/',
    }),
    'update-p1' : dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**UPDATE_TEST),**{
        'data_dir': './datasets/job_update/part1/',
    }),
    'update-p2' : dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**UPDATE_TEST),**{
        'data_dir': './datasets/job_update/part2/',
    }),

    'tpcds-toy' : dict(TPCDS_TOY,**{
                'epochs': 20,
        'bs': 128,
        'max_steps': 10,
        'compute_test_loss' : True,

        'embed_size' : tune.choice([16]),
        'fc_hiddens': tune.choice([1024]),
        'word_size_bits':tune.choice([12]),
        'loader_workers': 1,
        'use_data_parallel' : True,
    }),

        'job-light-toy': dict(
        dict(BASE_CONFIG, **JOB_LIGHT_BASE),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'loader_workers': 4,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'loader_workers': 4,
            'epochs': 1,
            'bs':10,
            'max_steps':10,
            'num_eval_queries_per_iteration': 70,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
        }),
    'job-light': dict(
        dict(BASE_CONFIG, **JOB_LIGHT_BASE),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'loader_workers': 4,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'loader_workers': 4,
            'max_steps': tune.grid_search([500]),
            'epochs': 7,
            'num_eval_queries_per_iteration': 70,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
        }),
    'job-light-join-pred': dict(
        dict(BASE_CONFIG, **JOB_LIGHT_BASE),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'loader_workers': 4,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'loader_workers': 4,
            'max_steps': tune.grid_search([500]),
            'epochs': 7,
            'num_eval_queries_per_iteration': 70,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
        }),
    # JOB-light-ranges, NeuroCard base.
    'job-light-ranges': dict(
        dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **FACTORIZE),
        **{
            'queries_csv': './queries/job-light-ranges.csv',
            'use_cols': 'content',
            'num_eval_queries_per_iteration': 1000,
            # 10M tuples total.
            'max_steps': tune.grid_search([500]),
            'epochs': 10,
            # Evaluate after every 1M tuples trained.
            'epochs_per_iteration': 1,
            'loader_workers': 4,
            'eval_psamples': [8000],
            'input_no_emb_if_leq': False,
            'resmade_drop_prob': tune.grid_search([0]),
            'label_smoothing': tune.grid_search([0]),
            'fc_hiddens': 128,
            'embed_size': tune.grid_search([16]),
            'word_size_bits': tune.grid_search([14]),
            'table_dropout': False,
            'lr_scheduler': None,
            'warmups': 0.1,
        },
    ),
    'job-light-ranges-join-pred': dict(
        dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **FACTORIZE),
        **{
            'queries_csv': './queries/job-light-ranges.csv',
            'use_cols': 'content',
            'num_eval_queries_per_iteration': 1000,
            # 10M tuples total.
            'max_steps': tune.grid_search([500]),
            'epochs': 10,
            # Evaluate after every 1M tuples trained.
            'epochs_per_iteration': 1,
            'loader_workers': 4,
            'eval_psamples': [8000],
            'input_no_emb_if_leq': False,
            'resmade_drop_prob': tune.grid_search([0]),
            'label_smoothing': tune.grid_search([0]),
            'fc_hiddens': 128,
            'embed_size': tune.grid_search([16]),
            'word_size_bits': tune.grid_search([14]),
            'table_dropout': False,
            'lr_scheduler': None,
            'warmups': 0.1,
        },
    ),

    # JOB-M, NeuroCard.
    'job-m': dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),
    # JOB-M, NeuroCard-large (Transformer).

    'test-train-m': dict(
        dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
             **JOB_M_FACTORIZED),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'loader_workers': 4,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'loader_workers': 4,
            'max_steps': tune.grid_search([10]),
            'epochs': 1,
            'num_eval_queries_per_iteration': 5,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
        }),

    'toy_test': dict(
        dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
             **JOB_M_FACTORIZED),
        **{**TOY_TEST}),

    'toy_test-rev': dict(dict(
        dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
             **JOB_M_FACTORIZED),
        **{**TOY_TEST}),**{
        'join_tables' : ['C','B','A'],
        'join_keys' : { 'A' : ['x'], 'B':['x','y'], 'C':['y']},
        'join_clauses' : [ 'C.y=B.y','B.x=A.x'],
        'join_root': 'C',
    }),
    'job-m-rep-with-light-test' :dict(
        dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
             **JOB_M_FACTORIZED),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'loader_workers': 4,
            'max_steps': tune.grid_search([10]),
            'epochs': 1,
            'num_eval_queries_per_iteration': 5,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
            'queries_csv': './queries/job-light.csv',
        }),
    'job-m-rep-with-light-ranges-test': dict(
        dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
             **JOB_M_FACTORIZED),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'loader_workers': 4,
            'max_steps': tune.grid_search([10]),
            'epochs': 1,
            'num_eval_queries_per_iteration': 5,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
            'queries_csv': './queries/job-light-ranges.csv',
        }),

    'job-light-csv-test': dict(
        dict(BASE_CONFIG, **JOB_LIGHT_BASE),
        **{
            'factorize': True,
            'grouped_dropout': True,
            'loader_workers': 4,
            'warmups': 0.05,  # Ignored.
            'lr_scheduler': tune.grid_search(['OneCycleLR-0.28']),
            'max_steps': tune.grid_search([500]),
            'epochs': 7,
            'num_eval_queries_per_iteration': 70,
            'input_no_emb_if_leq': False,
            'eval_psamples': [8000],
            'epochs_per_iteration': 1,
            'resmade_drop_prob': tune.grid_search([.1]),
            'label_smoothing': tune.grid_search([0]),
            'word_size_bits': tune.grid_search([11]),
            'data_dir': 'datasets/job_csv_export/',
        }),
    # JOB-light-ranges, NeuroCard base.
    'job-light-ranges-csv-test': dict(
        dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **FACTORIZE),
        **{
            'queries_csv': './queries/job-light-ranges.csv',
            'use_cols': 'content',
            'num_eval_queries_per_iteration': 1000,
            # 10M tuples total.
            'max_steps': tune.grid_search([500]),
            'epochs': 10,
            # Evaluate after every 1M tuples trained.
            'epochs_per_iteration': 1,
            'loader_workers': 4,
            'eval_psamples': [8000],
            'input_no_emb_if_leq': False,
            'resmade_drop_prob': tune.grid_search([0]),
            'label_smoothing': tune.grid_search([0]),
            'fc_hiddens': 128,
            'embed_size': tune.grid_search([16]),
            'word_size_bits': tune.grid_search([14]),
            'table_dropout': False,
            'lr_scheduler': None,
            'warmups': 0.1,
            'data_dir': 'datasets/job_csv_export/',
        },
    ),
    'job-m-csv-test': dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                                **JOB_M_FACTORIZED), **{
        'data_dir': 'datasets/job_csv_export/',
    }),
    'job-toy': dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**JOB_TOY),



    'job-union-0616-tuning': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**JOB_UNION),**{
        'epochs': 200,
        'bs': 256,
        'accum_iter': 1,

        'fc_hiddens': tune.grid_search([2048, 128, 1024,256, 512,64]),
        'layers' : tune.grid_search([4,2,3]),
        'embed_size' : tune.grid_search([16,32]),
        'word_size_bits':tune.grid_search([11, 14 ]),
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
    }),


    'job-union': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**JOB_UNION),**{
        'epochs': 200,
        'bs': 256,
        'accum_iter': 1,

        'fc_hiddens': 2048,
        'layers' : 4,
        'embed_size' : 32,
        'word_size_bits':14,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
    }),


    'job-union-0616-tuning-test': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**JOB_UNION),**{
        'epochs': 2,
        'bs': 256,
        'accum_iter': 1,

        'fc_hiddens': 2048,
        'layers' : 4,
        'embed_size' : 32,
        'word_size_bits':14,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
    }),








    'syn-multi-tuning-test': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
              **JOB_M_FACTORIZED), **SYN_MULTI),**{
        'epochs': 2,
        'max_steps' : 10,
        'accum_iter': 1,
        'fc_hiddens': 2048,
        'layers' : 4,
        'embed_size' : 32,
        'word_size_bits':14,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,

    }),

    'syn-multi-0623-tuning': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
              **JOB_M_FACTORIZED), **SYN_MULTI),**{
        'epochs': 200,
        'max_steps' : 512,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
        'fc_hiddens': tune.grid_search([2048, 128, 1024,256, 512,64]),
        'layers' : tune.grid_search([4,2,3]),
        'embed_size' : tune.grid_search([16,32]),
        'word_size_bits':tune.grid_search([11, 14 ]),

    }),



    'imdb-full-0625-fine-tuning' : dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**IMDB_FULL),**{
        'embed_size' : 32,
        'fc_hiddens': tune.grid_search([2048,128,512, 256, 1024]),
        'word_size_bits': 14,
        'layers' : tune.grid_search([2,3,4]),
        'max_steps':512,
        'accum_iter': 1,
        'epochs' : 300,
        'bs':32,
        'compute_test_loss': False
    }),
    'imdb-full-0625-tuning-test' : dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**IMDB_FULL),**{
        'embed_size' : 32,
        'fc_hiddens': 2048,
        'word_size_bits': 14,
        'layers' :4,
        'max_steps':100,
        'accum_iter': 1,
        'epochs' : 2,
        'bs':32,
        'compute_test_loss': False
    }),
    'tpcds-full-0617-fine-tuning':  dict(TPCDS_BENCHMARK,**{
        'embed_size' : tune.grid_search([32]),
        'fc_hiddens': tune.grid_search([2048,512,1024]),
        'word_size_bits':tune.grid_search([14]),
        'layers' : tune.grid_search([4,2,3]),
        'max_steps':512,
        'accum_iter': 1,
        'epochs':300,
        'bs' : 128,
        'compute_test_loss': False,
        'queries_csv':'./queries/TPCDS_BENCHMARK_TOY.csv',
        'use_cols': 'tpcds-db',
        'data_dir': './datasets/tpcds_2_13_0/',
        'join_name': 'tpcds-full',
    }),
    'tpcds-full-0617-tuning-test':  dict(TPCDS_BENCHMARK,**{
        'embed_size' : 32,
        'fc_hiddens': 2048,
        'word_size_bits':14,
        'layers' : 4,
        'max_steps':512,
        'accum_iter': 1,
        'epochs':300,
        'bs' : 128,
        'compute_test_loss': False,
        'queries_csv':'./queries/TPCDS_BENCHMARK_TOY.csv',
        'use_cols': 'tpcds-db',
        'data_dir': './datasets/tpcds_2_13_0/',
        'join_name': 'tpcds-full',
    }),

    'tpcds-benchmark-exp-0615':  dict(TPCDS_BENCHMARK,**{
        'epochs':300,
        'bs' : 256,
        'layers' : 4,
        'fc_hiddens': 2048,
        'word_size_bits':14,
        'embed_size' : 32,
        'max_steps':512,
        'accum_iter': 1,
        'queries_csv':'./queries/TPCDS_BENCHMARK.csv',
        'compute_test_loss': False,

    }),



    'imdb-full' : dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
                  **JOB_M_FACTORIZED),**IMDB_FULL),**{
        'embed_size' : 32,
        'fc_hiddens': 2048,
        'word_size_bits': 14,
        'layers' : 2,
        'max_steps':512,
        'accum_iter': 1,
        'epochs' : 300,
        'bs':32,
        'compute_test_loss': False
    }),


    'tpcds-benchmark':  dict(TPCDS_BENCHMARK,**{
        'epochs':300,
        'bs' : 256,
        'layers' : 4,
        'fc_hiddens': 2048,
        'word_size_bits':14,
        'embed_size' : 32,
        'max_steps':512,
        'accum_iter': 1,
        'compute_test_loss': False,

    }),

    'tpcds-full':  dict(TPCDS_BENCHMARK,**{

        'embed_size' : 32,
        'fc_hiddens': 2048,
        'word_size_bits':14,
        'layers' : 4,
        'max_steps':512,
        'accum_iter': 1,
        'epochs':280,
        'bs' : 128,
        'compute_test_loss': False,
        'queries_csv':'./queries/TPCDS_BENCHMARK_TOY.csv',
        'use_cols': 'tpcds-db',
        'data_dir': './datasets/tpcds_2_13_0/',
        'join_name': 'tpcds-full',
    }),

    'syn-single-tuning-test': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
              **JOB_M_FACTORIZED), **SYN_SINGLE),**{
        'epochs': 2,
        'accum_iter': 1,
        'fc_hiddens': 2048,
        'layers' : 4,
        'embed_size' : 32,
        'word_size_bits':14,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,

    }),
    'syn-single-0625-tuning': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
              **JOB_M_FACTORIZED), **SYN_SINGLE),**{
        'epochs': 200,
        'max_steps' : 512,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
        'fc_hiddens': tune.grid_search([2048, 128, 1024,256, 512,64]),
        'layers' : tune.grid_search([4,2,3]),
        'embed_size' : tune.grid_search([16,32]),
        'word_size_bits':tune.grid_search([11, 14 ]),
    }),

    'syn-single': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
              **JOB_M_FACTORIZED), **SYN_SINGLE),**{
        'epochs': 200,
        'max_steps' : 512,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
        'fc_hiddens': 2048,
        'layers' : 4,
        'embed_size' : 32,
        'word_size_bits': 14,
    }),

    'syn-multi': dict(dict(dict(dict(dict(BASE_CONFIG, **JOB_LIGHT_BASE), **JOB_M),
              **JOB_M_FACTORIZED), **SYN_MULTI),**{
        'epochs': 200,
        'max_steps' : 512,
        'use_data_parallel':False,
        'compute_test_loss': False,
        'num_eval_queries_per_iteration':0,
        'fc_hiddens': 2048,
        'layers' : 4,
        'embed_size' : 32,
        'word_size_bits': 14,

    }),

}
# Run multiple experiments concurrently by using the --run flag, ex:
# $ ./run.py --run job-light

######  TEST CONFIGS ######
# These are run by default if you don't specify --run.

# ------------------------------
TEST_CONFIGS['exp-syn_single'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/syn_single_1000.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/syn-single.tar',
        'eval_psamples': [512],
    })

TEST_CONFIGS['exp-syn_multi'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/syn_multi_1000.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/syn-multi.tar',
        'eval_psamples': [512],
    })



TEST_CONFIGS['exp-imdb_full-imdb_full'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/IMDB_FULL_1000.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-imdb_full-job_light'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/job-light.csv',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-imdb_full-job_m'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/job-m.csv',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })

TEST_CONFIGS['exp-imdb_full-light_Synthetic'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/job-light-syn.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-imdb_full-job_union_Synthetic'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/job-union-syn.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })

TEST_CONFIGS['exp-imdb_full'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/imdb-full-syn.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })


TEST_CONFIGS['exp-job_union-union_synthethic-sample100'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-union-syn-100.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-imdb_full-sample100'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/imdb-full-syn-100.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-imdb_full-job_union_Synthetic-sample100'] = dict(
    EXPERIMENT_CONFIGS['imdb-full'], **{
        'queries_csv': './queries/job-union-syn-100.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/imdb-full.tar',
        'eval_psamples': [512],
    })


TEST_CONFIGS['exp-tpcds_full'] = dict(
    EXPERIMENT_CONFIGS['tpcds-full'], **{
        'queries_csv': './queries/tpcds-full-test-1k.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/tpcds-full.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-tpcds_full-tpcds_benchmark'] = dict(
    EXPERIMENT_CONFIGS['tpcds-full'], **{
        'queries_csv': './queries/TPCDS_BENCHMARK_367.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/tpcds-full.tar',
        'eval_psamples': [512],
    })

TEST_CONFIGS['exp-tpcds_benchmark'] = dict(
    EXPERIMENT_CONFIGS['tpcds-benchmark'], **{
        'queries_csv': './queries/TPCDS_BENCHMARK_367.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/tpcds-benchmark.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-job_union-union_synthethic'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-union-syn.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-job_union-light_synthethic'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-light-syn.out',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-job_union-job_light'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-light.csv',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-job_union-job_light-p8000'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-light.csv',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [8000],
    })
TEST_CONFIGS['exp-job_union-job_m'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-m.csv',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [512],
    })
TEST_CONFIGS['exp-job_union-job_m-p8000'] = dict(
    EXPERIMENT_CONFIGS['job-union'], **{
        'queries_csv': './queries/job-m.csv',
        'checkpoint_to_load': '/mnt/disk2/jsjeong/final_models/job-union.tar',
        'eval_psamples': [8000],
    })


for name in TEST_CONFIGS:
    TEST_CONFIGS[name].update({'save_checkpoint_at_end': False})
    # +@ change mode
    TEST_CONFIGS[name].update({'mode': 'INFERENCE'})
EXPERIMENT_CONFIGS.update(TEST_CONFIGS)