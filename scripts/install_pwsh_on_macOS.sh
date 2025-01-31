#!/bin/bash
# Script : install_pwsh_on_macOS.sh
# Description : Installe/désinstalle PowerShell sur macOS avec vérification d'intégrité
# Auteur : valorisa
# Licence : MIT
# Usage : ./install_pwsh_on_macOS.sh [--install [version] [hash]] [--uninstall] [--help]

# Configuration par défaut (Apple Silicon)
DEFAULT_VERSION="7.5.0"
DEFAULT_ARCH="osx-arm64"  # 'osx-x64' pour Intel
DEFAULT_HASH="d50eb1c9c8b36d1fa0cb8dc707f9fdbd724806d61593420feee35f423e102adc"

# Couleurs pour le terminal
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Fonction d'aide
show_help() {
    echo -e "${CYAN}Usage :${NC}"
    echo -e "  ${GREEN}./install_pwsh_on_macOS.sh --install [version] [hash]${NC}  Installe une version spécifique"
    echo -e "  ${GREEN}./install_pwsh_on_macOS.sh --uninstall${NC}                 Désinstalle PowerShell"
    echo -e "  ${GREEN}./install_pwsh_on_macOS.sh --help${NC}                      Affiche ce message"
    echo -e "\n${CYAN}Exemples :${NC}"
    echo -e "  ${YELLOW}Installation par défaut (Apple Silicon) :${NC}"
    echo -e "  ./install_pwsh_on_macOS.sh --install\n"
    echo -e "  ${YELLOW}Installation personnalisée (Intel) :${NC}"
    echo -e "  ./install_pwsh_on_macOS.sh --install 7.4.2 6d29605e0c5d4810a3f1e3d8e8b4f7e1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8 osx-x64"
}

# Désinstaller PowerShell
uninstall_pwsh() {
    echo -e "\n${CYAN}➤ Désinstallation de PowerShell...${NC}"
    if [ -f "/usr/local/bin/pwsh" ]; then
        sudo rm -f /usr/local/bin/pwsh && \
        echo -e "${GREEN}✓ PowerShell a été désinstallé.${NC}"
    else
        echo -e "${YELLOW}⚠ PowerShell n'est pas installé.${NC}"
    fi
}

# Installer PowerShell
install_pwsh() {
    local version="$1"
    local expected_hash="$2"
    local arch="$3"
    local url="https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${arch}.tar.gz"
    local temp_file="/tmp/powershell-${version}.tar.gz"
    local temp_dir=$(mktemp -d)

    # Téléchargement
    echo -e "\n${CYAN}➤ Téléchargement de PowerShell v${version} (${arch})...${NC}"
    if ! curl -L -o "${temp_file}" "${url}"; then
        echo -e "${RED}✗ Échec du téléchargement.${NC}" >&2
        return 1
    fi

    # Vérification du hash
    echo -e "${CYAN}➤ Vérification de l'intégrité (SHA256)...${NC}"
    local actual_hash=$(shasum -a 256 "${temp_file}" | awk '{print $1}')
    if [[ "${actual_hash}" != "${expected_hash}" ]]; then
        echo -e "${RED}✗ Hash invalide :${NC}"
        echo -e "  ${YELLOW}Attendu : ${expected_hash}${NC}"
        echo -e "  ${YELLOW}Reçu    : ${actual_hash}${NC}"
        return 1
    fi

    # Installation
    echo -e "${CYAN}➤ Installation dans /usr/local/bin...${NC}"
    if ! tar -xzf "${temp_file}" -C "${temp_dir}"; then
        echo -e "${RED}✗ Échec de l'extraction.${NC}" >&2
        return 1
    fi
    
    sudo mv -f "${temp_dir}/pwsh" "/usr/local/bin/pwsh" && \
    sudo chmod +x "/usr/local/bin/pwsh"

    # Nettoyage
    rm -rf "${temp_file}" "${temp_dir}"
    echo -e "\n${GREEN}✓ PowerShell v${version} installé avec succès !${NC}"
    echo -e "${CYAN}➤ Vérification :${NC}"
    pwsh --version
}

# Gestion des arguments
case "$1" in
    --install)
        version="${2:-$DEFAULT_VERSION}"
        hash="${3:-$DEFAULT_HASH}"
        arch="${4:-$DEFAULT_ARCH}"
        install_pwsh "$version" "$hash" "$arch" || exit 1
        ;;
    --uninstall)
        uninstall_pwsh
        ;;
    --help|*)
        show_help
        exit 0
        ;;
esac
