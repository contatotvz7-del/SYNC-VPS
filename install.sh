#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="sync-zoomier"
DEST="${DEST:-/opt/sync-zoomier}"
NODE_MAJOR="${NODE_MAJOR:-20}"
RUN_USER="${RUN_USER:-synczoomier}"
RUN_GROUP="${RUN_GROUP:-synczoomier}"

need_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "Use como root: sudo bash install.sh"
    exit 1
  fi
}

apt_base() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y curl ca-certificates gnupg build-essential python3 make g++ tar
}

install_node() {
  if command -v node >/dev/null 2>&1; then
    local current_major
    current_major="$(node -v | sed 's/^v//' | cut -d. -f1)"
    if [[ "${current_major}" == "${NODE_MAJOR}" ]]; then
      echo "Node.js ${NODE_MAJOR} já está instalado."
      return 0
    fi
  fi

  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -
  apt-get install -y nodejs
}

create_user_if_needed() {
  if ! getent group "${RUN_GROUP}" >/dev/null 2>&1; then
    groupadd --system "${RUN_GROUP}" || true
  fi

  if ! id "${RUN_USER}" >/dev/null 2>&1; then
    useradd --system \
      --create-home \
      --home-dir "/home/${RUN_USER}" \
      --shell /usr/sbin/nologin \
      -g "${RUN_GROUP}" \
      "${RUN_USER}" || true
  fi
}

install_app() {
  mkdir -p "${DEST}"

  if [[ -d "${DEST}" ]]; then
    find "${DEST}" -mindepth 1 -maxdepth 1 ! -name ".env" -exec rm -rf {} +
  fi

  cp -a . "${DEST}/repo-tmp"
  shopt -s dotglob
  mv "${DEST}/repo-tmp"/* "${DEST}/"
  shopt -u dotglob
  rm -rf "${DEST}/repo-tmp"

  chown -R "${RUN_USER}:${RUN_GROUP}" "${DEST}"

  cd "${DEST}"
  if [[ -f package.json ]]; then
    npm install
  else
    echo "Aviso: package.json não encontrado. Ajuste o repositório antes de instalar."
  fi
}

create_commands() {
  cat > /usr/local/bin/sync <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
cd /opt/sync-zoomier
exec /usr/bin/node index.js "$@"
EOF
  chmod +x /usr/local/bin/sync

  cat > /usr/local/bin/sync-env <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Arquivo .env: /opt/sync-zoomier/.env"
echo "Edite com: nano /opt/sync-zoomier/.env"
EOF
  chmod +x /usr/local/bin/sync-env
}

show_next_steps() {
  echo
  echo "Instalação concluída."
  echo "Próximos passos:"
  echo "1) cd ${DEST}"
  echo "2) se não existir .env: cp .env.example .env"
  echo "3) editar .env"
  echo "4) rodar: sync"
  echo
  echo "Se seu projeto real não usar index.js, ajuste o comando em /usr/local/bin/sync."
}

main() {
  need_root
  apt_base
  install_node
  create_user_if_needed
  install_app
  create_commands
  show_next_steps
}

main "$@"
