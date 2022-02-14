account = $(shell aws sts get-caller-identity --query "Account" --output text)
image = $(account).dkr.ecr.us-east-1.amazonaws.com/apiapp:$(version)
stage = dev
include stages/$(stage)

demo:
	@echo "current namespace variable value is - $(namespace)"

login:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(account).dkr.ecr.us-east-1.amazonaws.com

build:
	@docker build -t $(image) .

push: login
	@# docker login is not here
	@docker push $(image)

deploy:
	@echo "deploying to $(namespace) namespace"
	@cat kubernetes/namespace.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -
	@cat kubernetes/secret.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -
	@cat kubernetes/deployment.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|ACCOUNT|$(account)|g" | kubectl apply -f -

test:
	@curl ....
	@python3 ui-tests/app.py