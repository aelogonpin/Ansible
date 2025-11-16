# Ansible Playbook - Configuración de Xubuntu 24.04 para Tiendas Clarel

Este proyecto de Ansible automatiza la configuración completa de imágenes de Xubuntu 24.04 para su uso en tiendas.

## Características Principales

### Sistema Operativo
- **SO Base**: Xubuntu 24.04 LTS con XFCE
- **Entorno de Escritorio**: XFCE 4 completamente configurado
- **Display Manager**: LightDM

### Usuarios Configurados

| Usuario      | UID  | Grupos                  | Permisos | Acceso SSH | Notas                              |
|-------------|------|-------------------------|----------|------------|-----------------------------------|
| `soporte`   | 1001 | sudo, dialout, plugdev | Completo | Clave RSA  | Usuario administrador             |
| `tienda`    | 1002 | users, dialout, plugdev| Limitado | No         | Usuario operativo de tienda       |
| `instalador`| 1003 | users, dialout, plugdev| Limitado | No         | Temporal, expira en 90 días       |
| `root`      | -    | -                       | Capado   | No         | Login directo deshabilitado       |

**Contraseña por defecto**: La misma para todos los usuarios (configurar en variables)

### Software Preinstalado

- **Google Chrome Stable** - Navegador web principal
- **CUPS** - Sistema de impresión
- **xinetd** - Super servidor de servicios de red
- **Rustdesk** - Acceso remoto al escritorio
- **Grafana Alloy** - Agente de telemetría (instalado pero deshabilitado)
- **Onboard** - Teclado virtual en pantalla

### Configuración de Seguridad

- Bloqueo de pantalla automático: **5 minutos** de inactividad
- Root deshabilitado para login directo
- SSH configurado solo con claves públicas
- Firewall UFW disponible (opcional)

### Impresoras

- CUPS instalado y configurado
- Navegación de impresoras de red habilitada
- Interfaz web: http://localhost:631

## Estructura del Proyecto

```
ansible/
├── ansible.cfg                    # Configuración de Ansible
├── inventory/
│   └── hosts                      # Inventario de hosts
├── group_vars/
│   └── all.yml                    # Variables globales
├── playbook.yml                   # Playbook principal
└── roles/
    ├── base/                      # Configuración base del sistema
    ├── users/                     # Gestión de usuarios
    ├── security/                  # Configuración de seguridad
    ├── xfce_config/              # Configuración de XFCE
    ├── software/                  # Instalación de software
    ├── printing/                  # CUPS e impresoras
    ├── services/                  # xinetd y servicios
    └── branding/                  # Personalización corporativa
```

## Requisitos Previos

### En el sistema de control (donde se ejecuta Ansible)

```bash
# Instalar Ansible
sudo apt update
sudo apt install ansible

# Verificar instalación
ansible --version
```

### En el sistema destino (Xubuntu a configurar)

- Xubuntu 24.04 instalado
- Usuario con permisos sudo
- Conexión de red activa
- Python 3 instalado (viene por defecto)

## Configuración Inicial

### 1. Configurar Variables

Editar `group_vars/all.yml` y personalizar:

```yaml
# Contraseña de usuarios (encriptar con ansible-vault)
default_user_password: "..."

# Configuración de XFCE
xfce_screen_lock_timeout: 5  # minutos

# Software
chrome_version: "stable"
rustdesk_version: "latest"

# Timezone
system_timezone: "Europe/Madrid"
system_locale: "es_ES.UTF-8"
```

### 2. Configurar Clave SSH del Usuario Soporte

Copiar la clave pública SSH del usuario soporte:

```bash
# Generar clave si no existe
ssh-keygen -t rsa -b 4096 -C "soporte@clarel.com" -f soporte_id_rsa

# Copiar la clave pública al archivo correspondiente
cat soporte_id_rsa.pub > roles/users/files/soporte_id_rsa.pub
```

### 3. Encriptar Contraseñas

```bash
# Generar hash de contraseña
mkpasswd --method=sha-512

# O con Python
python3 -c 'import crypt; print(crypt.crypt("TU_PASSWORD", crypt.mksalt(crypt.METHOD_SHA512)))'

# Actualizar en group_vars/all.yml
```

### 4. Configurar Inventario

Editar `inventory/hosts`:

```ini
[xubuntu_image]
localhost ansible_connection=local

# O para configurar un host remoto:
# servidor ansible_host=192.168.1.100 ansible_user=usuario ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Uso

### Ejecución Completa

```bash
# Ejecutar playbook completo
ansible-playbook -i inventory/hosts playbook.yml

# Con modo verboso
ansible-playbook -i inventory/hosts playbook.yml -v

# Modo dry-run (simular sin cambios)
ansible-playbook -i inventory/hosts playbook.yml --check
```

### Ejecución por Tags

```bash
# Solo configuración base
ansible-playbook -i inventory/hosts playbook.yml --tags base

# Solo usuarios
ansible-playbook -i inventory/hosts playbook.yml --tags users

# Solo software
ansible-playbook -i inventory/hosts playbook.yml --tags software

# Solo XFCE
ansible-playbook -i inventory/hosts playbook.yml --tags xfce

