# Imagem base com PHP 8.4 e FrankenPHP
FROM dunglas/frankenphp:1-php8.4

WORKDIR /app

# Copia o Composer de uma imagem oficial para garantir que esteja disponível
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instala as extensões PHP necessárias para o Laravel e o MySQL
# Usando install-php-extensions, que gerencia as dependências do sistema automaticamente
RUN install-php-extensions \
    pdo_mysql \
    bcmath \
    gd \
    intl \
    zip \
    opcache

# Copia o entrypoint.sh para o WORKDIR (/app) e garante que ele seja executável
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Copia o restante do código da aplicação
COPY . .

# Garante que o diretório vendor tenha as permissões corretas (será criado no runtime)
RUN mkdir -p vendor && chmod -R 775 vendor

# Configura o FrankenPHP para rodar em HTTP na porta 15000 localmente (sem HTTPS forçado no desenvolvimento)
ENV SERVER_NAME=:15000

# Define o entrypoint do contêiner para o nosso script
ENTRYPOINT ["/app/entrypoint.sh"]
