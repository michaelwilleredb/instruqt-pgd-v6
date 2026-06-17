
At this point we have the three servers db-1, db-2 and db-3 provisioned and running. 

---

NOTE: This demo is NOT a workshop. It is not supposed 
to be shared with participants - unless a temporary EDB Subscription Token is used

---

### Set EDB Suscription token on all servers

The following command will export your download token to all the database servers.

```bash
set-token.sh "---YOUR TOKEN---"
```

### Install EPAS and PGD
Next step is to install EDB Advanced Server and PGD on all three servers.

```bash
run-on-all-dbs.sh "$HOME/instruqt-pgd-v6/bin/pgd-install.sh"
```

Note that the install of EPAS and PGD libraries runs in parallel on all servers.

Once this has completed, you can move on to the next challenge.
