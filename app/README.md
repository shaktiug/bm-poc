# Devops API App

## Install the python packages for the api tier:

```sh
â†’ pip install -r requirements.txt 
```

## start the app

```sh
â†’ python -m flask run bm.py
```

## NOTE this app uses these env variables:

- PORT: the listening PORT
- DB: Name of the database to connect
- DBUSER: Database user
- DBPASS: DB user password,
- DBHOST: Database hostname,
- DBPORT: Database server listening port

These variables need to be set