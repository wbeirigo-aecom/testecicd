docker build . -t cicdteste --platform linux/amd64 --no-cache

docker run --restart=always -m 512m --cpus=1 --name cicdteste -it -d -p 8611:8000 cicdeste