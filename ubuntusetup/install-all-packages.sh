#!/bin/bash
#
# Script de instalación de paquetes - Sistema Xubuntu Clarel
# Instala todos los paquetes configurados en el playbook de Ansible
#

set -e  # Detener en caso de error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================================================"
echo "  Instalación de paquetes - Sistema Xubuntu Clarel"
echo "======================================================================"
echo ""

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: Este script debe ejecutarse como root (sudo)${NC}"
    exit 1
fi

echo -e "${GREEN}[1/8] Actualizando índice de paquetes...${NC}"
apt update

echo ""
echo -e "${GREEN}[2/8] Instalando paquetes base del sistema...${NC}"
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    gnupg2 \
    software-properties-common \
    python3 \
    python3-pip \
    git \
    vim \
    nano \
    htop \
    net-tools \
    openssh-server \
    rsync \
    unzip \
    zip \
    build-essential \
    dbus-x11 \
    sshpass

echo ""
echo -e "${GREEN}[3/8] Instalando XFCE y entorno gráfico...${NC}"
apt install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-screensaver \
    xfce4-power-manager \
    lightdm \
    lightdm-gtk-greeter \
    thunderbird-locale-es-es \
    dconf-cli \
    dconf-gsettings-backend \
    locales \
    language-pack-es \
    language-pack-es-base \
    language-pack-gnome-es \
    keyboard-configuration \
    console-setup

echo ""
echo -e "${GREEN}[4/8] Instalando software adicional...${NC}"
apt install -y \
    subversion \
    onboard \
    onboard-data \
    xinetd \
    systemd-timesyncd \
    ufw \
    xdg-user-dirs

echo ""
echo -e "${GREEN}[5/8] Instalando CUPS (sistema de impresión)...${NC}"
apt install -y \
    cups \
    cups-client \
    cups-filters \
    system-config-printer

echo ""
echo -e "${GREEN}[6/8] Instalando Google Chrome...${NC}"
# Agregar clave GPG de Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

# Agregar repositorio de Chrome
if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
fi

# Actualizar e instalar Chrome
apt update
apt install -y google-chrome-stable

echo ""
echo -e "${GREEN}[7/8] Instalando Grafana Alloy...${NC}"
# Crear directorio para claves APT
mkdir -p /etc/apt/keyrings

# Descargar clave GPG de Grafana
wget -q -O /etc/apt/keyrings/grafana.asc https://apt.grafana.com/gpg.key

# Agregar repositorio de Grafana
if [ ! -f /etc/apt/sources.list.d/grafana.list ]; then
    echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list
fi

# Actualizar e instalar Alloy
apt update
apt install -y alloy

echo ""
echo -e "${GREEN}[8/8] Instalando Rustdesk y dependencias...${NC}"

# Instalar dependencias de Rustdesk
apt install -y \
    libgtk-3-0 \
    libxcb-randr0 \
    libxdo3 \
    libxfixes3 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libasound2t64 \
    libsystemd0 \
    libva-drm2 \
    libva-x11-2 \
    libvdpau1 \
    libgstreamer-plugins-base1.0-0 \
    libpam0g \
    gstreamer1.0-pipewire \
    libayatana-appindicator3-1

# Obtener última versión de Rustdesk
echo -e "${YELLOW}Descargando última versión de Rustdesk...${NC}"
RUSTDESK_VERSION=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
RUSTDESK_URL="https://github.com/rustdesk/rustdesk/releases/download/${RUSTDESK_VERSION}/rustdesk-${RUSTDESK_VERSION}-x86_64.deb"

echo -e "${YELLOW}Versión detectada: ${RUSTDESK_VERSION}${NC}"
wget -O /tmp/rustdesk.deb "$RUSTDESK_URL"

# Instalar Rustdesk
dpkg -i /tmp/rustdesk.deb || apt install -f -y

# Limpiar archivo temporal
rm -f /tmp/rustdesk.deb

echo ""
echo -e "${GREEN}======================================================================"
echo -e "  Instalación completada exitosamente"
echo -e "======================================================================${NC}"
echo ""
echo "Paquetes instalados:"
echo "  - Sistema base: apt, curl, wget, git, vim, nano, htop, sshpass, etc."
echo "  - Entorno gráfico: XFCE4, LightDM, dconf"
echo "  - Locale e idioma: locales, language-pack-es, keyboard-configuration"
echo "  - Software: Google Chrome, Rustdesk, Onboard, Subversion"
echo "  - Servicios: CUPS, xinetd, Grafana Alloy"
echo "  - Seguridad: UFW, openssh-server"
echo ""
echo "Versiones instaladas:"
google-chrome-stable --version 2>/dev/null || echo "  Chrome: No disponible"
rustdesk --version 2>/dev/null || echo "  Rustdesk: Instalado (ejecutar 'rustdesk --version' como usuario)"
alloy --version 2>/dev/null || echo "  Alloy: No disponible"
onboard --version 2>/dev/null || echo "  Onboard: Instalado"
echo ""
echo -e "${YELLOW}NOTA: Algunos servicios pueden requerir configuración adicional.${NC}"
echo -e "${YELLOW}Consulta el playbook de Ansible para configuraciones específicas.${NC}"
echo ""
