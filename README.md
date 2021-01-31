# Protomicro - Less is more

## What's Protomicro

Protomicro is a tool/generator/cli/scaffolding(?) to help developers build
microserivces using Go, Grpc-Gateway, Protobuf & DI. Simple and fast.

To start using `Protomicro`, download the `Makefile` to a blank folder. Then run make or protomicro commands. (Suppose Go, make, docker and [protoc](https://gist.github.com/gomaglev/161d1a9e9d4c298556623a5e80221b97) has been [install](https://gist.github.com/gomaglev/161d1a9e9d4c298556623a5e80221b97)ed in your enviroment. You $GOPATH has been set).

```Shell
# sample - download default Makefile to microshop foler
cd ~ & mkdir microshop & cd microshop
curl -OL https://github.com/gomaglev/protomicro/Makefile
```

```Shell
# make protomicro cli
make cli

# code generation
./protomicro new microshop
./protomicro gen order/item/message
make protos
make wire

# start the service
make start
```

Only for fake data generation:

```Shell
make faker
```

## How to start

### 1. Download `Makefile` to a blank project folder

Change default values in the `Makefile` to meet your requirement.

```Makefile
APP_NAME    := microshop
CLI_NAME    := protomicro
GO_VERSION  := 1.15
```

### 2. `make cli`

`make cli` will build a binary cli tool under your project folder.

### 3. `./protomicro new ${YOUR_APP_NAME}`

`${CLI_NAME} new ${YOUR_APP_NAME}` will create the structure.

```Kaitai Struct
├── api                    : Protobuf defination
├── cmd                    : Main programs
│   └── ${YOUR_APP_NAME}
│           └── main.go
├── internal
│   └── ${YOUR_APP_NAME}
│       ├── service        : Business logic
│       ├── model          : Database model
│       │   ├── gorm       : Gorm model interface
│       │   │   ├─ entity  : Gorm entity
│       │   │   └─ model   : Gorm model implementation
│       │   ├── elastic    : Elasticsearch model
│       │   ├── mongo      : MongoDB model
│       │   └── external   : External third party datasource
│       ├── dto            : Data transfer object
│       ├── injector       : Dependency Injection
│       ├── errors         : Common errors
│       └── config         : Config file reader
├── configs                : Config files
├── deployments            : k8s, istio related files
├── docs                   : Documentations
├── pkg
│   ├── authentication     : Authentication (Login)
│   ├── authorization      : Authorization (RBAC, Local)
│   ├── grpclimit          : Rate limit
│   ├── icontext           : Context with transaction
│   ├── server             : gRPC server & gRPC gateway
│   └── util               : Utilities
├── scripts                : Shell scripts, runnable files
```

```Kaitai Struct
├── api
├── cmd
│   └── ${YOUR_APP_NAME}
│           └── main.go
├── configs
├── deployments
├── docs
├── internal
│   └── ${YOUR_APP_NAME}
│       ├── service
│       ├── model
│       │   ├── gorm
│       │   │   ├─ gorm.go
│       │   │   ├─ entity
│       │   │   │  └─ entity.go
│       │   │   └─ model
│       │   │      ├─ common.go
│       │   │      ├─ trans.go
│       │   │      └─ model.go
│       │   ├── elastic
│       │   ├── mongo
│       │   └── external
│       ├── dto
│       ├── injector
│       ├── errors
│       └── config
├── pkg
│   ├── authentication
│   ├── authorization
│   ├── grpclimit
│   ├── icontext
│   ├── server
│   └── util
├── scripts
├── tools.go
├── .travis.yml
├── Dockerfile
└── Makefile
```

### 4. Generate modules

`${CLI_NAME} gen ${MODULE}`
For example, `protomicro gen order/item/message`
protobuf, service, model, injector, dto and test files will be generated.

`make protos`
`make faker`

```Kaitai Struct
├── api: *.proto files for generation
│   └── order
│       ├── v1
│       │   └── order.proto
│       └── item
│           ├── v1
│           │   └── item.proto
│           └── message
│               └── v1
│                   └── message.proto
└── internal
    └── app
        ├── service: generated from *.proto in api folder
        │   └── order
        │       ├── v1
        │       │   ├── order_grpc.pb.go
        │       │   ├── order.pb.go
        │       │   ├── order.pb.gw.go
        │       │   ├── order.pb.validate.go
        │       │   ├── order.svc.go
        │       │   └── order_test.go
        │       └── item
        │           ├── v1
        │           │   ├── item_grpc.pb.go
        │           │   ├── item.pb.go
        │           │   ├── item.pb.gw.go
        │           │   ├── item.pb.validate.go
        │           │   ├── item.svc.go
        │           │   └── item_test.go
        │           └── message
        │               └── v1
        │                   ├── message_grpc.pb.go
        │                   ├── message.pb.go
        │                   ├── message.pb.gw.go
        │                   ├── message.pb.validate.go
        │                   ├── message.svc.go
        │                   └── message_test.go
        ├── model
        │   ├── order.go
        │   ├── order_item.go
        │   ├── order_item_message.go
        │   ├── gorm: default is gorm, if a model use other databases, implement them
        │   │   │── entity
        │   │   │   ├── order.go
        │   │   │   ├── order_item.go
        │   │   │   └── order_item_message.go
        │   │   └── model
        │   │       ├── order.go
        │   │       ├── order_item.go
        │   │       └── order_item_message.go
        │   │── mongo: blank
        │   │   │── entity
        │   │   │   ├── order.go
        │   │   │   ├── order_item.go
        │   │   │   └── order_item_message.go
        │   │   └── model
        │   │       ├── order.go
        │   │       ├── order_item.go
        │   │       └── order_item_message.go
        │   │── elastic: blank
        │   │   │── entity
        │   │   │   ├── order.go
        │   │   │   ├── order_item.go
        │   │   │   └── order_item_message.go
        │   │   └── model
        │   │       ├── order.go
        │   │       ├── order_item.go
        │   │       └── order_item_message.go
        │   └── external: blank
        │       │── entity
        │       │   ├── order.go
        │       │   ├── order_item.go
        │       │   └── order_item_message.go
        │       └── model
        │           ├── order.go
        │           ├── order_item.go
        │           └── order_item_message.go
        └── dto
            ├── order.go
            ├── order_item.go
            └── order_item_message.go
 
```

### 5. `make start`

```Shell
curl --request GET --header \
"Authorization: Basic $(echo -n user:password | base64)" \
http://localhost:8888/status
```

## Why Go

High performance, Reliability, Scalability, Consistency are key points
in building distributed systems. Compare to other languages,
Golang can really make your life easier. After switched our systems
from Java & Node.js to Golang, we can find very few reason to go back.

## Why GRPC

Milliseconds matter. gRPC uses HTTP/2 to support highly performant and scalable Handler's and makes use of binary data rather than just text which makes the communication more compact and more efficient.

## Why Protobuf

Protobufs have a lot of good things going for them. They're easy to write, easy to understand, compile to a vast number of languages, and support custom generators for things like validation and help documentation. Their size over the wire is very small and they are designed to be backwards- and forwards-compatible. This makes them extremely attractive as a means of transferring data in a client/server architecture, or in a microservice environment.
It may also have some `bad things`. I'm not going to give up using it because imo most of those `bad things` are `good` to build robust systems.

Protocol Buffers are not designed to handle large messages. As a general rule of thumb, if you are dealing in messages larger than a megabyte each, it may be time to consider an alternate strategy.

## TODO

- [x] Project layout - https://github.com/golang-standards/project-layout
- [x] Dependency Injection - Wire integration
- [x] gRPC Server / Gateway
- [x] GRPC Middlewares (Rate Limit, Authentication Basic, Error, native)
- [x] Gorm, Mongo, Elasticsearch integration
- [x] Protobuf & Faker integration
- [x] Dockerfiles - Postgres, Mongo, Elasticsearch, RabbitMQ, Redis, Protomicro
- [x] A sample microservice and test before creating generator (microshop)
- [ ] Module generator - generate API, Model, Controller, Register from proto files
- [ ] Sample CRUDS modules
- [ ] Kubenetes deployment
- [ ] Istio deployment
- [ ] OpenID OAuth2 Server
- [ ] Casbin RBAC & Istio Mixer Adapter

## Project layout

Project layout follows the standard below:
https://github.com/golang-standards/project-layout

## Don't use go lint

Use revive or other lint tools. (ID vs Id complains).
