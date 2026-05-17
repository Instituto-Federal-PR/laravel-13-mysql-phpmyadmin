#!/bin/sh

# Verifica se o diretório vendor existe e instala as dependências se necessário
if [ ! -d "vendor" ]; then
    echo "Diretório vendor não encontrado. Executando composer install..."
    composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-reqs
fi

# Garante que o diretório storage e bootstrap/cache tenham as permissões corretas
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

echo "Configuração do PHP para o servidor embutido:"
php -i | grep "Loaded Configuration File"

echo "Iniciando o servidor PHP embutido na porta 15000, servindo a pasta public..."
# O 'exec' garante que o processo do servidor substitua o processo do shell, mantendo o contêiner ativo
exec php -S 0.0.0.0:15000 -t public
