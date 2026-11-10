#!/bin/bash
# ============================================================
# FASE 3 - Escaneo Automatizado de Red (Semana 8)
# Reconocimiento de la infraestructura SecureCorp con Nmap
# ============================================================

echo "============================================"
echo " SecureCorp - Escaneo de Red Automatizado"
echo "============================================"
echo ""

# --- Verificar que nmap este instalado ---
if ! command -v nmap &> /dev/null; then
    echo "[!] nmap no esta instalado. Instalando..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y nmap
    elif command -v apk &> /dev/null; then
        apk add --no-cache nmap
    else
        echo "[ERROR] No se pudo instalar nmap automaticamente."
        exit 1
    fi
fi

echo "[1/4] Escaneo rapido de puertos abiertos..."
echo "-------------------------------------------"
nmap -T4 -F localhost 2>/dev/null || echo "  (ejecutar con permisos adecuados)"
echo ""

echo "[2/4] Deteccion de versiones en servicios web..."
echo "-------------------------------------------------"
nmap -sV -p 8080,8085,8090,3000 localhost 2>/dev/null || echo "  (servicios Docker deben estar corriendo)"
echo ""

echo "[3/4] Verificacion de cabeceras HTTP (sin bastionar vs bastionado)..."
echo "---------------------------------------------------------------------"
echo ">> Puerto 8080 (SIN bastionar):"
curl -sI http://localhost:8080 | head -10
echo ""
echo ">> Puerto 8085 (BASTIONADO):"
curl -sI http://localhost:8085 | head -10
echo ""

echo "[4/4] Comparacion de seguridad..."
echo "----------------------------------"
echo "Cabeceras de seguridad en puerto 8080:"
curl -sI http://localhost:8080 | grep -iE "x-frame|x-content|x-xss|server" || echo "  (ninguna detectada)"
echo ""
echo "Cabeceras de seguridad en puerto 8085:"
curl -sI http://localhost:8085 | grep -iE "x-frame|x-content|x-xss|server"
echo ""

echo "============================================"
echo " Escaneo completado."
echo " Hallazgos clave:"
echo "   - Puerto 8080: servidor expuesto"
echo "   - Puerto 8085: servidor bastionado"
echo "   - Puerto 3000: Juice Shop (vulnerable)"
echo "============================================"
