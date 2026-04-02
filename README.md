# GSmartHispano 💿

> Monitor de salud de discos S.M.A.R.T. moderno — GTK4 + Libadwaita — Español

[![Build & Release](https://github.com/gsmart-hispano/gsmart-hispano/actions/workflows/build-release.yml/badge.svg)](https://github.com/gsmart-hispano/gsmart-hispano/actions)
![GTK4](https://img.shields.io/badge/GTK-4.x-blue?logo=gnome)
![Python](https://img.shields.io/badge/Python-3.11+-yellow?logo=python)
![License](https://img.shields.io/badge/Licencia-GPL--3.0-green)

---

## ✨ Características

| Función | Descripción |
|---------|-------------|
| 🌙 Modo oscuro/claro | Integrado con Libadwaita, también manual |
| 🇪🇸 Español completo | Atributos S.M.A.R.T. con nombres descriptivos |
| 💾 Multi-disco | ATA, SCSI y NVMe |
| 🌡️ Temperatura | Monitor en tiempo real |
| 🧪 Self-Tests | Corto, largo y envío |
| 📋 Historial | Errores y pruebas anteriores |
| 📦 Portable | AppImage + .deb |

---

## 📥 Instalación

### Paquete .deb (Ubuntu, Debian, Linux Mint)
```bash
sudo dpkg -i gsmart-hispano_1.0.0_amd64.deb
sudo apt-get install -f
```

### AppImage (cualquier distro x86_64)
```bash
chmod +x GSmartHispano-1.0.0-x86_64.AppImage
./GSmartHispano-1.0.0-x86_64.AppImage
```

---

## 🛠️ Desde el código fuente

```bash
# 1. Clonar el repositorio
git clone https://github.com/TU_USUARIO/gsmart-hispano.git
cd gsmart-hispano

# 2. Instalar dependencias y ejecutar
chmod +x setup.sh
./setup.sh
```

### Dependencias manuales
```bash
# Ubuntu / Debian
sudo apt install python3 python3-gi python3-gi-cairo \
    gir1.2-gtk-4.0 gir1.2-adw-1 smartmontools

# Fedora
sudo dnf install python3 python3-gobject gtk4 libadwaita smartmontools

# Arch Linux
sudo pacman -S python python-gobject gtk4 libadwaita smartmontools
```

> **Nota:** Para leer datos S.M.A.R.T. necesitas `sudo` o pertenecer al grupo `disk`:
> ```bash
> sudo usermod -aG disk $USER
> # (requiere reinicio de sesión)
> ```

---

## 🏗️ Construir los paquetes

### .deb local
```bash
sudo apt install debhelper devscripts
cp -r packaging/debian debian/
dpkg-buildpackage -us -uc -b
```

### AppImage local
```bash
pip install appimage-builder
cp packaging/appimage/AppImageBuilder.yml .
appimage-builder --recipe AppImageBuilder.yml
```

### Automático (GitHub Actions)
Crea un tag `v1.0.0` y el workflow construye y publica ambos paquetes automáticamente:
```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## 📁 Estructura del proyecto

```
gsmart-hispano/
├── src/
│   ├── main.py              # Punto de entrada
│   ├── disk_manager.py      # Interfaz con smartctl
│   ├── main_window.py       # Ventana principal + sidebar
│   └── disk_detail_view.py  # Vista de detalles con pestañas
├── data/
│   ├── icons/               # Iconos de la aplicación
│   └── *.desktop            # Entrada de escritorio
├── packaging/
│   ├── debian/              # Archivos de empaquetado Debian
│   └── appimage/            # Recipe de AppImage
├── .github/workflows/
│   └── build-release.yml    # CI/CD automático
├── setup.sh                 # Script de instalación local
└── README.md
```

---

## 🖼️ Capturas de pantalla

> *(Agrega aquí capturas una vez ejecutes la app)*

---

## 🤝 Contribuir

1. Fork del repositorio
2. Crea una rama: `git checkout -b feature/mi-mejora`
3. Commit: `git commit -m 'Añadir mi mejora'`
4. Push: `git push origin feature/mi-mejora`
5. Abre un Pull Request

---

## 📄 Licencia

GPL-3.0 — Ver [LICENSE](LICENSE)

---

*Inspirado en [GSmartControl](https://gsmartcontrol.shaduri.dev/) — modernizado para el ecosistema GNOME actual.*
