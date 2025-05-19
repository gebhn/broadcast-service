FROM golang:latest AS builder

ENV GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64

RUN apt-get update

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN make clean

RUN make all

FROM scratch

COPY --from=builder /app/bin/broadcast-service /broadcast-service

EXPOSE 8080

CMD ["/broadcast-service"]
