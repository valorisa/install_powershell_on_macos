# 🚀 PowerShell Installer for macOS [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> Script pour installer/désinstaller PowerShell sur macOS avec gestion multi-versions et vérification d'intégrité.

![Demo](https://via.placeholder.com/800x400.png?text=Exemple+d'installation+PowerShell)

## 📦 Fonctionnalités
- ✅ **Installation de versions spécifiques** (7.4.2, 7.5.0, etc.)
- 🔍 **Vérification SHA256** pour sécurité maximale
- 🗑️ **Désinstallation en un clic**
- 🔄 **Vérification des mises à jour** depuis GitHub
- 🍏 Support **Apple Silicon** (`osx-arm64`) et **Intel** (`osx-x64`)

---

## 🛠️ Installation du Script
```bash
# Cloner le dépôt
git clone https://github.com/valorisa/install_powershell_on_macos.git
cd install_powershell_on_macos

# Rendre le script exécutable
chmod +x scripts/install_pwsh_on_macOS.sh
