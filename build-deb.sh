#!/bin/bash
# build-deb.sh — Construye el paquete .deb de GSmartHispano
set -e

VERSION="1.0.0"
PKG="gsmart-hispano"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/packaging/debian/${PKG}"
SRC_DIR="${SCRIPT_DIR}/src"
DATA_DIR="${SCRIPT_DIR}/data"

echo "══════════════════════════════════════════"
echo "  Construyendo ${PKG}_${VERSION}_all.deb"
echo "══════════════════════════════════════════"

# 1. Crear estructura de directorios
echo "→ Creando estructura de directorios..."
mkdir -p "${BUILD_DIR}/DEBIAN"
mkdir -p "${BUILD_DIR}/usr/share/gsmart-hispano"
mkdir -p "${BUILD_DIR}/usr/share/applications"
mkdir -p "${BUILD_DIR}/usr/share/icons/hicolor/scalable/apps"
mkdir -p "${BUILD_DIR}/usr/share/doc/${PKG}"
mkdir -p "${BUILD_DIR}/usr/bin"
mkdir -p "${BUILD_DIR}/etc/sudoers.d"

# 2. Archivos Python
echo "→ Copiando fuentes Python..."
cp "${SRC_DIR}/main.py"             "${BUILD_DIR}/usr/share/gsmart-hispano/"
cp "${SRC_DIR}/disk_manager.py"     "${BUILD_DIR}/usr/share/gsmart-hispano/"
cp "${SRC_DIR}/main_window.py"      "${BUILD_DIR}/usr/share/gsmart-hispano/"
cp "${SRC_DIR}/disk_detail_view.py" "${BUILD_DIR}/usr/share/gsmart-hispano/"

# 3. Ícono
echo "→ Copiando ícono..."
if [ -f "${DATA_DIR}/icons/io.github.gsmart.hispano.svg" ]; then
    cp "${DATA_DIR}/icons/io.github.gsmart.hispano.svg"        "${BUILD_DIR}/usr/share/icons/hicolor/scalable/apps/"
fi

# 4. Desktop entry
echo "→ Copiando entrada de escritorio..."
cp "${DATA_DIR}/io.github.gsmart.hispano.desktop"    "${BUILD_DIR}/usr/share/applications/"

# 5. Lanzador /usr/bin/gsmart-hispano
echo "→ Creando lanzador..."
cat > "${BUILD_DIR}/usr/bin/gsmart-hispano" << 'LAUNCHER'
#!/bin/sh
exec python3 /usr/share/gsmart-hispano/main.py "$@"
LAUNCHER
chmod 755 "${BUILD_DIR}/usr/bin/gsmart-hispano"

# 6. Regla sudoers (sin contraseña para smartctl)
echo "→ Configurando sudoers..."
cat > "${BUILD_DIR}/etc/sudoers.d/gsmart-hispano" << 'SUDOERS'
# GSmartHispano: acceso sin contraseña a smartctl
ALL ALL=(root) NOPASSWD: /usr/sbin/smartctl
SUDOERS
chmod 0440 "${BUILD_DIR}/etc/sudoers.d/gsmart-hispano"

# 7. Copyright y docs
cat > "${BUILD_DIR}/usr/share/doc/${PKG}/copyright" << 'COPYRIGHT'
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: gsmart-hispano
Source: https://github.com/TU_USUARIO/gsmart-hispano
Files: *
Copyright: 2024 GSmartHispano Contributors
License: GPL-3.0+
COPYRIGHT

[ -f "${SCRIPT_DIR}/README.md" ] &&     cp "${SCRIPT_DIR}/README.md" "${BUILD_DIR}/usr/share/doc/${PKG}/"

# 8. DEBIAN/control
INSTALLED_SIZE=$(du -sk "${BUILD_DIR}" | cut -f1)
cat > "${BUILD_DIR}/DEBIAN/control" << CONTROL
Package: ${PKG}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Installed-Size: ${INSTALLED_SIZE}
Depends: python3 (>= 3.11), python3-gi, python3-gi-cairo, gir1.2-gtk-4.0, gir1.2-adw-1, libadwaita-1-0, smartmontools
Recommends: sudo
Maintainer: GSmartHispano <gsmart-hispano@github.com>
Homepage: https://github.com/TU_USUARIO/gsmart-hispano
Description: Monitor de salud de discos S.M.A.R.T. en español
 Interfaz gráfica moderna GTK4 + Libadwaita para smartmontools.
 Soporta discos ATA, SATA SSD y NVMe. Modo oscuro y claro incluido.
CONTROL

# 9. postinst
cat > "${BUILD_DIR}/DEBIAN/postinst" << 'POSTINST'
#!/bin/sh
set -e
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true
fi
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications 2>/dev/null || true
fi
echo "GSmartHispano instalado. Ejecuta: gsmart-hispano"
exit 0
POSTINST
chmod 755 "${BUILD_DIR}/DEBIAN/postinst"

# 10. postrm
cat > "${BUILD_DIR}/DEBIAN/postrm" << 'POSTRM'
#!/bin/sh
set -e
case "$1" in
    purge|remove)
        if command -v gtk-update-icon-cache >/dev/null 2>&1; then
            gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true
        fi
        ;;
esac
exit 0
POSTRM
chmod 755 "${BUILD_DIR}/DEBIAN/postrm"

# 11. Construir .deb
echo "→ Construyendo paquete .deb..."
dpkg-deb --build --root-owner-group "${BUILD_DIR}"     "${SCRIPT_DIR}/${PKG}_${VERSION}_all.deb"

echo ""
echo "✅ Listo: ${PKG}_${VERSION}_all.deb"
echo ""
echo "Para instalar:"
echo "  sudo dpkg -i ${PKG}_${VERSION}_all.deb"
echo "  sudo apt-get install -f   # si faltan dependencias"
echo ""
echo "Para ejecutar después:"
echo "  gsmart-hispano"
