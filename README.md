# VPS Ubunto Bootstrap

Scripts para provisionar servidores Ubuntu do zero.

## Sistemas Suportados

- Ubuntu 20.04
- Ubuntu 22.04

## O que instala

- PostgreSQL
- MySQL
- MongoDB
- Nginx
- Node.js (LTS)
- Python 3
- PM2

## ⚠️ Avisos Importantes

- **Execute sempre como root** - Todos os scripts requerem permissões de administrador
- **Revise portas e usuários antes de usar em produção** - Configure as credenciais e portas conforme suas necessidades de segurança

## Uso Rápido

```bash
git clone https://github.com/joaogabrielmc/setup-vps.git
cd contabo-bootstrap/scripts
sudo bash full-setup.sh
```

## Instalação Script por Script

Se preferir instalar apenas componentes específicos, você pode executar cada script individualmente:

### Atualizar Sistema

```bash
sudo bash common/update-system.sh
```

### Runtimes

```bash
# Node.js (LTS)
sudo bash runtimes/node.sh

# Python 3
sudo bash runtimes/python.sh

# PM2 (Gerenciador de Processos Node.js)
sudo bash runtimes/pm2.sh
```

### Bancos de Dados

```bash
# PostgreSQL
sudo bash databases/postgresql.sh

# MySQL
sudo bash databases/mysql.sh

# MongoDB
sudo bash databases/mongodb.sh
```

### Web Server

```bash
# Nginx
sudo bash web/nginx.sh
```
