#!/bin/bash
# Attendre que le jeu sauvegarde avant de tuer sider
sleep 5
killall sider.exe 2>/dev/null
sleep 2
killall wineserver 2>/dev/null
