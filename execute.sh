docker-compose down
docker-compose build
docker-compose up -d
docker exec -it flexmeasures-worker-1 bash ./do.sh
# docker exec -it flexmeasures-worker-1 bash