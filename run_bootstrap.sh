set -e 

echo "▶ Verificando Ansible…"
if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "⚙️  Ansible no encontrado. Instalando…"
  sudo apt-get update -y
  sudo apt-get install -y ansible
else
  echo "✅ Ansible ya está instalado."
fi

echo "▶ Ejecutando playbook bootstrap.yml"

sudo ansible-playbook bootstrap.yml -vv

