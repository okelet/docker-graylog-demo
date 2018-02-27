
# Docker Graylog Demo

Full Graylog environment:

* MongoDB server
* Elasticsearch server
* Graylog server + Graylog web UI
* Helper to create inputs and send some data


## How to use

Clone the repo:

```
git clone https://github.com/okelet/docker-graylog-demo
cd docker-graylog-demo
```

Create the environment:

```
docker-compose up -d --build
```

The provision can take some minutes (mostly setting up the database); you can monitor the LOGs using the command below.

Once finished, you can access the Graylog Web UI using the URL [http://localhost:9000](http://localhost:9000), and the username `admin` and the password `admin`. Helper should have created some LOG messages that can be viewed in the search section.

To view the LOGs:

```
docker-compose logs -f
```

Stop the environment:

```
docker-compose stop
```

Destroy the environment:

```
docker-compose rm
```