# Solo seguridad
ansible-playbook -i inventory/hosts playbook.yml --tags security

# Solo impresoras
ansible-playbook -i inventory/hosts playbook.yml --tags printing

# Solo servicios
ansible-playbook -i inventory/hosts playbook.yml --tags services

# Solo branding
ansible-playbook -i inventory/hosts playbook.yml --tags branding

# Múltiples tags
ansible-playbook -i inventory/hosts playbook.yml --tags "users,software,xfce"
```

### Ejecución de Roles Específicos

```bash
# Ejecutar solo un role
ansible-playbook -i inventory/hosts playbook.yml --tags base

# Saltar roles específicos
ansible-playbook -i inventory/hosts playbook.yml --skip-tags branding
```

## Verificación Post-Instalación

### Verificar Usuarios

```bash
# Listar usuarios creados
id soporte
id tienda
id instalador

# Verificar grupos
groups soporte
groups tienda

# Verificar expiración de instalador
sudo chage -l instalador
```

### Verificar Software

```bash
# Chrome
google-chrome-stable --version

# CUPS
systemctl status cups

# xinetd
systemctl status xinetd

# Rustdesk
systemctl status rustdesk

# Onboard
onboard --version
```

### Verificar XFCE

```bash
# Verificar configuración de screensaver
xfconf-query -c xfce4-screensaver -lv

# Verificar power manager
xfconf-query -c xfce4-power-manager -lv
```

## Personalización

### Agregar Software Adicional

1. Crear nuevo archivo en `roles/software/tasks/`
2. Agregar include en `roles/software/tasks/main.yml`
3. Ejecutar: `ansible-playbook playbook.yml --tags software`

### Configurar Branding

1. Obtener recursos de marketing
2. Copiar a `/opt/clarel/branding/`
3. Editar `group_vars/all.yml`:
   ```yaml
   branding_enabled: true
   branding_wallpaper: "wallpaper.jpg"
   branding_logo: "logo.png"
   ```
4. Ejecutar: `ansible-playbook playbook.yml --tags branding`

### Configurar Impresoras

```bash
# Mediante interfaz web
xdg-open http://localhost:631

# O mediante línea de comandos
sudo lpadmin -p NombreImpresora -v socket://192.168.1.100 -E

# Script de ayuda
/opt/scripts/agregar-impresora.sh
```

## Scripts de Utilidad

El playbook instala varios scripts de ayuda en `/opt/scripts/`:

- `gestionar-servicios.sh` - Estado de servicios del sistema
- `agregar-impresora.sh` - Ayuda para agregar impresoras
- `aplicar-branding.sh` - Aplicar branding corporativo
- `system-monitor.sh` - Monitoreo simple del sistema
- `configure-xfce-first-login.sh` - Configuración inicial de XFCE

## Solución de Problemas

### Ansible no encuentra el host

```bash
# Verificar conectividad
ansible -i inventory/hosts all -m ping

# Verificar inventario
ansible-inventory -i inventory/hosts --list
```

### Error de permisos

```bash
# Ejecutar con become (sudo)
ansible-playbook -i inventory/hosts playbook.yml --ask-become-pass
```

### Software no se instala

```bash
# Actualizar cache de APT
sudo apt update

# Verificar repositorios
cat /etc/apt/sources.list
```

### Screensaver no se bloquea

```bash
# Verificar configuración
xfconf-query -c xfce4-screensaver -p /lock/enabled

# Reiniciar screensaver
killall xfce4-screensaver
xfce4-screensaver &
```

## Mantenimiento

### Actualizar Sistema

```bash
# Actualizar solo paquetes
ansible-playbook -i inventory/hosts playbook.yml --tags base -e perform_system_upgrade=true

# O manualmente en el sistema
sudo apt update && sudo apt upgrade
```

### Backup de Configuración

```bash
# Backup de home de usuarios
sudo tar -czf /backup/homes-$(date +%Y%m%d).tar.gz /home/soporte /home/tienda /home/instalador

# Backup de configuración del sistema
sudo tar -czf /backup/etc-$(date +%Y%m%d).tar.gz /etc
```

## Seguridad

### Cambiar Contraseñas

```bash
# Cambiar contraseña de usuario
sudo passwd tienda

# Generar nueva hash para Ansible
mkpasswd --method=sha-512
```

### Auditoría de Seguridad

```bash
# Ver logs de auditoría
sudo aureport -au

# Verificar permisos de archivos críticos
ls -la /etc/passwd /etc/shadow
```

## Notas Importantes

- **CMZ**: Pendiente de definir e implementar
- **Branding**: Pendiente de recursos de marketing
- **Alloy**: Instalado pero requiere configuración antes de habilitar
- **Rustdesk**: Puede requerir configuración de servidor propio
- **Contraseñas**: Usar la misma contraseña para todos los usuarios como solicitado

## Soporte y Contacto

Para problemas o consultas sobre este playbook:
- Revisar logs en `/var/log/clarel/`
- Consultar documentación de roles individuales
- Ejecutar scripts de diagnóstico en `/opt/scripts/`

## Licencia

Uso interno de Clarel.

---

**Versión**: 1.0
**Última actualización**: 2025-01-12
**Compatible con**: Xubuntu 24.04 LTS
