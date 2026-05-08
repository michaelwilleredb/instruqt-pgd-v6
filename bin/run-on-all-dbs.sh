for vm in db-1 db-2 db-3;
do
  echo "Running on $vm"
  ssh -o "StrictHostKeyChecking=no" $vm "$1"
done