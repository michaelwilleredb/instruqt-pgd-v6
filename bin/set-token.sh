cd $HOME
if [ -z $1 ];
then
  echo "Usage: $0 <token>"
  exit 1
fi
if grep -q "edb-env" .bashrc;
then
  echo "EDB_SUBSCRIPTION_TOKEN already set, skipping"
else
  echo "source ~/.edb-env" >> ~/.bashrc
fi
echo "Setting EDB_SUBSCRIPION_TOKEN"
echo "export EDB_SUBSCRIPION_TOKEN=$1" > .edb-env
echo "export EDB_SUBSCRIPTION_PLAN=enterprise" >> .edb-env
echo "export EDB_REPO_TYPE=deb" >> .edb-env
