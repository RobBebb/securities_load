# Procedure to move changes from dev to prod

## python loading code

Run alter.pgsql against securities database (prod)

Copy dev\securities_load\dags to prod\securities_load\dags

```cmd
cp -r ./karra/securities_load/dags/ ./prod/securities_load/
```

Copy karra\securities_load\load_polygon\polygon*.py to prod\securities_load\load_polygon\

```cmd
cp -r ./karra/securities_load/load_polygon/polygon*.py ./prod/securities_load/load_polygon
```

Copy karra\securities_load\load_asx\*.py to prod\securities_load\load_asx\

```cmd
cp -r ./karra/securities_load/load_asx/*.py ./prod/securities_load/load_asx
```

Copy dev\securities_load\load_yahoo\yahoo*.py to prod\securities_load\load_yahoo\yahoo*.py

```cmd
cp -r ./karra/securities_load/load_yahoo/yahoo*.py ./prod/securities_load/load_yahoo
```

Copy dev\securities_load\load_ib\ib*.py to prod\securities_load\load_ib\

```cmd
cp -r ./karra/securities_load/load_ibd/ib*.py ./prod/securities_load/load_ib
```

Copy dev\securities_load\securities\*.py to prod\securities_load\securities\

```cmd
cp -r ./karra/securities_load/securities/*.py ./prod/securities_load/securities
```

Copy dev\securities_load\data\*.* to prod\securities_load\data\

```cmd
cp -r ./karra/securities_load/data/*.* ./prod/securities_load/data
```


## dags

dags are only tested in prod

## SQL

An alter filw will be set up to update the database in dev. This will then be used in prod.
