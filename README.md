# sync-zoomier

Modelo limpo para publicar no GitHub sem segredos.

## O que este pacote inclui

- `install.sh` para instalação básica em servidor Linux
- `.env.example` para configuração local
- `.gitignore` para evitar subir arquivos sensíveis
- `index.js` placeholder para você trocar pelo seu app real

## Antes de publicar

Remova qualquer conteúdo sensível do projeto:

- chaves e tokens
- URLs privadas
- credenciais de banco
- arquivos `.env`
- código ou assets que você não tenha direito de redistribuir

## Instalação

```bash
git clone <seu-repo>
cd sync-zoomier
cp .env.example .env
sudo bash install.sh
```

Depois:

```bash
sync
```

## Estrutura esperada

- `package.json`
- `index.js` ou ponto de entrada equivalente
- código da aplicação
- `.env.example`

Se o seu entrypoint não for `index.js`, ajuste `/usr/local/bin/sync` dentro de `install.sh`.

## Publicação no GitHub

Checklist rápido:

1. confirme que o código é seu ou que você tem permissão para redistribuir
2. rode uma varredura de segredos antes do push
3. mantenha só `.env.example`, nunca `.env`
4. revise histórico git para garantir que segredos antigos não ficaram nos commits
