sudo apt install docker.io -y
docker run -d -p 5000:5000 --restart always --name registry -v registry-data:/var/lib/registry:Z -e REGISTRY_STORAGE_DELETE_ENABLED=true docker.io/library/registry:3

echo ' crontab -e'
echo '0 0 * * * docker exec registry sh -c "rm -rf /var/lib/registry/docker/registry/v2/*"; docker stop registry; docker start registry;'

# crontab -e
# 0 0 * * * docker exec registry sh -c "rm -rf /var/lib/registry/docker/registry/v2/*"; docker stop registry; docker start registry;

#################################################################################
#curl -I -H "Accept: application/vnd.oci.image.index.v1+json, application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.docker.distribution.manifest.v2+json" http://localhost:5000/v2/alpine/manifests/latest

#REPO=alpine TAG=latest REG=http://localhost:5000; \
#D=$(curl -sI -H 'Accept: application/vnd.oci.image.index.v1+json, application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.docker.distribution.manifest.v2+json' \
#"$REG/v2/$REPO/manifests/$TAG" | awk -F': ' 'tolower($1)=="docker-content-digest"{gsub("\r","",$2); print $2}'); \
#echo "digest=$D"; curl -i -X DELETE "$REG/v2/$REPO/manifests/$D"

#########################################################
# podman pull alpine:latest
# podman tag alpine:latest localhost:5000/alpine:latest
# podman push --tls-verify=false localhost:5000/alpine:latest localhost:5000/alpine:latest
# podman pull --tls-verify=false localhost:5000/alpine:latest

#########################################################
# /etc/docker/daemon.json
# {"insecure-registries":["localhost:5000"]}
# systemctl restart docker.service docker.socket containerd.service

# docker pull alpine:latest
# docker tag alpine:latest localhost:5000/alpine:latest
# docker push localhost:5000/alpine:latest localhost:5000/alpine:latest
# docker pull localhost:5000/alpine:latest
