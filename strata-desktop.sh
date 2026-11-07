#!/bin/sh
# Strata forces WEBKIT_DISABLE_DMABUF_RENDERER=1 into its whole process tree on
# every Linux desktop (apps/desktop/src-tauri/src/main.rs, and only when the
# variable is unset), which makes WebKitGTK paint the window on the CPU: typing,
# scrolling and clicking in slow motion on a Radeon. Upstream keeps it because the
# DMA-BUF renderer shows a blank window on NVIDIA + Wayland (bug report
# Niko1221/Strata#5417). Workaround until that is fixed: export 0 when an AMD
# card drives a connected display. A value you set yourself always wins.
# Delete this wrapper once upstream drops the forced set_var.

APPIMAGE=/opt/strata/strata.AppImage

if [ -z "${WEBKIT_DISABLE_DMABUF_RENDERER+set}" ]; then
  for status in /sys/class/drm/card*-*/status; do
    [ -f "$status" ] || continue
    [ "$(cat "$status" 2>/dev/null)" = connected ] || continue
    card=${status#/sys/class/drm/}
    card=${card%%-*}
    [ "$(cat "/sys/class/drm/$card/device/vendor" 2>/dev/null)" = 0x1002 ] || continue
    WEBKIT_DISABLE_DMABUF_RENDERER=0
    export WEBKIT_DISABLE_DMABUF_RENDERER
    break
  done
fi

exec "$APPIMAGE" "$@"
