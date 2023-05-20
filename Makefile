help:
	@echo "See Makefile"

setup:
	k3d cluster create demo \
		--servers 3 \
		-p 80:80@loadbalancer \
		-p 443:443@loadbalancer \
		--k3s-arg '--disable=traefik@server:*'
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml

install-hello-world:
	helm upgrade --install \
		hello \
		hello-world --repo https://helm.sikalabs.io \
		--values hello-world.values.yaml \
		--wait
