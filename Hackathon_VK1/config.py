from pathlib import Path

RANDOM_STATE = 42

DATA_DIR_PATH:Path = Path('/Users/22211945/data/univer/sem_11/hackathon/')
GEO_INFO_FILE_PATH:Path = DATA_DIR_PATH / 'geo_info.csv'
REFERER_VECTORS_FILE_PATH:Path = DATA_DIR_PATH / 'referer_vectors.csv'
TEST_FILE_PATH:Path = DATA_DIR_PATH / 'test.csv'
TEST_USERS_FILE_PATH:Path = DATA_DIR_PATH / 'test_users.csv'
TRAIN_USERS_FILE_PATH:Path = DATA_DIR_PATH / 'train.csv'
TRAIN_LABELS_FILE_PATH:Path = DATA_DIR_PATH / 'train_labels.csv'

USER_AGENT_FIELD_NAME:str = 'user_agent'
REFERER_FIELD_NAME:str = 'referer'
USER_ID_FIELD_NAME:str = 'user_id'
TARGET_FIELD_NAME:str = 'target'
GEO_ID_FIELD_NAME:str = 'geo_id'
DOMAIN_URL_SEP = '//'
DOMAIN_PATH_SEP = '/'

