# VPS Ubunto Bootstrap

Scripts para provisionar servidores Ubuntu do zero.

## Sistemas Suportados

- Ubuntu 20.04
- Ubuntu 22.04
- Ubuntu 24.04 LTS (incluindo point releases, ex.: 24.04.4)

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

## Hestia Control Panel (HestiaCP)

Painel de controle de hospedagem (sites, DNS, e-mail, bancos, SSL).  
**Instale apenas em um Ubuntu limpo** — não misture com `full-setup.sh` nem com os scripts de Nginx/MySQL/PostgreSQL/MongoDB deste repositório, pois o Hestia traz o próprio stack e conflita com serviços já instalados.

### Requisitos

| | Mínimo | Recomendado |
| --- | --- | --- |
| CPU | 1 núcleo 64-bit | 4 núcleos |
| RAM | 1 GB (sem ClamAV/SpamAssassin) | 4 GB |
| Disco | 10 GB | 40 GB SSD |
| SO | Ubuntu 22.04 ou 24.04 LTS (ex.: 24.04.4) | Ubuntu LTS mais recente |

Também necessário:

- Servidor **recém-instalado** (fresh OS)
- Acesso **root** via SSH
- Hostname FQDN apontando para o IP do servidor (ex.: `panel.seudominio.com`) — recomendado
- Portas liberadas no firewall do provedor: **8083** (painel), **80/443** (web), e as de e-mail/FTP se for usar

Arquiteturas suportadas: AMD64 / ARM64.

### Instalar e ativar

```bash
cd contabo-bootstrap/scripts
sudo bash panel/hestiacp.sh
```

O script baixa o instalador oficial e inicia a instalação interativa (e-mail do admin, hostname, senha, etc.).

Em imagens Contabo, o grupo `admin` costuma já existir e o instalador oficial bloqueia. O wrapper detecta isso e passa `--force` automaticamente. Se ainda falhar:

```bash
sudo bash panel/hestiacp.sh --force
```

Instalação não interativa (exemplo):

```bash
sudo bash panel/hestiacp.sh \
  --interactive no \
  --hostname panel.seudominio.com \
  --email admin@seudominio.com \
  --password 'SUA_SENHA_FORTE' \
  --apache no \
  --clamav no \
  --spamassassin no
```

Opções oficiais: `bash hst-install.sh -h` (o wrapper repassa todos os flags).

### Acessar o painel

Após a instalação:

1. Abra `https://SEU_IP:8083` ou `https://SEU_HOSTNAME:8083`
2. Entre com o usuário/senha definidos no instalador (padrão do admin costuma ser `admin`)
3. Confirme que o serviço está ativo:

```bash
systemctl status hestia
```

Trocar senha do admin depois:

```bash
v-change-user-password admin 'nova_senha'
```
