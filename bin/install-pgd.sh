
T=/tmp/instruqt-setup.log

if [ -z $EDB_SUBSCRIPTION_TOKEN ]; then
  echo "Subscription token not set - chickening out of script" >> $T
  exit 0
fi
# For PGD Expanded, there are two repositories to install.
echo "Adding repositories" >> $T
echo "EDB_SUBSCRIPTION_TOKEN = $EDB_SUBSCRIPTION_TOKEN / $EDB_SUBSCRIPTION_PLAN" >> $T
curl -1sSLf " https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/$EDB_SUBSCRIPTION_PLAN/setup.$EDB_REPO_TYPE.sh" | sudo -E bash
curl -1sSLf " https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/postgres_distributed/setup.$EDB_REPO_TYPE.sh" | sudo -E bash


export PG_VERSION=17
export EDB_PACKAGES="edb-as$PG_VERSION-server edb-pgd6-expanded-epas$PG_VERSION"
echo "Install $EDB_PACKAGES" >> $T
sudo apt install -y $EDB_PACKAGES && echo "Install completed successfully" >> $T 