import os
import hkkang_utils.file as file_utils

# Path
config_file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../config.yml")
# Config
config = file_utils.read_config_file(config_file_path)