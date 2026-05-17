#!/bin/sh

# Sair imediatamente se um comando falhar
set -e

echo "--- Iniciando entrypoint.sh ---"

# Verifica se o diretório vendor existe e instala as dependências se necessário
if [ ! -d "vendor" ]; then
    echo "Diretório vendor não encontrado. Executando composer install..."
    composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-reqs
    echo "Composer install concluído."
else
    echo "Diretório vendor já existe. Pulando composer install."
fi

# Verifica se o autoload.php foi criado
if [ ! -f "vendor/autoload.php" ]; then
    echo "ERRO CRÍTICO: O arquivo vendor/autoload.php NÃO foi criado após o composer install."
    echo "Isso indica uma falha na instalação das dependências. Verifique os logs acima."
    exit 1
else
    echo "vendor/autoload.php encontrado. Dependências carregadas com sucesso."
fi

# Garante que o diretório storage e bootstrap/cache tenham as permissões corretas
echo "Configurando permissões para storage e bootstrap/cache..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
echo "Permissões configuradas."

echo "Configuração do PHP para o servidor embutido:"
php -i | grep "Loaded Configuration File"

echo "Iniciando o servidor PHP embutido na porta 15000, servindo a pasta public..."
# O 'exec' garante que o processo do servidor substitua o processo do shell, mantendo o contêiner ativo
exec php -S 0.0.0.0:15000 -t public
