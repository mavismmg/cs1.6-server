# 📤 Como Publicar no GitHub

## Opção 1: Via GitHub CLI (gh)

### Instalar GitHub CLI (se não tiver)
```bash
# No Ubuntu/WSL
sudo apt update
sudo apt install gh

# Autenticar
gh auth login
```

### Criar e publicar repositório
```bash
cd ~/cs_server

# Criar repositório público
gh repo create cs16-docker-server --public --source=. --push

# Ou criar repositório privado
gh repo create cs16-docker-server --private --source=. --push
```

## Opção 2: Via Web + Git

### 1. Criar repositório no GitHub
1. Acesse https://github.com/new
2. Nome do repositório: `cs16-docker-server`
3. Descrição: `Servidor Counter-Strike 1.6 containerizado com Docker`
4. Escolha público ou privado
5. **NÃO** inicialize com README (já temos)
6. Clique em "Create repository"

### 2. Adicionar remote e fazer push
```bash
cd ~/cs_server

# Substituir SEU_USUARIO pelo seu username do GitHub
git remote add origin https://github.com/SEU_USUARIO/cs16-docker-server.git

# Renomear branch para main (opcional)
git branch -M main

# Fazer push
git push -u origin main
```

## Opção 3: Via SSH (Recomendado)

### 1. Configurar chave SSH (se não tiver)
```bash
# Gerar chave SSH
ssh-keygen -t ed25519 -C "seu_email@example.com"

# Copiar chave pública
cat ~/.ssh/id_ed25519.pub
```

2. Adicione a chave em: https://github.com/settings/keys

### 2. Criar e fazer push
```bash
cd ~/cs_server

# Criar repositório via gh CLI
gh repo create cs16-docker-server --public --source=. --remote=origin

# Fazer push via SSH
git push -u origin master
```

## Verificar Repositório

Depois do push, acesse:
```
https://github.com/SEU_USUARIO/cs16-docker-server
```

## Adicionar Topics (Tags)

No seu repositório GitHub, adicione estas tags:
- `counter-strike`
- `cs16`
- `docker`
- `game-server`
- `hlds`
- `steamcmd`
- `linux`
- `wsl`

## Licença

Adicione uma licença ao seu projeto:
```bash
# Adicionar MIT License
gh repo edit --add-license MIT
```

## Futuras Atualizações

Para fazer push de mudanças:
```bash
git add .
git commit -m "Sua mensagem de commit"
git push
```

---

**Status atual:**
✅ Repositório Git local criado
✅ Commit inicial feito
⏳ Aguardando push para GitHub
