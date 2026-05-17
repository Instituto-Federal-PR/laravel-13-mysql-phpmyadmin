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

# Copia o entrypoint.sh e garante que ele seja executável DENTRO da imagem
# Isso é feito antes de copiar o restante do código para evitar problemas de permissão com volumes
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copia o restante do código da aplicação
COPY . .

# Garante que o diretório vendor tenha as permissões corretas (será criado no runtime)
RUN mkdir -p vendor && chmod -R 775 vendor

# Configura o FrankenPHP para rodar em HTTP na porta 15000 localmente (sem HTTPS forçado no desenvolvimento)
ENV SERVER_NAME=:15000
