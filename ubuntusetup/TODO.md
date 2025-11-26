# TODO - Playbook Xubuntu 24.04 para Tiendas Clarel

## ✅ Completado

### 🔧 Configuración Base
- [x] Configuración de timezone (Europe/Madrid)
- [x] Configuración de locale (es_ES.UTF-8)
- [x] Instalación de paquetes base (git, vim, curl, htop, python3-pip, etc.) 
- [x] Instalación de XFCE4 y goodies
- [x] Actualización completa del sistema
- [x] Configuración de hostname

### 👥 Gestión de Usuarios
- [x] Creación de grupo común "clarel" -> Soporte es el unico que no esta
- [x] Usuario "soporte"
- [x] Usuario "tienda"
- [x] Usuario "instalador" (temporal con expiración 7 weeks de prueba)
- [x] Configuración de sudoers para soporte
- [x] Creación de directorios home (Documentos, Descargas, Escritorio)
- [x] **CORREGIDO**: Root NO se deshabilita completamente (solo en SSH)

### 🔒 Seguridad
- [x] Configuración SSH (PasswordAuthentication no, PermitRootLogin no)
- [x] Banner de login configurado 
- [x] **NOTA**: Root solo bloqueado en SSH, funciona con `sudo su` en consola local

### 🖥️ Configuración XFCE
- [x] LightDM configurado
- [x] Screensaver con bloqueo automático (5 minutos) Por defecto en sistema
- [x] Configuración de teclado español

### 📦 Software Instalado
- [x] **Google Chrome** (última versión estable)
  - [x] Repositorio configurado
  - [x] Acceso directo en escritorio ✓
- [x] **Rustdesk** (versión dinámica desde GitHub)
  - [x] Descarga automática de última versión vía API GitHub
  - [x] Extracción de `tag_name` del JSON
  - [x] Dependencias corregidas para Ubuntu 24.04 (libasound2t64)
  - [x] Servicio systemd configurado correctamente
  - [x] Configuración básica para usuarios
  - [x] Acceso directo en escritorio ✓
- [x] **Onboard** (teclado virtual)
  - [x] Instalado y configurado
  - [x] Layout español
- [x] **Grafana Alloy** (monitoreo/telemetría)
  - [x] Instalado
  - [x] Servicio detenido por defecto
  - [x] Sin acceso directo (es servicio de fondo)

### 🖨️ Impresión
- [x] CUPS instalado y configurado
- [x] Drivers de impresión instalados

### 🔧 Servicios
- [x] xinetd instalado y configurado

## ⚠️ Pendiente / Por Revisar

### 📦 Software
- [ ] **CMZ** - Pendiente de detalles de instalación
- [ ] Verificar si hay más software específico de tienda

### 🎨 Branding
- [x] Configuración de branding personalizado (cuando esté disponible)
- [x] Logos de Clarel [Logos Customizados]
- [x] Fondos de pantalla personalizados

### 🔧 dntouch
- [x] Configuración de drivers (deb)
- [x] Packages for Xorg [Logos Customizados]
- [x] Emualacion del click derecho

### 🧪 Testing
- [ ] Probar instalación completa en máquina limpia
- [x] Verificar acceso SSH con claves
- [x] Verificar que `sudo su` funciona correctamente
- [x] Probar Rustdesk conexión remota
- [ ] Probar impresión con CUPS
- [x] Verificar configuración XFCE al primer login


