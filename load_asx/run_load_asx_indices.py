import pandas as pd
from dotenv import load_dotenv

from securities_load.load_asx.load_asx_indices import load_asx_indices

load_dotenv()

load_asx_indices()
