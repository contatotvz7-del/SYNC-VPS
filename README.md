# sync-zoomier

Template público limpo para instalação em VPS sem segredos.

## Arquivos incluídos

- `install.sh`
- `.env.example`
- `.gitignore`
- `README.md`
- `package.json`
- `index.js` placeholder

## Instalação

```bash
git clone <seu-repo>
cd sync-zoomier
cp .env.example .env
nano .env
sudo bash install.sh
sync
```

## Observações

- Não suba `.env` para o GitHub
- Use apenas `.env.example`
- Se o seu app real não usar `index.js`, ajuste `/usr/local/bin/sync`
- O `index.js` deste pacote é só placeholder
