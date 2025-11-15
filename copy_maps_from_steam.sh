#!/bin/bash

# Script para copiar mapas do CS 1.6 instalado no Windows via Steam

echo "🗺️  Script de Cópia de Mapas CS 1.6"
echo "===================================="
echo ""

# Possíveis localizações do CS 1.6 no Windows
STEAM_PATHS=(
    "/mnt/c/Program Files (x86)/Steam/steamapps/common/Half-Life/cstrike"
    "/mnt/d/Steam/steamapps/common/Half-Life/cstrike"
    "/mnt/e/Steam/steamapps/common/Half-Life/cstrike"
    "/mnt/c/Steam/steamapps/common/Half-Life/cstrike"
)

FOUND=false
STEAM_PATH=""

# Procurar CS 1.6 instalado
for path in "${STEAM_PATHS[@]}"; do
    if [ -d "$path/maps" ]; then
        STEAM_PATH="$path"
        FOUND=true
        echo "✅ CS 1.6 encontrado em: $path"
        break
    fi
done

if [ "$FOUND" = false ]; then
    echo "❌ CS 1.6 não encontrado!"
    echo ""
    echo "Locais verificados:"
    for path in "${STEAM_PATHS[@]}"; do
        echo "  - $path"
    done
    echo ""
    echo "Por favor, instale o CS 1.6 via Steam ou forneça o caminho manualmente:"
    echo "  $0 \"/mnt/c/seu/caminho/para/cstrike\""
    exit 1
fi

# Usar caminho fornecido como argumento, se disponível
if [ -n "$1" ]; then
    if [ -d "$1/maps" ]; then
        STEAM_PATH="$1"
        echo "✅ Usando caminho fornecido: $1"
    else
        echo "❌ Caminho inválido: $1"
        exit 1
    fi
fi

# Contar mapas disponíveis
MAP_COUNT=$(find "$STEAM_PATH/maps" -name "*.bsp" | wc -l)
echo "📊 Mapas disponíveis: $MAP_COUNT"

if [ $MAP_COUNT -eq 0 ]; then
    echo "❌ Nenhum mapa encontrado!"
    exit 1
fi

# Criar diretório de destino se não existir
DEST_DIR="$(dirname "$0")/maps"
mkdir -p "$DEST_DIR"

# Copiar mapas
echo ""
echo "📦 Copiando mapas..."
cp "$STEAM_PATH/maps"/*.bsp "$DEST_DIR/" 2>/dev/null

# Verificar cópia
COPIED_COUNT=$(find "$DEST_DIR" -name "*.bsp" | wc -l)
echo "✅ $COPIED_COUNT mapas copiados para: $DEST_DIR"

# Listar alguns mapas copiados
echo ""
echo "🗺️  Mapas principais copiados:"
for map in de_dust2 de_dust de_inferno de_nuke cs_italy cs_office; do
    if [ -f "$DEST_DIR/${map}.bsp" ]; then
        SIZE=$(du -h "$DEST_DIR/${map}.bsp" | cut -f1)
        echo "  ✓ ${map}.bsp ($SIZE)"
    fi
done

echo ""
echo "✅ Cópia concluída! Execute:"
echo "   docker-compose restart"
echo ""
