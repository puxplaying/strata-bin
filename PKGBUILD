# Maintainer: pux
#
# Dynamic version (autogit UPDCHECK=2): pkgver is resolved at source time from
# latest.json - the feed file Strata's own updater reads - so a new upstream
# release shows up in `makepkg --printsrcinfo` without a manual bump.
# The asset name Strata-<ver>-linux-x86_64.AppImage is the naming that same
# JSON advertises. If the endpoint fails, pkgver stays empty and makepkg errors
# loudly ("pkgver is not allowed to be empty").

pkgname=strata-bin
pkgver=$(curl -fsSL --max-time 60 'https://github.com/Niko1221/Strata/releases/latest/download/latest.json' | sed -n 's/.*"version"[^"]*"\([0-9][0-9.]*\)".*/\1/p')
pkgrel=1
pkgdesc="Strata - local AI app: runs and serves large language models on consumer hardware"
arch=('x86_64')
url="https://github.com/Niko1221/Strata"
license=('MIT')
# The AppImage bundles its whole GUI stack (GTK3, WebKitGTK, libfuse); the host
# only has to provide the setuid fusermount helper plus the libs ldd resolves
# from /usr/lib: GL vendor dispatch, Wayland/X11 clients, the font stack, zlib.
depends=('fuse3' 'zlib' 'hicolor-icon-theme' 'glibc' 'libgcc' 'libstdc++'
         'libglvnd' 'libdrm' 'wayland' 'libx11' 'libxcb' 'fontconfig'
         'freetype2' 'harfbuzz' 'fribidi' 'expat')
options=('!strip')
install=strata.install
source=("Strata.AppImage::https://github.com/Niko1221/Strata/releases/download/v${pkgver}/Strata-${pkgver}-linux-x86_64.AppImage"
        'strata.png'
        'strata.desktop'
        'strata-desktop.sh')
sha256sums=('SKIP'
            '3b26050bea645356aa3fad98cc4f42dc35ac09ffbc57b9485639fc031b6b97b1'
            '50c0d042e21247fd6dc3d5b5b20bf26d3f7ed34e65ea8ae026e27bc4e2766b5d'
            '2a6dbde7bfcbbac2916b8cbca3dc4661c1aee8349ec31accbf4299953f7b66ce')
noextract=('Strata.AppImage')

package() {
  # Install AppImage
  install -dm755 "$pkgdir/opt/strata"
  install -Dm755 "$srcdir/Strata.AppImage" "$pkgdir/opt/strata/strata.AppImage"

  # Icon: the desktop file asks for Icon=strata-desktop (upstream's own name)
  install -Dm644 "$srcdir/strata.png" "$pkgdir/usr/share/icons/hicolor/512x512/apps/strata-desktop.png"
  install -Dm644 "$srcdir/strata.png" "$pkgdir/usr/share/pixmaps/strata-desktop.png"

  # Desktop entry: file ID = the app ID upstream declares (tauri.conf.json:
  # ai.strata.desktop), StartupWMClass = strata-desktop, so the GNOME dock
  # merges the window into the pinned entry on Wayland and on XWayland
  install -Dm644 "$srcdir/strata.desktop" "$pkgdir/usr/share/applications/ai.strata.desktop.desktop"

  # Launcher: upstream's Exec= is strata-desktop. A wrapper instead of a plain
  # symlink, because upstream forces WEBKIT_DISABLE_DMABUF_RENDERER=1 (window on
  # the CPU) and only respects a value that is already set - the script exports 0
  # when an AMD card drives a connected display, and leaves your own value alone.
  # Drop the wrapper when upstream fixes https://github.com/Niko1221/Strata/issues/5417
  install -Dm755 "$srcdir/strata-desktop.sh" "$pkgdir/usr/bin/strata-desktop"
}
