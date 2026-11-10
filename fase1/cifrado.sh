#!/bin/bash
# ============================================================
# FASE 1 - Laboratorio de Criptografia (Semana 1)
# Cifrado simetrico AES-256 + verificacion de integridad (Hash)
# ============================================================

echo "============================================"
echo " SecureCorp - Laboratorio de Criptografia"
echo "============================================"
echo ""

# --- PASO 1: Crear archivo con datos sensibles ---
echo "[PASO 1] Creando archivo con datos sensibles..."
echo "Usuario: admin_securecorp
Password: S3cur3C0rp!2026
API_KEY: sk-prod-a8f3b2c1d4e5f6789
DB_HOST: 172.21.0.20
DB_PASSWORD: r00t_db_s3cr3t" > datos_sensibles.txt

echo "  Archivo creado: datos_sensibles.txt"
echo "  Contenido en texto plano:"
cat datos_sensibles.txt
echo ""

# --- PASO 2: Generar hash ANTES del cifrado (integridad) ---
echo "[PASO 2] Generando hash MD5 del archivo original..."
HASH_ORIGINAL=$(md5sum datos_sensibles.txt | awk '{print $1}')
echo "  Hash MD5 original: $HASH_ORIGINAL"
echo ""

# --- PASO 3: Cifrar con AES-256-CBC ---
echo "[PASO 3] Cifrando con AES-256-CBC..."
echo "  Clave de cifrado: SecureCorp2026!"
openssl aes-256-cbc -pbkdf2 -salt -in datos_sensibles.txt -out datos_sensibles.enc -pass pass:SecureCorp2026!
echo "  Archivo cifrado: datos_sensibles.enc"
echo ""

# --- PASO 4: Verificar que el cifrado funciono ---
echo "[PASO 4] Contenido del archivo cifrado (ilegible):"
cat datos_sensibles.enc | head -c 200
echo ""
echo "  [El contenido es basura digital - CONFIDENCIALIDAD protegida]"
echo ""

# --- PASO 5: Eliminar archivo original ---
echo "[PASO 5] Eliminando archivo en texto plano..."
rm datos_sensibles.txt
echo "  datos_sensibles.txt eliminado."
echo ""

# --- PASO 6: Descifrar ---
echo "[PASO 6] Descifrando archivo..."
openssl aes-256-cbc -d -pbkdf2 -in datos_sensibles.enc -out datos_recuperados.txt -pass pass:SecureCorp2026!
echo "  Archivo recuperado: datos_recuperados.txt"
echo "  Contenido descifrado:"
cat datos_recuperados.txt
echo ""

# --- PASO 7: Verificar integridad con hash ---
echo "[PASO 7] Verificando integridad (hash post-descifrado)..."
HASH_RECUPERADO=$(md5sum datos_recuperados.txt | awk '{print $1}')
echo "  Hash MD5 original:    $HASH_ORIGINAL"
echo "  Hash MD5 recuperado:  $HASH_RECUPERADO"

if [ "$HASH_ORIGINAL" = "$HASH_RECUPERADO" ]; then
    echo "  INTEGRIDAD VERIFICADA - Los hashes coinciden."
else
    echo "  ALERTA: Los hashes NO coinciden. El archivo fue alterado."
fi
echo ""

# --- PASO 8: Demostrar cambio de hash por alteracion ---
echo "[PASO 8] Demostrando sensibilidad del hash..."
echo "datos alterados" >> datos_recuperados.txt
HASH_ALTERADO=$(md5sum datos_recuperados.txt | awk '{print $1}')
echo "  Hash despues de alterar: $HASH_ALTERADO"
echo "  Hash original:           $HASH_ORIGINAL"
echo "  Los hashes son DIFERENTES - cualquier cambio rompe la integridad."
echo ""

# Limpieza
rm -f datos_sensibles.enc datos_recuperados.txt

echo "============================================"
echo " Laboratorio completado exitosamente."
echo " Temas cubiertos: AES-256, MD5, Cifrado"
echo " simetrico, Integridad de datos."
echo "============================================"
