#!/bin/bash
# ============================================================
# FASE 3 - Simulacion de Ataque DoS (Semana 9)
# Comparacion: servidor sin proteccion vs con Rate Limiting
# ============================================================

echo "============================================"
echo " SecureCorp - Simulacion de Ataque DoS"
echo " (HTTP Flood con Apache Benchmark)"
echo "============================================"
echo ""

TOTAL_REQUESTS=10000
CONCURRENCIA=200

echo "[!] ADVERTENCIA: Esta simulacion es EDUCATIVA."
echo "    Solo ejecutar contra infraestructura propia."
echo ""

# --- Test 1: Servidor SIN proteccion ---
echo "============================================"
echo " TEST 1: Servidor SIN proteccion (puerto 8080)"
echo "============================================"
echo "Parametros: $TOTAL_REQUESTS requests, $CONCURRENCIA concurrentes"
echo ""

if command -v ab &> /dev/null; then
    ab -n $TOTAL_REQUESTS -c $CONCURRENCIA -q http://localhost:8080/ 2>/dev/null | grep -E "Requests per second|Failed requests|Non-2xx|Time taken"
elif docker ps | grep -q securecorp-atacante; then
    docker exec securecorp-atacante ab -n $TOTAL_REQUESTS -c $CONCURRENCIA -q http://172.28.0.10:80/ 2>/dev/null | grep -E "Requests per second|Failed requests|Non-2xx|Time taken"
else
    echo "[!] Apache Benchmark no disponible. Instalar con: apt install apache2-utils"
    echo "    O ejecutar: docker compose up -d (para usar el contenedor atacante)"
fi

echo ""

# --- Test 2: Servidor CON Rate Limiting ---
echo "============================================"
echo " TEST 2: Servidor CON Rate Limiting (puerto 8090)"
echo "============================================"
echo "Parametros: $TOTAL_REQUESTS requests, $CONCURRENCIA concurrentes"
echo ""

if command -v ab &> /dev/null; then
    ab -n $TOTAL_REQUESTS -c $CONCURRENCIA -q http://localhost:8090/ 2>/dev/null | grep -E "Requests per second|Failed requests|Non-2xx|Time taken"
elif docker ps | grep -q securecorp-atacante; then
    docker exec securecorp-atacante ab -n $TOTAL_REQUESTS -c $CONCURRENCIA -q http://172.28.0.30:80/ 2>/dev/null | grep -E "Requests per second|Failed requests|Non-2xx|Time taken"
else
    echo "[!] Apache Benchmark no disponible."
fi

echo ""
echo "============================================"
echo " ANALISIS ESPERADO:"
echo "   Test 1 (sin proteccion): todas las"
echo "   peticiones son exitosas (~0 failed)"
echo ""
echo "   Test 2 (con Rate Limiting): la mayoria"
echo "   de peticiones son rechazadas (HTTP 503)"
echo "   demostrando la mitigacion del ataque DoS."
echo "============================================"
