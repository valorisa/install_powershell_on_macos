# 🚀 Installation de PowerShell sur macOS

Un script pour installer/désinstaller PowerShell sur macOS avec vérification d'intégrité (SHA256).

## 📋 Fonctionnalités
- Installation de versions spécifiques de PowerShell
- Vérification du hash SHA256 pour sécurité
- Désinstallation en une commande
- Support Apple Silicon (`osx-arm64`) et Intel (`osx-x64`)

## 🛠️ Utilisation
```bash
# Cloner le dépôt (sur macOS)
git clone https://github.com/valorisa/install_powershell_on_macos.git
cd install_powershell_on_macos

# Rendre le script exécutable
chmod +x scripts/install_pwsh_on_macOS.sh

# Installer la version par défaut (Apple Silicon)
sudo ./scripts/install_pwsh_on_macOS.sh --install

# Désinstaller
sudo ./scripts/install_pwsh_on_macOS.sh --uninstall
