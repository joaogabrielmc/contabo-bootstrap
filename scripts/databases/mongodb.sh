#!/bin/bash

set -e

echo ">>> Instalando dependências..."
sudo apt update
sudo apt install -y curl gnupg

echo ">>> Adicionando chave GPG..."
curl -fsSL https://pgp.mongodb.com/server-8.0.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg

echo ">>> Detectando versão do Ubuntu..."
UBUNTU_CODENAME=$(source /etc/os-release && echo "$VERSION_CODENAME")

echo "Ubuntu detectado: $UBUNTU_CODENAME"

echo ">>> Adicionando repositório..."
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $UBUNTU_CODENAME/mongodb-org/8.0 multiverse" \
| sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

echo ">>> Atualizando repositórios..."
sudo apt update

echo ">>> Instalando MongoDB..."
sudo apt install -y mongodb-org

echo ">>> Habilitando serviço..."
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod

echo ">>> Status:"
sudo systemctl --no-pager status mongod

echo ""
echo "=========================================="
echo "MongoDB instalado com sucesso!"
echo "=========================================="
echo ""
echo "Versão:"
mongod --version | head -n 1
echo ""
echo "URL local:"
echo "mongodb://127.0.0.1:27017"
echo ""
echo "Exemplo:"
echo "mongodb://127.0.0.1:27017/financial_app"