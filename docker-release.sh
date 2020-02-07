set -e

IMAGE_NAME=nobodysnightmare/energy
COMMIT=$(git rev-parse HEAD)

docker build -t $IMAGE_NAME:latest .
docker tag $IMAGE_NAME:latest $IMAGE_NAME:$COMMIT
docker push $IMAGE_NAME:latest
docker push $IMAGE_NAME:$COMMIT
