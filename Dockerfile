FROM golang:1.20 as build
WORKDIR /build
COPY go.mod go.sum ./
RUN \
  --mount=type=cache,target=/go \
  go mod download
COPY . .
ENV CGO_ENABLED=0
RUN \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/go \
  go build

FROM scratch
WORKDIR /app
COPY --from=build /build/example-server .
CMD ["./example-server"]
EXPOSE 8000
