# 🅱️ (MärkeDB / MarkedB)

A patch database

[Inspired by discussion of a patch database on the OVS Discord](https://discord.com/channels/950003255952433202/1030562619112816731/1180188833745219707)

## Starting a local development environment
The local development environment requires either Linux or MacOS. It might be possible to run it in WSL on Windows.
1. Install Docker, and make sure it is running.
2. Run `d/install.sh`
3. Run `d/start.sh`
4. The Tilt dashboard is now available at [http://localhost:10350/](http://localhost:10350/),
and the local markedb site will be available shortly at [http://localhost:8080/](http://localhost:8080/).   

5. You can also connect to the database with psql using the following commands (Run them in separate terminals):
```commandline
kubectl port-forward postgresql-0 5432
```
```commandline
export dbpassword="$(kubectl get secret root.postgresql.credentials.postgresql.acid.zalan.do -o json | jq -r .data.password | base64 -d)"
psql "postgresql://root:$dbpassword@localhost:5432/markedb"
```
5. To shutdown the local dev environment and clean up the kubernetes cluster, run `d/exit.sh`.

## Postgres Database

### Migrations
(Tutorial used: https://dev.to/behainguyen/rust-sqlx-cli-database-migration-with-mysql-and-postgresql-42gp)
1. Install the sqlx cli
```commandline
cargo install sqlx-cli --no-default-features -F rustls,postgres
```    
([Install rustup](https://doc.rust-lang.org/cargo/getting-started/installation.html) if you don't have cargo)
2. Create a new migration file in backend/migrations with the following command
```commandline
sqlx migrate add -r "Add foo Table"
```
3. Add sql to the new files. The up file modifies the database, the down file undoes the modifications.
4. Your new migrations will now be run automatically by Kubernetes when deployed.
