sudo  -iu enterprisedb bash << 'EOF'
export PG_VERSION=17
export PATH=$PATH:/usr/edb/pge$PG_VERSION/bin/
export PGDATA=/var/lib/edb-pge/$PG_VERSION/data/
export PGPASSWORD=secret

export user=enterprisedb
export port=5432
export dbname=pgddb

db1_dsn="host=db-1 user=$user port=$port dbname=$dbname"
db2_dsn="host=db-2 user=$user port=$port dbname=$dbname"
db3_dsn="host=db-3 user=$user port=$port dbname=$dbname"

case $1 in
  db-1)
    pgd node node-1 setup --dsn "$db1_dsn"  --group-name group-1
    ;;
  db-2)
    pgd node node-2 setup --dsn "$db2_dsn"  --group-name group-1 --cluster-dsn "$db1_dsn"
    ;;
  db-3)
    pgd node node-3 setup --dsn "$db3_dsn"  --group-name group-1 --cluster-dsn "$db1_dsn"
    ;;
  *)
    echo "ERROR: UNKNOWN host"
    exit 0
    ;;
esac

EOF