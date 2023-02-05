import random
from src.utils.pg_connector import PostgresConnector

TASK_TYPES = [0, 1]

class Task_Generator():
    def __init__(self, admin_db_config, data_db_config):
        self.admin_db_config = admin_db_config
        self.data_db_config = data_db_config
        self.admin_db_connector = PostgresConnector(admin_db_config["userid"],
                                                    admin_db_config["passwd"],
                                                    admin_db_config["host"],
                                                    admin_db_config["port"],
                                                    admin_db_config["db_name"])
        self.data_db_connector = PostgresConnector(data_db_config["userid"], 
                                              data_db_config["passwd"], 
                                              data_db_config["host"], 
                                              data_db_config["port"], 
                                              data_db_config["db_name"])              
        
    @property
    def query_goal_dic(self):
        # Read in query goals from database
        results = self.admin_db_connector.execute(f"SELECT * FROM {self.admin_db_config['table_name']}")
        return {item[0]: item[1] for item in results}
    
    @property
    def collected_data(self):
        cnt_dic = {key: 0 for key in self.query_goal_dic.keys()}
        # Read in collected data from database
        results = self.data_db_connector.execute(f"SELECT * FROM {self.data_db_config['table_name']}")
        for result in results:
            query_type = result[4]
            if query_type in cnt_dic:
                cnt_dic[query_type] += 1
            else:
                cnt_dic[query_type] = 0
        return cnt_dic
        
    def _selecte_query_type(self):
        """ Randomly select a query type to generate """
        # Read goal number of queries for each query type
        query_goal_dic = self.query_goal_dic
        
        # Get Stat. for collected data
        collected_data = self.collected_data
        
        # Figure out remaining target query type
        for key, value in collected_data.items():
            if key in query_goal_dic.keys():
                query_goal_dic[key] -= value
                
        remaining_types = [key for key, value in query_goal_dic.items() if value > 0]
                
        # Randomly select one from the remaining query types
        selected_type = random.choice(remaining_types)
        
        return selected_type        
    
    def _select_task_type(self):
        """ Randomly select a task type to generate """
        selected_type = random.choice(TASK_TYPES)
        
        return selected_typex    
    
    def __call__(self):
        # Select a query type to generate
        query_type = self._selecte_query_type()
        
        
        return None

if __name__ == "__main__":
    admin_db_config = {
        "host": "localhost", 
        "userid": "config_user", 
        "passwd": "config_user_pw", 
        "port": "5432", 
        "db_name": "proda_config",
        "table_name": "query_goal"}

    data_db_config = {
        "host": "localhost", 
        "userid": "collection_user", 
        "passwd": "collection_user_pw", 
        "port": "5432", 
        "db_name": "proda_collection",
        "table_name": "collection"}
        
    task_generator = Task_Generator(admin_db_config, data_db_config)
    tmp = task_generator()
    stop = 1
    pass