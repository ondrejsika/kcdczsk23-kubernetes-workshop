IMAGE = ondrejsika/kcdczsk23-server
#IMAGE = reg.istry.cz/ondrejsika/kcdczsk23-server

help:
	@echo "See Makefile"

setup:
	k3d cluster create demo \
		--servers 3 \
		-p 80:80@loadbalancer \
		-p 443:443@loadbalancer \
		--k3s-arg '--disable=traefik@server:*'

install-ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml
	kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx --timeout=120s

install-hello-world:
	helm upgrade --install \
		hello \
		hello-world --repo https://helm.sikalabs.io \
		--values hello-world.values.yaml \
		--wait

uninstall-hello-world:
	helm uninstall hello

build:
	docker build --platform linux/amd64 -t ${IMAGE} .

push:
	docker push ${IMAGE}

install-from-manifest:
	kubectl apply -f _examples/manifests
