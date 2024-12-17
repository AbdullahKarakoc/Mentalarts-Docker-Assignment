# Base image olarak Go kullanılıyor
FROM golang:1.23.4

# Çalışma dizinini ayarla
WORKDIR /app

# Proje dosyalarını kopyala
COPY src/ .

# Bağımlılıkları indir
RUN go mod init example.com/translate && \
    go mod tidy

# Uygulamayı derle
RUN go build -o main .

# Servisi çalıştır
CMD ["./main"]

