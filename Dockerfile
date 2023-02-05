FROM golang:1.20 as builder

RUN mkdir /app

WORKDIR /app

RUN git clone https://github.com/kaspanet/kaspad

WORKDIR /app/kaspad

RUN go install -ldflags '-linkmode external -w -extldflags "-static"' . ./cmd/...

FROM alpine:latest

COPY --from=builder /go/bin /

EXPOSE 16110

EXPOSE 16111

EXPOSE 8082

CMD sh