# 🅱️ (MärkeDB / MarkedB)

[Inspired by discussion of a patch database on the OVS Discord](https://discord.com/channels/950003255952433202/1030562619112816731/1180188833745219707)

## Starting a local development environment
The local development environment requires either Linux or MacOS. It might be possible to run it in WSL on Windows.
1. Install Docker, and make sure it is running.
2. Run `d/install.sh`
3. Run `d/start.sh`
4. The Tilt dashboard is now available at [http://localhost:10350/](http://localhost:10350/),
and the local markedb site will be available shortly at [http://localhost:8080/](http://localhost:8080/).   
There is also a database available at [postgresql://root:root@localhost:5432/markedb](postgresql://root:root@localhost:5432/markedb),
which you can connect to, using psql, with `psql postgresql://root:root@localhost:5432/markedb`.
5. To shutdown the local dev environment and clean up the kubernetes cluster, run `d/exit.sh`.

## Postgres Database

### Migrations
