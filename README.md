# NCDC-NRL Data Request System
A data request system with integrated review and approval workflows.

The following are packaged:
 - CKAN Instance (localhost:5000)
 - Zeebe Broker
 - Zeebe Simple Monitor (localhost:8082)
 - Aether Stream Consumer (localhost:9013)
 - Zeebe Tester (this app)

## Installation

### Clone Repo
First clone this repo:

```bash
git clone https://github.com/eHealthAfrica/ncdc-nrl.git
cd ncdc-nrl
```

### Setup environment variables
Make a copy of `.env-sample` rename as `.env` and change it with your desired options

### Add host entry and configure IP
You will also need to add an entry to your /etc/hosts or C:\Windows\System32\Drivers\etc\hosts file. It should look something like this:
```
127.0.0.1  ncdc-nrl.local  # (`LOCAL_HOST` environment variable value)
```

Now edit the `extra_hosts` property in the `docker-compose.yml` file, replacing the IP with your current IP
```
docker-compose.yml --> services --> consumer --> extra_hosts
```

### Start Up
If this is the first time you are running this app, use the following commands to startup (One time use only)
```bash
./scripts/init.sh && ./scripts/start.sh
```

Subsequently, use the follow to startup
```bash
./scripts/start.sh
```

You should now be able to access the following resource
`http://ncdc-nrl.local:8082/views/workflows`

### Stop
To stop the app, use the following command
```bash
./scripts/stop.sh
```

## Usage


