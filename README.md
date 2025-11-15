# 🎮 Servidor Counter-Strike 1.6 Containerizado

Este projeto configura um servidor de Counter-Strike 1.6 totalmente funcional usando Docker, facilitando a implantação e gerenciamento.

## 📋 Pré-requisitos

- Docker instalado (versão 20.10 ou superior)
- Docker Compose instalado (versão 1.29 ou superior)
- Portas 27015, 27020 e 26900 UDP disponíveis no seu servidor

## 🚀 Como Usar

### 1. Clonar ou criar a estrutura do projeto

```bash
cd cs_server
```

### 2. Construir a imagem Docker

```bash
docker-compose build
```

**Nota:** O primeiro build pode demorar de 10-20 minutos pois precisa baixar o SteamCMD e os arquivos do servidor CS 1.6 (~1GB).

### 3. Iniciar o servidor

```bash
docker-compose up -d
```

### 4. Verificar os logs

```bash
docker-compose logs -f cs16-server
```

### 5. Parar o servidor

```bash
docker-compose down
```

## ⚙️ Configuração

### Variáveis de Ambiente

Edite o arquivo `docker-compose.yml` para personalizar seu servidor:

```yaml
environment:
  - SERVER_NAME=CS 1.6 Server          # Nome do servidor
  - MAP=de_dust2                       # Mapa inicial
  - MAXPLAYERS=32                      # Número máximo de jogadores
  - START_MONEY=800                    # Dinheiro inicial
  - BUY_TIME=0.25                      # Tempo de compra (minutos)
  - FRIENDLY_FIRE=0                    # Fire amigo (0=off, 1=on)
  - RCON_PASSWORD=changeme123          # Senha RCON (MUDE ISSO!)
```

### Arquivos de Configuração

Os arquivos de configuração estão em `configs/`:

- **server.cfg** - Configurações principais do servidor
- **mapcycle.txt** - Rotação de mapas
- **motd.txt** - Mensagem do dia (exibida ao conectar)
- **banned.cfg** - Lista de IPs banidos
- **listip.cfg** - Lista de IPs permitidos/bloqueados

## 🗺️ Adicionar Mapas Customizados

Para adicionar mapas personalizados:

1. Coloque os arquivos `.bsp` na pasta `maps/`
2. Adicione o nome do mapa em `configs/mapcycle.txt`
3. Reinicie o servidor

```bash
docker-compose restart
```

## 🔧 Comandos RCON

Conecte ao servidor via RCON para administrar:

```bash
# Entrar no container
docker exec -it cs16-server bash

# Ou use um cliente RCON externo
# Host: seu_ip
# Porta: 27015
# Senha: definida em RCON_PASSWORD
```

Comandos úteis:
- `changelevel de_dust2` - Mudar mapa
- `kick <nome>` - Expulsar jogador
- `ban <nome>` - Banir jogador
- `status` - Ver jogadores conectados
- `users` - Ver usuários autenticados

## 📂 Estrutura de Diretórios

```
cs_server/
├── Dockerfile              # Imagem do servidor CS 1.6
├── docker-compose.yml      # Orquestração do container
├── start.sh                # Script de inicialização
├── configs/                # Arquivos de configuração
│   ├── server.cfg         # Config principal
│   ├── mapcycle.txt       # Rotação de mapas
│   ├── motd.txt           # Mensagem do dia
│   ├── banned.cfg         # IPs banidos
│   └── listip.cfg         # Lista de IPs
├── maps/                   # Mapas customizados (opcional)
└── logs/                   # Logs do servidor
```

## 🌐 Conectar ao Servidor

### No CS 1.6 (Windows conectando ao WSL)

1. **Descubra o IP do WSL:**
   ```bash
   # No WSL/Linux
   hostname -I | awk '{print $1}'
   ```
   Exemplo de IP: `172.27.88.27`

2. **Conecte no jogo:**
   - Abra o console (~)
   - Digite: `connect 172.27.88.27:27015` (use seu IP do WSL)
   - Ou tente: `connect localhost:27015`
   - Ou adicione aos favoritos

### Troubleshooting de Conexão

**Erro: "Retrying..."**
- ✅ Use o IP do WSL (não `0.0.0.0`)
- ✅ Verifique o firewall do Windows
- ✅ Confirme que o servidor está rodando: `docker-compose logs cs16-server`

**Verificar conectividade:**
```bash
# No WSL - verificar se porta está aberta
sudo netstat -tulpn | grep 27015

# No Windows PowerShell - testar conexão
Test-NetConnection -ComputerName 172.27.88.27 -Port 27015
```

**Configurar Port Forwarding (Opcional):**
```powershell
# No Windows PowerShell como Administrador
netsh interface portproxy add v4tov4 listenport=27015 listenaddress=0.0.0.0 connectport=27015 connectaddress=172.27.88.27
```

## 🔐 Segurança

**IMPORTANTE:** Mude a senha RCON antes de colocar em produção!

```yaml
- RCON_PASSWORD=sua_senha_forte_aqui
```

## 🐛 Troubleshooting

### Servidor não inicia

Verifique os logs:
```bash
docker-compose logs cs16-server
```

### Porta já em uso

Mude a porta no `docker-compose.yml`:
```yaml
ports:
  - "27016:27015/udp"  # Use 27016 no host
```

### Erro de permissão

Certifique-se que o script tem permissão de execução:
```bash
chmod +x start.sh
```

## 📊 Monitoramento

Para monitorar recursos do container:

```bash
docker stats cs16-server
```

## 🔄 Atualização

Para atualizar o servidor:

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 📝 Logs

Os logs são salvos automaticamente em `logs/`:

```bash
tail -f logs/L*.log
```

## 🤝 Contribuindo

Sinta-se à vontade para abrir issues ou enviar pull requests para melhorias.

## 📄 Licença

Este projeto é fornecido "como está" para uso educacional e de entretenimento.

## 🎯 Recursos Adicionais

- [Documentação oficial CS 1.6](https://developer.valvesoftware.com/wiki/Counter-Strike)
- [SteamCMD Wiki](https://developer.valvesoftware.com/wiki/SteamCMD)
- [HLDS Linux](https://developer.valvesoftware.com/wiki/Half-Life_Dedicated_Server)

---

**Divirta-se jogando Counter-Strike 1.6! 🎮**
