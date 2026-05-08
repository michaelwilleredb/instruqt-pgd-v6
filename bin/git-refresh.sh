git clone https://github.com/michaelwilleredb/instruqt-pgd-v6.git
for vm in db-1 db-2 db-3; do
  ssh $vm "git clone https://github.com/michaelwilleredb/instruqt-pgd-v6.git"
done
