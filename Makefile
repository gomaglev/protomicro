SHELL := /bin/bash

GO_VERSION := 1.15
APP_NAME   := microshop
CLI_NAME   := protomicro
PORT       := 8888
DOCKER_HUB := gomaglev

# build protomicro cli
cli:
	# Linux
	# sed -i 's/APP_NAME/$(APP_NAME)/g' go.mod
	# Mac
	if [ ! -f "go.mod" ]; then\
		echo 'module $(APP_NAME)' >> go.mod;\
		echo 'go $(GO_VERSION)' >> go.mod;\
	fi

	go build -o $(CLI_NAME) github.com/gin-admin/gin-admin-cli
	chmod +x protomicro
	mv $(CLI_NAME) $(GOPATH)/bin

# make a sample
sample:
	protomicro new microshop
	protomicro gen category
	protomicro gen product
	protomicro gen order/item/message
	protomicro gen payment

	make protos
	make wire

# gRPC Protobuf variables

PROTOC_FLAGS ?= \
	-I ${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	-I ${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway \
	-I ${GOPATH}/src/github.com/envoyproxy/protoc-gen-validate \
	--proto_path=${PWD} \
	--grpc-gateway_out=logtostderr=true:$(PWD)/internal \
	--go_out=$(PWD)/internal \
	--go-grpc_out=require_unimplemented_servers=false:$(PWD)/internal \
	--validate_out=lang=go:$(PWD)/internal \
	--openapiv2_out ${PWD} --openapiv2_opt logtostderr=true \

PROTO_FILES ?= $(shell find $(PWD) -type f -path '*.proto' | grep -v "vendor")

protos: # generate protobuf files
	${GOPATH}/bin/protoc $(PROTOC_FLAGS) ${PROTO_FILES}

PROTO_PB_FILES ?= $(shell find $(PWD) -type f -path '*.pb.go' | grep -v "vendor")

faker: # add faker tag to proto files
	${GOPATH}/bin/protoc-go-inject-tag -input="${PROTO_PB_FILES}" -verbose=false


# Docker
build: ## Build the container
	docker build -t $(DOCKER_HUB)/$(APP_NAME) .

build-nc: ## Bulid the container without cache
	docker build --no-cache -t $(DOCKER_HUB)/$(APP_NAME) .

stop: ## Stop the container and remove
	docker stop $(APP_NAME) || true && docker rm $(APP_NAME) || true

run: ## Run the container
	docker run \
	-d \
	--env-file $(ENV) \
	-p $(PORT):$(PORT) \
	--name="$(APP_NAME)" \
	$(DOCKER_HUB)/$(APP_NAME)

start: build stop run ## Build the container and run it
