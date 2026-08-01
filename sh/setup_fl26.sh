#!/bin/bash
# Fix FL 2026 - Wine GE 8.26 explicite
WINE_GE="/home/rajo/.local/share/lutris/runners/wine/wine-ge-8-26-x86_64/bin/wine"
WINESERVER="/home/rajo/.local/share/lutris/runners/wine/wine-ge-8-26-x86_64/bin/wineserver"

# === Préfixe principal FL26 ===
export WINEPREFIX=~/games/fl26
export WINEARCH=win64
export WINE="$WINE_GE"
export PATH="$(dirname $WINE_GE):$PATH"

echo "=== Wine GE détecté : ==="
$WINE_GE --version

echo "=== Vérification DXVK dans fl26 ==="
ls "$WINEPREFIX/drive_c/windows/system32/dxgi.dll" 2>/dev/null \
  && echo "DXVK présent" || echo "DXVK ABSENT - à installer"

echo "=== Installation vcrun + dotnet dans fl26 ==="
WINE="$WINE_GE" WINESERVER="$WINESERVER" WINEPREFIX=~/games/fl26 \
  winetricks -q vcrun2019 vcrun2022 dotnet48

echo "=== Préfixe settings ==="
WINE="$WINE_GE" WINESERVER="$WINESERVER" WINEPREFIX=~/games/settings \
  winetricks -q vcrun2019 dotnet48

echo "=== Fix Settings.exe (icône corrompue = bug Mono) ==="
# Forcer wine-ge à utiliser dotnet natif plutôt que Mono
WINE="$WINE_GE" WINEPREFIX=~/games/settings \
  $WINE_GE reg add "HKCU\\Software\\Wine\\DllOverrides" \
  /v "mscoree" /t REG_SZ /d "native,builtin" /f

echo "=== Vérification GPU/NVIDIA sous Wayland ==="
echo "DXVK_HUD=1 dans Lutris ? Sinon ajouter pour debug"
nvidia-smi | head -10

echo "=== Test lancement direct FL ==="
cd ~/disque_d/FL_2026 2>/dev/null || cd /home/rajo/disque_d/FL_2026
WINE="$WINE_GE" WINEPREFIX=~/games/fl26 \
  $WINE_GE cmd /C FL_2026.bat
