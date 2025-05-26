#!/bin/bash
current_date_time=$(date +"%Y-%m-%d %T")
echo "Starting cron load_ohlcv_from_polygon.sh at $current_date_time"
touch /home/ubuntuuser/cronlogs/cron_load_ohlcv_from_polygon.start
source /home/ubuntuuser/miniconda3/etc/profile.d/conda.sh
echo "Activate polygon environment"
conda activate polygon
export PYTHONPATH=${HOME}/karra
echo $PYTHONPATH
cd /home/ubuntuuser/karra/securities_load/
echo $PWD
psql --host localhost --port 5432 --dbname securities --username securities < /home/ubuntuuser/karra/securities_load/sql/delete_all_from_polygon_ohlcv.sql
echo "Finished deleting any rows in polygon.ohlcv at $current_date_time"
echo "Starting cron load_ohlcv_from_polygon.py at $current_date_time"
python /home/ubuntuuser/karra/securities_load/load_polygon/run_load_ohlcv_from_polygon.py
touch /home/ubuntuuser/cronlogs/cron_load_ohlcv_from_polygon.end
current_date_time=$(date +"%Y-%m-%d %T")
echo "Finished cron load_ohlcv_from_polygon.sh at $current_date_time"
