docker login 
# jinjia  # email: jinjiakarl@outlook.com

cd ./containers/LaboratoriesNS-master/sa-frontend
npm install
npm build
docker build -t jinjia/sa-frontend:v1 .
docker push jinjia/sa-frontend:v1
docker run --rm -p 80:80 jinjia/sa-frontend:v1

cd -

cd ./containers/LaboratoriesNS-master/sa-logic
docker build -t jinjia/sa-logic:v1 .
docker push jinjia/sa-logic:v1
docker run --rm -p 5050:5000 jinjia/sa-logic:v1

cd -
cd ./containers/LaboratoriesNS-master/sa-webapp
mvn install
# find ip
docker inspect \
  -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' `docker ps | grep logic | awk '{print $1}'`
docker build -t jinjia/sa-webapp:v1 .
docker push jinjia/sa-webapp:v1
docker run --rm -p 8080:8080 jinjia/sa-webapp:v1



# docker run -it --rm ubuntu bash
# curl --location 'http://172.17.0.2:5000/analyse/sentiment' \
# --header 'Content-Type: application/json' \
# --data '{
#     "sentence": "test"
# }'

# curl --location 'http://172.17.0.3:8080/sentiment' \
# --header 'Content-Type: application/json' \
# --data '{
#     "sentence": "test"
# }'