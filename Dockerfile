FROM debian:bullseye-slim

# Instalar dependências
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    lib32gcc-s1 \
    lib32stdc++6 \
    libc6:i386 \
    libstdc++6:i386 \
    curl \
    wget \
    ca-certificates \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Criar usuário para rodar o servidor
RUN useradd -m -d /home/steam -s /bin/bash steam

# Criar diretórios
RUN mkdir -p /home/steam/steamcmd /home/steam/hlds && \
    chown -R steam:steam /home/steam

# Mudar para usuário steam
USER steam
WORKDIR /home/steam/steamcmd

# Baixar e instalar SteamCMD
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Instalar/atualizar servidor CS 1.6 via SteamCMD
# Usar app_set_config para definir CS 1.6
RUN /home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /home/steam/hlds \
    +login anonymous \
    +app_set_config 90 mod cstrike \
    +app_update 90 validate \
    +app_update 70 validate \
    +app_update 10 validate \
    +quit || true

# Verificar e criar estrutura de diretórios
RUN mkdir -p /home/steam/hlds/cstrike/maps /home/steam/hlds/cstrike/models

WORKDIR /home/steam/hlds

# Copiar arquivos de configuração
COPY --chown=steam:steam ./configs/ /home/steam/hlds/cstrike/
COPY --chown=steam:steam ./start.sh /home/steam/

# Tornar script executável
USER root
RUN chmod +x /home/steam/start.sh
USER steam

# Expor portas
# 27015 - Porta do servidor de jogo (UDP)
# 27020 - SourceTV (UDP)
# 26900 - Porta de autenticação Steam (UDP)
EXPOSE 27015/udp 27020/udp 26900/udp

# Workdir para o servidor
WORKDIR /home/steam/hlds

# Comando para iniciar o servidor
CMD ["/home/steam/start.sh"]
