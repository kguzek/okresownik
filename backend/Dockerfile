FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

ARG VERSION=dev
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.Version=$VERSION" -o /app/server .

FROM alpine:3.24

RUN apk --no-cache add ca-certificates

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 8080

CMD ["./server"]
