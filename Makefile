CR = podman
ORG = docker.io/zuul

image:
	$(CR) build -f build/Dockerfile -t $(ORG)/zuul-operator .

install:
	kubectl apply -f deploy/crds/zuul-ci_v1alpha1_zuul_crd.yaml -f deploy/rbac.yaml -f deploy/operator.yaml

deploy-cr:
	kubectl apply -f deploy/crds/zuul-ci_v1alpha1_zuul_cr.yaml
