# Procedure to move changes from dev to prod

## python loading code

1. Copy dev\securities_load\load_polygon\polygon*.py to prod\securities_load\load_polygon\polygon*.py
2. Copy dev\securities_load\load_yahoo\yahoo*.py to prod\securities_load\load_yahoo\yahoo*.py
3. Copy dev\securities_load\load_ib\ib*.py to prod\securities_load\load_ib\ib*.py

## dags

dags are only tested in prod

## SQL

An alter filw will be set up to update the database in dev. This will then be used in prod.
