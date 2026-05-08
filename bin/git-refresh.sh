cd ~/instruqt-pgd-v6
git pull
for vm in db-1 db-2 db-3; do
  ssh $vm "cd ~/instruqt-pgd-v6 && git pull"
done
