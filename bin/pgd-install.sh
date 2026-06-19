
T=/tmp/instruqt-setup.log

if [ -f $HOME/.edb-env ]; then
  source $HOME/.edb-env
fi


if [ -z $EDB_SUBSCRIPTION_TOKEN ]; then
  echo "Subscription token not set - chickening out of script"
  exit 0
fi

# For PGD Expanded, there are two repositories to install.
echo "Adding repositories"
curl -1sSLf "https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/$EDB_SUBSCRIPTION_PLAN/setup.$EDB_REPO_TYPE.sh" | sudo -E bash
curl -1sSLf "https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/postgres_distributed/setup.$EDB_REPO_TYPE.sh" | sudo -E bash



export PG_VERSION=17
export EDB_PACKAGES="edb-as$PG_VERSION-server edb-pgd6-expanded-epas$PG_VERSION edb-pgd6-cli"
export PATH="$PATH:/usr/lib/edb-as/$PG_VERSION/bin"
echo "Install $EDB_PACKAGES"
sudo apt install -y $EDB_PACKAGES


sudo -iu enterprisedb bash <<'EOF'
psql edb -c "SELECT pg_reload_conf();" -c "ALTER USER enterprisedb PASSWORD 'secret'"
EOF