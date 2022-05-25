FROM golang:1.17-alpine
WORKDIR /app
COPY . .
ENV PORT=8080
EXPOSE 8080
RUN go build -o server cmd/*
CMD echo "build is successful, the application accepts connections at port $PORT" && ./server