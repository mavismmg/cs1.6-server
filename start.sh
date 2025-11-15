#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Counter-Strike 1.6 Server${NC}"
echo -e "${GREEN}================================${NC}"

# Variáveis de ambiente com valores padrão
SERVER_NAME="${SERVER_NAME:-CS 1.6 Server}"
MAP="${MAP:-de_dust2}"
MAXPLAYERS="${MAXPLAYERS:-32}"
START_MONEY="${START_MONEY:-800}"
BUY_TIME="${BUY_TIME:-0.25}"
FRIENDLY_FIRE="${FRIENDLY_FIRE:-0}"
RCON_PASSWORD="${RCON_PASSWORD:-changeme123}"

# Substituir variáveis no server.cfg
if [ -f "/home/steam/hlds/cstrike/configs/server.cfg" ]; then
    echo -e "${YELLOW}Configurando server.cfg...${NC}"
    envsubst < /home/steam/hlds/cstrike/configs/server.cfg > /home/steam/hlds/cstrike/server.cfg
    
    # Copiar outros arquivos de configuração
    cp /home/steam/hlds/cstrike/configs/mapcycle.txt /home/steam/hlds/cstrike/mapcycle.txt 2>/dev/null || true
    cp /home/steam/hlds/cstrike/configs/motd.txt /home/steam/hlds/cstrike/motd.txt 2>/dev/null || true
    cp /home/steam/hlds/cstrike/configs/banned.cfg /home/steam/hlds/cstrike/banned.cfg 2>/dev/null || true
    cp /home/steam/hlds/cstrike/configs/listip.cfg /home/steam/hlds/cstrike/listip.cfg 2>/dev/null || true
fi

echo -e "${GREEN}Iniciando servidor CS 1.6...${NC}"
echo -e "${YELLOW}Nome do Servidor:${NC} $SERVER_NAME"
echo -e "${YELLOW}Mapa Inicial:${NC} $MAP"
echo -e "${YELLOW}Máximo de Jogadores:${NC} $MAXPLAYERS"
echo -e "${YELLOW}RCON Password:${NC} $RCON_PASSWORD"
echo -e "${GREEN}================================${NC}"

# Verificar se os mapas existem
echo -e "${YELLOW}Verificando mapas disponíveis...${NC}"
if [ -d "/home/steam/hlds/cstrike/maps" ]; then
    MAP_COUNT=$(find /home/steam/hlds/cstrike/maps -name "*.bsp" | wc -l)
    echo -e "${YELLOW}Mapas encontrados:${NC} $MAP_COUNT"
    if [ $MAP_COUNT -eq 0 ]; then
        echo -e "${RED}AVISO: Nenhum mapa .bsp encontrado!${NC}"
        echo -e "${YELLOW}Listando conteúdo do diretório valve/maps:${NC}"
        ls -la /home/steam/hlds/valve/maps/*.bsp 2>/dev/null | head -5 || echo "Nenhum mapa encontrado em valve/maps"
        # Tentar usar mapas do valve se existirem
        if [ -f "/home/steam/hlds/valve/maps/boot_camp.bsp" ]; then
            MAP="boot_camp"
            echo -e "${YELLOW}Usando mapa do Half-Life:${NC} $MAP"
        fi
    fi
fi

# Iniciar o servidor
cd /home/steam/hlds

./hlds_run \
    -game cstrike \
    +ip 0.0.0.0 \
    +port 27015 \
    +map "$MAP" \
    +maxplayers "$MAXPLAYERS" \
    +sv_lan 0 \
    +exec server.cfg \
    -nomaster \
    -secure \
    -pidfile hlds.pid \
    -timeout 3
