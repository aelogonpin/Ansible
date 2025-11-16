# Uso de Ansible Vault para Contraseñas

Este archivo explica cómo usar Ansible Vault para proteger contraseñas y datos sensibles.

## ¿Qué es Ansible Vault?

Ansible Vault es una herramienta para encriptar datos sensibles como contraseñas, claves API, etc.

## Generar Hash de Contraseña

Antes de usar vault, necesitas generar un hash de la contraseña:

```bash
# Opción 1: Usando mkpasswd
mkpasswd --method=sha-512

# Opción 2: Usando Python
python3 -c 'import crypt; print(crypt.crypt("TU_PASSWORD_AQUI", crypt.mksalt(crypt.METHOD_SHA512)))'
```

El resultado será algo como:
```
$6$rounds=656000$SomeRandomSalt$VeryLongHashedPasswordString...
```

## Crear Archivo de Variables Encriptado

### 1. Crear archivo vault con contraseñas

```bash
# Crear nuevo archivo encriptado
ansible-vault create group_vars/vault.yml
```

Te pedirá una contraseña para el vault. Luego añade:

```yaml
---
# Contraseñas encriptadas
vault_default_password: "$6$rounds=656000$....."
vault_soporte_password: "$6$rounds=656000$....."
vault_tienda_password: "$6$rounds=656000$....."
vault_instalador_password: "$6$rounds=656000$....."
```

### 2. Referenciar en group_vars/all.yml

Ya está configurado en `group_vars/all.yml`:

```yaml
default_user_password: "{{ vault_default_password | default('$6$...') }}"
```

## Editar Archivo Vault

```bash
# Editar archivo encriptado existente
ansible-vault edit group_vars/vault.yml
```

## Ver Contenido del Vault

```bash
# Ver contenido sin editar
ansible-vault view group_vars/vault.yml
```

## Ejecutar Playbook con Vault

### Opción 1: Pedir contraseña interactivamente

```bash
ansible-playbook -i inventory/hosts playbook.yml --ask-vault-pass
```

### Opción 2: Usar archivo de contraseña

```bash
# Crear archivo con la contraseña del vault
echo "tu_password_del_vault" > .vault_pass
chmod 600 .vault_pass

# Ejecutar playbook
ansible-playbook -i inventory/hosts playbook.yml --vault-password-file .vault_pass

# O configurar en ansible.cfg
# vault_password_file = .vault_pass
```

## Ejemplo Completo

### 1. Generar hash de contraseña

```bash
python3 -c 'import crypt; print(crypt.crypt("Clarel2025!", crypt.mksalt(crypt.METHOD_SHA512)))'
```

Resultado:
```
$6$xyz123$abc456def789...
```

### 2. Crear vault

```bash
ansible-vault create group_vars/vault.yml
# Contraseña del vault: VaultPass123

# Contenido del archivo:
---
vault_default_password: "$6$xyz123$abc456def789..."
```

### 3. Ejecutar playbook

```bash
ansible-playbook -i inventory/hosts playbook.yml --ask-vault-pass
# Introducir: VaultPass123
```

## Cambiar Contraseña del Vault

```bash
ansible-vault rekey group_vars/vault.yml
```

## Encriptar Variable Individual

Si solo necesitas encriptar una variable:

```bash
ansible-vault encrypt_string 'mi_password_secreta' --name 'vault_default_password'
```

Resultado:
```yaml
vault_default_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66386439653333363633373064303865613...
```

## Sin Usar Vault (Solo para Testing)

Si no quieres usar vault temporalmente:

1. Genera el hash de la contraseña:
   ```bash
   mkpasswd --method=sha-512
   ```

2. Edita `group_vars/all.yml`:
   ```yaml
   default_user_password: "$6$xyz123$abc456def789..."
   ```

3. Ejecuta normalmente:
   ```bash
   ansible-playbook -i inventory/hosts playbook.yml
   ```

## Recomendaciones de Seguridad

1. **NUNCA** commitear `.vault_pass` a git (ya está en .gitignore)
2. Usar contraseñas fuertes para el vault
3. Rotar contraseñas periódicamente
4. Mantener backups seguros del vault password
5. Usar diferentes contraseñas para vault en diferentes entornos (dev, prod)

## Troubleshooting

### Error: "Decryption failed"

- Contraseña del vault incorrecta
- Archivo corrupto
- Usar `ansible-vault view` para verificar

### Error: "Vault format unhashed_prompt_string is not supported"

- Estás intentando usar una contraseña en texto plano
- Necesitas generar el hash primero con `mkpasswd`

### Error: "vault_default_password is undefined"

- El archivo vault.yml no existe o no está cargado
- Crear el archivo o usar valor por defecto en group_vars/all.yml
