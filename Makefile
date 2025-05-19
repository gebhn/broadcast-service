DIR     := $(CURDIR)/bin
BIN     := broadcast-service
PKG     := ./...
SRC     := $(shell find . -type f -name '*.go' -print) go.mod go.sum
VERSION ?= latest

LDFLAGS     := -w -s
CGO_ENABLED := 0

COUNT       ?= 1

GOBIN     := $(shell go env GOPATH)/bin
GOIMPORTS := $(GOBIN)/goimports

.PHONY: all
all: build

.PHONY: build
build: $(DIR)/$(BIN)

$(DIR)/$(BIN): $(SRC)
	CGO_ENABLED=$(CGO_ENABLED) go build $(GOFLAGS) -trimpath -ldflags '$(LDFLAGS)' -o $(DIR)/$(BIN) ./cmd/$(BIN)

.PHONY: build-image
build-image:
	docker build -t github.com/gebhn/$(BIN):$(VERSION) -f build/package/$(BIN)/Dockerfile .

.PHONY: test
test:
	go test -race -v -count=$(COUNT) ./...

$(GOIMPORTS):
	(cd /; go install golang.org/x/tools/cmd/goimports@latest)

.PHONY: format
format: $(GOIMPORTS)
	GO111MODULE=on go list -f '{{.Dir}}' ./... | xargs $(GOIMPORTS) -w -local github.com/gebhn/broadcast-service

.PHONY: clean
clean:
	rm -rf $(DIR)
