#!/bin/bash
# Script : install_pwsh_on_macOS.sh
# Description : Installe/désinstalle PowerShell sur macOS avec gestion multi-versions et vérification des mises à jour
# Auteur : valorisa
# Licence : MIT
# Usage : 
#   Installation : sudo ./install_pwsh_on_macOS.sh --install [version] [arch] [hash]
#   Désinstallation : sudo ./install_pwsh_on_macOS.sh --uninstall
#   Vérification mises à jour : ./install_pwsh_on_macOS.sh --check-updates

# Configuration par défaut (Apple Silicon)
DEFAULT_VERSION="7.5.0"
DEFAULT_ARCH="osx-arm64"
DEFAULT_HASH="d50eb1c9c8b36d1fa0cb8dc707f9fdbd724806d61593420feee35f423e102adc"

# Couleurs pour le terminal
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

# Fonction d'aide
show_help() {
    echo -e "${CYAN}Usage :${NC}"
    echo -e "  ${GREEN}sudo ./install_pwsh_on_macOS.sh --install [version] [arch] [hash]${NC}"
    echo -e "  ${GREEN}sudo ./install_pwsh_on_macOS.sh --uninstall${NC}"
    echo -e "  ${GREEN}./install_pwsh_on_macOS.sh --check-updates${NC}"
    echo -e "\n${CYAN}Exemples :${NC}"
    echo -e "  Installation Apple Silicon : ${YELLOW}sudo ./install_pwsh_on_macOS.sh --install 7.5.0 osx-arm64 d50eb1c9...${NC}"
    echo -e "  Installation Intel : ${YELLOW}sudo ./install_pwsh_on_macOS.sh --install 7.4.2 osx-x64 6d29605e...${NC}"
    echo -e "  Vérification mises à jour : ${YELLOW}./install_pwsh_on_macOS.sh --check-updates${NC}"
}

# Désinstaller PowerShell
uninstall_pwsh() {
    echo -e "\n${CYAN}➤ Désinstallation de PowerShell...${NC}"
    if [ -f "/usr/local/bin/pwsh" ]; then
        sudo rm -f /usr/local/bin/pwsh && \
        echo -e "${GREEN}✓ PowerShell désinstallé avec succès.${NC}"
    else
        echo -e "${YELLOW}⚠ PowerShell n'est pas installé.${NC}"
    fi
}

# Vérifier les mises à jour
check_updates() {
    echo -e "\n${CYAN}➤ Vérification des mises à jour...${NC}"
    echo -e "${YELLOW}Connexion à GitHub...${NC}"
    
    # Récupérer la dernière version via l'API GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep -oP '"tag_name": "\Kv?\d+\.\d+\.\d+')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}✗ Impossible de récupérer la dernière version.${NC}"
        return 1
    fi

    echo -e "\n${GREEN}✓ Dernière version disponible : ${CYAN}$LATEST_VERSION${NC}"
    echo -e "${YELLOW}Astuce : Utilisez '--install $LATEST_VERSION' pour mettre à jour.${NC}"
}

# Installer PowerShell
install_pwsh() {
    local version="${1:-$DEFAULT_VERSION}"
    local arch="${2:-$DEFAULT_ARCH}"
    local expected_hash="${3:-$DEFAULT_HASH}"
    local url="https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${arch}.tar.gz"
    local temp_file="/tmp/powershell-${version}.tar.gz"
    local temp_dir=$(mktemp -d)

    # Téléchargement
    echo -e "\n${CYAN}➤ Téléchargement de PowerShell v${version} (${arch})...${NC}"
    if ! curl -L -o "$temp_file" "$url"; then
        echo -e "${RED}✗ Échec du téléchargement. Vérifiez la version/architecture.${NC}" >&2
        return 1
    fi

    # Vérification du hash
    echo -e "${CYAN}➤ Vérification de l'intégrité (SHA256)...${NC}"
    local actual_hash=$(shasum -a 256 "$temp_file" | awk '{print $1}')
    if [[ "$actual_hash" != "$expected_hash" ]]; then
        echo -e "${RED}✗ Hash SHA256 invalide !${NC}"
        echo -e "  ${YELLOW}Attendu : $expected_hash${NC}"
        echo -e "  ${YELLOW}Reçu    : $actual_hash${NC}"
        return 1
    fi

    # Installation
    echo -e "${CYAN}➤ Installation dans /usr/local/bin...${NC}"
    if ! tar -xzf "$temp_file" -C "$temp_dir"; then
        echo -e "${RED}✗ Échec de l'extraction de l'archive.${NC}" >&2
        return 1
    fi
    
    sudo mv -f "$temp_dir/pwsh" "/usr/local/bin/pwsh" && \
    sudo chmod +x "/usr/local/bin/pwsh"

    # Nettoyage
    rm -rf "$temp_file" "$temp_dir"
    echo -e "\n${GREEN}✓ PowerShell v${version} (${arch}) installé avec succès !${NC}"
    echo -e "${CYAN}➤ Vérification :${NC}"
    pwsh --version
}

# Gestion des arguments
case "$1" in
    "--install")
        shift  # Supprimer --install des arguments
        install_pwsh "$@"
        ;;
    "--uninstall")
        uninstall_pwsh
        ;;
    "--check-updates")
        check_updates
        ;;
    "--help"|*)
        show_help
        exit 0
        ;;
esac
