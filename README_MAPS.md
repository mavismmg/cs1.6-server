# 🗺️ Adicionar Mapas ao Servidor CS 1.6

## Problema: Mapas Padrão Não Disponíveis

O CS 1.6 legado não está mais disponível via SteamCMD oficial. Você precisa adicionar os mapas manualmente.

## Solução 1: Baixar Mapas Padrão do CS 1.6

### Windows (sua máquina local)

1. Baixe os mapas do CS 1.6 de uma destas fontes:
   - Steam (se você possui o jogo): `C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\maps\`
   - GameBanana: https://gamebanana.com/games/4254
   - CS-Mapping: http://cs-mapping.com.ua/

2. Copie os arquivos `.bsp` para a pasta `maps/` do projeto:
   ```powershell
   # No Windows PowerShell
   Copy-Item "C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike\maps\*.bsp" \\wsl$\Ubuntu\home\mrekk\cs_server\maps\
   ```

3. Ou via WSL:
   ```bash
   # No WSL/Linux
   cp /mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/Half-Life/cstrike/maps/*.bsp ~/cs_server/maps/
   ```

## Solução 2: Download Direto (Recomendado)

Execute este script no WSL para baixar mapas essenciais:

```bash
cd ~/cs_server/maps

# Baixar pack de mapas do CS 1.6
wget https://www.dropbox.com/s/example/cs16_maps.zip -O maps.zip
unzip maps.zip
rm maps.zip

# Ou baixe mapas individuais
wget https://gamebanana.com/mmdl/487878 -O de_dust2.bsp
wget https://gamebanana.com/mmdl/487879 -O de_dust.bsp
wget https://gamebanana.com/mmdl/487880 -O de_inferno.bsp
wget https://gamebanana.com/mmdl/487881 -O de_nuke.bsp
```

## Solução 3: Usar Steam Content

Se você tem CS 1.6 instalado no Windows:

```bash
# Criar script para copiar mapas
cat > ~/cs_server/copy_maps.sh << 'EOF'
#!/bin/bash
STEAM_PATH="/mnt/c/Program Files (x86)/Steam/steamapps/common/Half-Life/cstrike"
if [ -d "$STEAM_PATH/maps" ]; then
    echo "Copiando mapas do Steam..."
    cp "$STEAM_PATH/maps"/*.bsp ~/cs_server/maps/
    echo "Mapas copiados com sucesso!"
    ls -lh ~/cs_server/maps/*.bsp
else
    echo "Diretório do Steam não encontrado!"
    echo "Verifique se o CS 1.6 está instalado em: $STEAM_PATH"
fi
EOF

chmod +x ~/cs_server/copy_maps.sh
~/cs_server/copy_maps.sh
```

## Mapas Essenciais para CS 1.6

Mapas **DE** (Defuse):
- de_dust2 (mais popular)
- de_dust
- de_inferno
- de_nuke
- de_train
- de_aztec
- de_cbble (Cobblestone)

Mapas **CS** (Hostage):
- cs_italy
- cs_office
- cs_assault
- cs_militia

## Verificar Mapas Instalados

```bash
# Listar mapas no container
docker exec cs16-server ls -lh /home/steam/hlds/cstrike/maps/*.bsp

# Ou no host
ls -lh ~/cs_server/maps/*.bsp
```

## Reiniciar Servidor

Depois de adicionar mapas:

```bash
docker-compose restart
```

## Alternativa: Usar Imagem Pré-configurada

Se preferir uma solução pronta, você pode usar imagens Docker com CS 1.6 já configurado:

```yaml
# Substituir no docker-compose.yml
services:
  cs16-server:
    image: goldsrc/counter-strike:latest
    # ... resto da configuração
```

## Recursos Adicionais

- **GameBanana CS Maps**: https://gamebanana.com/games/4254
- **17buddies Map Database**: https://www.17buddies.rocks/
- **CS-Mapping**: http://cs-mapping.com.ua/
