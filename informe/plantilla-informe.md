# Informe de Auditoria de Seguridad - SecureCorp

**Fecha:** _______________  
**Auditor:** _______________  
**Materia:** Sistemas de Comunicacion y Seguridad Informatica  
**Docente:** Mg. Gabriel Guerrero Arellano

---

## 1. Resumen Ejecutivo

Breve descripcion del objetivo de la auditoria, alcance y hallazgos principales.

---

## 2. Fase 1 - Infraestructura Base

### 2.1 Arquitectura Desplegada
- Descripcion de las redes Docker (publica: 172.28.0.0/24, interna: 172.29.0.0/24)
- Servicios desplegados y sus roles
- Captura: `docker compose ps`

### 2.2 Laboratorio de Criptografia
- Resultado de la ejecucion de `cifrado.sh`
- Hashes antes y despues del cifrado
- Captura de pantalla del proceso

---

## 3. Fase 2 - Bastionado y Automatizacion

### 3.1 Hardening del Servidor Web
- Cabeceras de seguridad implementadas
- Comparacion de respuestas HTTP (antes/despues)
- Captura: `curl -I localhost:8080` vs `curl -I localhost:8086`

### 3.2 Motor de Control de Acceso (NAC)
- Resultado de la ejecucion de `motor_control.py`
- Analisis del aislamiento de zonas
- Politica de minimo privilegio (Default Deny)

### 3.3 Pipeline DevSecOps
- Resultado del escaneo Trivy en GitHub Actions
- CVEs detectadas en la imagen vulnerable
- Captura del pipeline en GitHub

---

## 4. Fase 3 - Auditoria Ofensiva

### 4.1 Reconocimiento con Nmap
- Puertos abiertos detectados
- Versiones de servicios
- Resultado de scripts NSE

### 4.2 SQL Injection
- Payload utilizado: `' OR 1=1 --`
- Resultado en Juice Shop
- Clasificacion OWASP: A03:2021 - Injection

### 4.3 Simulacion DoS
- Metricas del ataque al servidor sin proteccion
- Metricas del ataque al servidor con Rate Limiting
- Tabla comparativa de resultados

---

## 5. Fase 4 - Defensa Activa

### 5.1 Rate Limiting
- Configuracion implementada (`limit_req_zone`)
- Comportamiento bajo ataque (HTTP 503)
- Pagina de error personalizada

### 5.2 Content Security Policy
- Directivas CSP implementadas
- Proteccion contra XSS e inyeccion de contenido

---

## 6. Hallazgos y Recomendaciones

| # | Hallazgo | Severidad | Recomendacion | Estado |
|---|----------|-----------|---------------|--------|
| 1 | Servidor sin cabeceras | Alta | Implementar bastionado | Resuelto (Fase 2) |
| 2 | SQL Injection en Juice Shop | Critica | Parametrizar consultas | Documentado |
| 3 | Sin Rate Limiting | Alta | Implementar limit_req | Resuelto (Fase 4) |
| 4 | Imagen Docker vulnerable | Alta | Actualizar base image | Detectado por CI/CD |

---

## 7. Conclusiones

- Resumen de los controles implementados
- Efectividad de las defensas
- Lecciones aprendidas

---

## 8. Anexos

- Capturas de pantalla
- Logs de Nmap
- Resultados de Apache Benchmark
- Output del pipeline CI/CD
