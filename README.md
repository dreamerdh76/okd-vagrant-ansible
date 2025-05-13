# OKD 3.11 Vagrant/Ansible Lab

Spin up a two‑node OKD 3.11 cluster (1 master + 1 worker) entirely from your Ubuntu 22.04+ workstation with **one command**:

```bash
chmod +x run_bootstrap.sh
./run_bootstrap.sh
```

The script installs every prerequisite (Ansible, Vagrant 2.4.5, VirtualBox 7.0), brings the Vagrant VMs online, and launches the Ansible playbooks that prepare the host and deploy the cluster.

---

## Table of Contents
1. [Architecture](#architecture)
2. [Repository Layout](#repository-layout)
3. [Prerequisites](#prerequisites)
4. [Quick Start](#quick-start)
5. [Cluster Access](#cluster-access)
6. [Destroy / Rebuild](#destroy--rebuild)
7. [Troubleshooting](#troubleshooting)
8. [License](#license)

---

## Architecture
| Role     | Hostname            | IP address   | Node group                    |
|----------|--------------------|--------------|------------------------------|
| Master   | `master.okd.local` | 192.168.50.10 | `node-config-master`          |
| Worker   | `worker1.okd.local`| 192.168.50.11 | `node-config-compute`         |

*OpenShift Origin release **v3.11.0** – images tagged `v3.11.0`.*

---

## Repository Layout
```
.
├── inventory.ini           # Static inventory for OKD
├── Vagrantfile             # Defines the two CentOS 7 VMs
├── playbooks/
│   ├── bootstrap.yml       # Installs host tools + starts Vagrant + wrappers
│   ├── prereq-wrapper.yml  # Runs openshift_prerequisites role
│   └── deploy-wrapper.yml  # Runs openshift_install role
├── run_bootstrap.sh        # One‑shot launcher (calls Ansible)
└── README.md
```

---

## Prerequisites
| Requirement           | Minimum | Notes                                                |
|-----------------------|---------|------------------------------------------------------|
| Host OS               | Ubuntu 22.04 LTS           | Tested on Jammy; Noble works by adjusting `vbox_repo`. |
| CPU / RAM             | 4 vCPU / 8 GB              | Change in `Vagrantfile` if you have more resources.   |
| Disk space            | 40 GB free                 | Images + logs + containers.                           |
| Internet connectivity | Required first run         | Packages and container images are downloaded.         |

> **Tip:** `run_bootstrap.sh` will prompt for **sudo** because the playbook needs to install system packages.

---

## Quick Start
```bash
# 1. Clone the repository
git clone https://github.com/your‑org/okd-vagrant-lab.git
cd okd-vagrant-lab

# 2. Make the launcher executable (once)
chmod +x run_bootstrap.sh

# 3. Fire!
./run_bootstrap.sh
```
The flow is:

1. **install‑check** → ensures Ansible is present (installs if missing)  
2. **bootstrap.yml** → sets up HashiCorp + Oracle repos, installs Vagrant & VirtualBox  
3. `vagrant up` → provisions the CentOS 7 VMs (`master`, `worker1`)  
4. `ansible-playbook prereq-wrapper.yml` → runs `openshift_prerequisites`  
5. `ansible-playbook deploy-wrapper.yml` → runs `openshift_install`

Grab a coffee—first run takes ~20 min on a typical laptop.

---

## Cluster Access
```bash
# Log in to the master VM
vagrant ssh master

# Or from your host, use oc:
oc login https://192.168.50.10:8443 -u system:admin
```
Console URL: **https://192.168.50.10:8443**  
(Default self‑signed certificates; accept the warning in your browser.)

---

## Destroy / Rebuild
```bash
# Shut down and delete VMs
vagrant destroy -f

# Remove downloaded boxes if you want
vagrant box prune
```
Then run `./run_bootstrap.sh` again for a clean rebuild.

---

## Troubleshooting
| Symptom                              | Likely cause / fix                                |
|--------------------------------------|---------------------------------------------------|
| `E: Could not get lock /var/lib/dpkg`| Another apt process is running—`sudo lsof /var/lib/dpkg/lock-frontend` then kill it. |
| “Certificate error” in browser       | Self‑signed cert—click **Advanced → Proceed**.    |
| Pods stuck in `ImagePullBackOff`     | Check internet connection or proxy settings.      |
| VM won’t start (VT‑x/AMD‑V error)    | Enable virtualization in BIOS/UEFI.               |

---

## License
MIT © 2025 Alexander Pupo Finales

---

# Laboratorio OKD 3.11 con Vagrant y Ansible

Levanta un clúster de OKD 3.11 con dos nodos (1 master + 1 worker) **con un solo comando** desde tu estación Ubuntu 22.04+:

```bash
chmod +x run_bootstrap.sh
./run_bootstrap.sh
```

El script instala todos los prerrequisitos (Ansible, Vagrant 2.4.5, VirtualBox 7.0), crea las VMs de Vagrant y ejecuta los playbooks que preparan el host y despliegan el clúster.

---

## Índice
1. [Arquitectura](#arquitectura)
2. [Estructura del repo](#estructura-del-repo)
3. [Prerrequisitos](#prerrequisitos)
4. [Puesta en marcha](#puesta-en-marcha)
5. [Acceso al clúster](#acceso-al-clúster)
6. [Destruir / Reconstruir](#destruir--reconstruir)
7. [Solución de problemas](#solución-de-problemas)
8. [Licencia](#licencia)

---

## Arquitectura
| Rol     | Hostname            | IP            | Node group            |
|---------|--------------------|---------------|-----------------------|
| Master  | `master.okd.local` | 192.168.50.10 | `node-config-master`  |
| Worker  | `worker1.okd.local`| 192.168.50.11 | `node-config-compute` |

*OpenShift Origin versión **v3.11.0** – imágenes `v3.11.0`.*

---

## Estructura del repo
```
.
├── inventory.ini           # Inventario estático para OKD
├── Vagrantfile             # Define las dos VMs CentOS 7
├── playbooks/
│   ├── bootstrap.yml       # Instala herramientas y lanza Vagrant
│   ├── prereq-wrapper.yml  # Ejecuta openshift_prerequisites
│   └── deploy-wrapper.yml  # Ejecuta openshift_install
├── run_bootstrap.sh        # Lanzador “todo‑en‑uno”
└── README.md
```

---

## Prerrequisitos
| Requisito            | Mínimo         | Notas                                             |
|----------------------|----------------|---------------------------------------------------|
| SO huésped           | Ubuntu 22.04   | Probado en Jammy; para 24.04 ajusta `vbox_repo`.  |
| CPU / RAM            | 4 vCPU / 8 GB  | Modifica en `Vagrantfile` si tienes más recursos. |
| Espacio en disco     | 40 GB libres   | Imágenes + logs + contenedores.                   |
| Conexión a internet  | Obligatoria    | Descarga paquetes e imágenes la primera vez.      |

> **Nota:** `run_bootstrap.sh` pedirá **sudo** porque el playbook instala paquetes del sistema.

---

## Puesta en marcha
```bash
# 1. Clona el repositorio
git clone https://github.com/tu‑org/okd-vagrant-lab.git
cd okd-vagrant-lab

# 2. Da permiso de ejecución al lanzador (una sola vez)
chmod +x run_bootstrap.sh

# 3. ¡A volar!
./run_bootstrap.sh
```
Flujo interno:

1. **install‑check** → verifica Ansible (lo instala si falta)  
2. **bootstrap.yml** → configura repos HashiCorp / Oracle, instala Vagrant y VirtualBox  
3. `vagrant up` → crea las VMs (`master`, `worker1`)  
4. `ansible-playbook prereq-wrapper.yml` → corre `openshift_prerequisites`  
5. `ansible-playbook deploy-wrapper.yml` → corre `openshift_install`

Primera ejecución ≈ 20 min en un portátil medio.

---

## Acceso al clúster
```bash
# Conéctate al master
vagrant ssh master

# O desde tu host:
oc login https://192.168.50.10:8443 -u system:admin
```
Consola web: **https://192.168.50.10:8443**  
(Certificados autofirmados; acepta la advertencia en el navegador.)

---

## Destruir / Reconstruir
```bash
# Apaga y elimina las VMs
vagrant destroy -f

# Borra las boxes si quieres
vagrant box prune
```
Ejecuta de nuevo `./run_bootstrap.sh` para reconstruir desde cero.

---

## Solución de problemas
| Síntoma                                | Causa probable / solución                       |
|----------------------------------------|-------------------------------------------------|
| `E: No se pudo obtener un bloqueo dpkg`| Otro proceso apt activo—`sudo lsof /var/lib/dpkg/lock-frontend` y elimínalo. |
| “Error de certificado” en el navegador | Certificado autofirmado—clic **Avanzado → Continuar**. |
| Pods en `ImagePullBackOff`             | Revisa conexión a internet o proxy.             |
| VM no arranca (VT‑x/AMD‑V)             | Activa virtualización en BIOS/UEFI.             |

---

## Licencia
MIT © 2025 Alexander Pupo Finales
