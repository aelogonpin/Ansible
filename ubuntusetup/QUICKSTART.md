# Guía Rápida de Inicio

Esta guía te ayudará a ejecutar el playbook en menos de 5 minutos.

## Pre-requisitos Rápidos

```bash
# 1. Instalar Ansible
sudo apt update && sudo apt install -y ansible

# 2. Verificar instalación
ansible --version
```

## Configuración Rápida (3 Pasos)

### Paso 1: Configurar Contraseña de Usuarios

```bash
# Generar hash de contraseña
python3 -c 'import crypt; print(crypt.crypt("TuPassword123", crypt.mksalt(crypt.METHOD_SHA512)))'

# Copiar el resultado y editar
nano group_vars/all.yml

# Reemplazar esta línea:
# default_user_password: "$6$rounds=656000$YourSaltHere$YourHashHere"
# Con tu hash generado
```

### Paso 2: Configurar Clave SSH del Usuario Soporte

```bash
# Generar nueva clave SSH
ssh-keygen -t rsa -b 4096 -C "soporte@clarel.com" -f soporte_id_rsa

# Copiar clave pública al proyecto
cat soporte_id_rsa.pub > roles/users/files/soporte_id_rsa.pub

# Guardar la clave privada en lugar seguro
mv soporte_id_rsa ~/.ssh/
chmod 600 ~/.ssh/soporte_id_rsa
```

### Paso 3: Validar y Ejecutar

```bash
# Validar configuración
./validate.sh

# Ejecutar playbook
ansible-playbook -i inventory/hosts playbook.yml
```

## Ejecución en Local (Localhost)

Si estás configurando el sistema actual:

```bash
# El inventario ya está configurado para localhost
ansible-playbook -i inventory/hosts playbook.yml
```

## Ejecución en Host Remoto

Si quieres configurar otro sistema:

```bash
# 1. Editar inventario
nano inventory/hosts

# 2. Agregar:
[xubuntu_image]
miserver ansible_host=192.168.1.100 ansible_user=usuario

# 3. Ejecutar
ansible-playbook -i inventory/hosts playbook.yml
```

## Ejecución por Partes

Si quieres ejecutar solo algunas partes:

```bash
# Solo configuración base
make base

# Solo usuarios
make users

# Solo software
make software

# Solo XFCE
make xfce

# O con ansible-playbook directamente
ansible-playbook -i inventory/hosts playbook.yml --tags software
```

## Verificación Post-Instalación

```bash
# Verificar usuarios creados
id soporte
id tienda
id instalador

# Verificar software
google-chrome-stable --version
systemctl status cups
systemctl status xinetd

# Verificar XFCE (desde sesión gráfica)
xfconf-query -c xfce4-screensaver -lv
```

## Comandos Útiles con Make

```bash
# Ver ayuda
make help

# Validar antes de ejecutar
make validate

# Ejecutar en modo dry-run (sin cambios)
make check

# Ejecutar playbook completo
make run

# Ver roles disponibles
make roles
```

## Solución Rápida de Problemas

### Error: "Permission denied"

```bash
# Ejecutar con sudo
ansible-playbook -i inventory/hosts playbook.yml --ask-become-pass
```

### Error: "Host unreachable"

```bash
# Verificar conectividad
ansible -i inventory/hosts all -m ping

# Si es local, asegúrate de usar:
localhost ansible_connection=local
```

### Error: "Syntax error"

```bash
# Verificar sintaxis
ansible-playbook playbook.yml --syntax-check
```

## Siguiente Paso: Personalización

Una vez ejecutado el playbook básico, puedes personalizar:

1. **Branding**: Ver `/opt/clarel/branding/README.txt`
2. **Impresoras**: Ejecutar `/opt/scripts/agregar-impresora.sh`
3. **Alloy**: Configurar `/etc/alloy/config.alloy` y habilitar servicio
4. **Rustdesk**: Configurar servidor propio en `~/.config/rustdesk/RustDesk2.toml`

## Acceso al Sistema Configurado

Una vez completado el playbook:

- **Usuario soporte**: Solo SSH con clave privada
- **Usuario tienda**: Login con contraseña configurada
- **Usuario instalador**: Login con contraseña (expira en 90 días)

```bash
# Conectar como soporte
ssh -i ~/.ssh/soporte_id_rsa soporte@hostname
```

## Recursos Adicionales

- `README.md` - Documentación completa
- `VAULT_EXAMPLE.md` - Uso de ansible-vault para contraseñas
- `/opt/scripts/` - Scripts de utilidad en el sistema configurado
- `make help` - Comandos disponibles

## Tips Finales

1. Ejecuta `./validate.sh` antes de cada ejecución
2. Usa `make check` para ver qué cambiará antes de aplicar
3. Usa tags para ejecutar solo lo necesario
4. Revisa logs en `/var/log/clarel/` después de ejecutar
5. Guarda copias de seguridad de tus variables y claves

---

**¿Necesitas ayuda?** Revisa el `README.md` completo o contacta al equipo de soporte.
