ALL_DIRS=$(shell find . \( -path ./Godeps -o -path ./.git \) -prune -o -type d -print)
EXECUTABLE=metricproxy
DOCKER_DIR=Docker
DOCKER_FILE=$(DOCKER_DIR)/Dockerfile
GO_FILES=$(foreach dir, $(ALL_DIRS), $(wildcard $(dir)/*.go))
ENVETCD_VERSION=v0.3.2

all: build

lint:
	golint ./...
	go vet ./...

test: $(GO_FILES)
	godep go test -v -race -cpu 2 -parallel 8 ./...

build: cmd/$(EXECUTABLE)

cmd/$(EXECUTABLE): $(GO_FILES)
	godep go build -v -o cmd/$(EXECUTABLE)

clean:
	@rm -f \
      cmd/$(EXECUTABLE) \
      $(DOCKER_DIR)/$(EXECUTABLE) \
      ./.image-stamp

save:
	@rm -rf ./Godeps
	GOOS=linux GOARCH=amd64 godep save ./...

image: .image-stamp

.image-stamp: $(DOCKER_DIR)/$(EXECUTABLE) $(DOCKER_FILE) $(DOCKER_DIR)/envetcd
	docker build -t zvelo/$(EXECUTABLE) $(DOCKER_DIR)
	@touch .image-stamp

## download here because Dockerfile ADD uses 600 permissions and there is no chmod command in the container
$(DOCKER_DIR)/envetcd:
	@curl -L https://github.com/zvelo/envetcd/releases/download/$(ENVETCD_VERSION)/envetcd-linux-amd64 -o $(DOCKER_DIR)/envetcd
	@chmod +x $(DOCKER_DIR)/envetcd

$(DOCKER_DIR)/$(EXECUTABLE): $(GO_FILES)
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 godep go build -a -v -tags netgo -installsuffix netgo -o $(DOCKER_DIR)/$(EXECUTABLE)

.PHONY: all lint test build clean save image
