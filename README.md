# SecureCorp - Proyecto Final de Seguridad Informatica

**Materia:** Sistemas de Comunicacion y Seguridad Informatica  
**Semestre:** 8vo - Universidad Cooperativa de Colombia  
**Docente:** Mg. Gabriel Guerrero Arellano

---

## Descripcion

SecureCorp simula la infraestructura de una empresa que debe ser auditada y protegida.
El proyecto cubre las 4 fases del ciclo de seguridad ofensiva/defensiva utilizando
Docker, Nginx, Python y GitHub Actions.

## Arquitectura

```
┌─────────────────────────────────────────────┐
│              RED PUBLICA (DMZ)              │
│              172.20.0.0/24                  │
│                                             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │ Web Base │ │Bastionado│ │ Defensa  │   │
│  │ :8080    │ │ :8085    │ │ :8090    │   │
│  │ .0.10    │ │ .0.20    │ │ .0.30    │   │
│  └──────────┘ └──────────┘ └──────────┘   │
│                                             │
│  ┌──────────┐                              │
│  │ Atacante │  (Apache Benchmark)          │
│  │ .0.100   │                              │
│  └──────────┘                              │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│             RED INTERNA (LAN)              │
│             172.21.0.0/24                  │
│                                             │
│  ┌──────────────┐                          │
│  │  Juice Shop  │  (App Vulnerable)        │
│  │  :3000       │                          │
│  │  .0.20       │                          │
│  └──────────────┘                          │
└─────────────────────────────────────────────┘
```

## Fases del Proyecto

### Fase 1: Infraestructura Base
- Docker Compose con redes segmentadas (publica/interna)
- Servidor Nginx sin bastionar (estado inicial)
- Laboratorio de criptografia con OpenSSL (AES-256-CBC)
- Verificacion de integridad con hashes MD5

### Fase 2: Bastionado y Automatizacion
- Nginx bastionado con cabeceras de seguridad (OWASP)
- Motor de Control de Acceso (NAC) en Python con zonas
- Pipeline CI/CD con GitHub Actions + Trivy
- Imagen Docker vulnerable para demo de escaneo

### Fase 3: Auditoria Ofensiva
- Reconocimiento de red con Nmap (scripts NSE)
- SQL Injection en OWASP Juice Shop
- Simulacion de ataque DoS con Apache Benchmark
- Captura de trafico (tcpdump/Wireshark)

### Fase 4: Defensa Activa
- Rate Limiting con `limit_req_zone` de Nginx
- Content Security Policy (CSP)
- Comparacion antes/despues del ataque DoS
- Pagina personalizada de error 503

## Inicio Rapido

### Requisitos
- Docker y Docker Compose
- Nmap (opcional, para fase 3)
- Wireshark (opcional, para analisis de trafico)

### Levantar la infraestructura
```bash
docker compose up -d
```

### Verificar servicios
| Servicio         | URL                    | Descripcion                  |
|-----------------|------------------------|------------------------------|
| Web Base        | http://localhost:8080   | Servidor sin bastionar       |
| Web Bastionado  | http://localhost:8085   | Servidor con cabeceras OWASP |
| Web Defensa     | http://localhost:8090   | Servidor con Rate Limiting   |
| Juice Shop      | http://localhost:3000   | App vulnerable (pentesting)  |

### Ejecutar laboratorios
```bash
# Fase 1: Criptografia
bash fase1/cifrado.sh

# Fase 2: Motor NAC
python3 fase2/motor_control.py

# Fase 3: Escaneo de red
bash fase3/escaneo_red.sh

# Fase 3: Simulacion DoS
bash fase3/ataque_dos.sh
```

### Detener servicios
```bash
docker compose down
```

## Temas Cubiertos

| Semana | Tema                                    | Fase |
|--------|-----------------------------------------|------|
| 1      | Criptografia (AES-256, Hashes, OpenSSL) | 1    |
| 2      | Analisis de trafico (Wireshark, OSI)    | 3    |
| 3-4    | Seguridad LAN/WiFi (WPA2, VLANs)       | 1    |
| 5      | Hardening de servidores (Docker, OWASP) | 2    |
| 6      | IAM, NAC, Firewalls (Zonas, RBAC)      | 2    |
| 7      | DevSecOps (CI/CD, GitHub Actions, Trivy)| 2    |
| 8      | Pentesting (Nmap, NSE, SQL Injection)   | 3    |
| 9      | DoS/DDoS (HTTP Flood, MITM)            | 3    |
| 10     | Defensa activa (Rate Limiting, CSP)     | 4    |

## Estructura del Repositorio

```
securecorp/
├── docker-compose.yml          # Orquestacion de servicios
├── fase1/
│   ├── nginx.conf              # Config Nginx base
│   ├── html/index.html         # Portal (sin bastionar)
│   └── cifrado.sh              # Lab de criptografia
├── fase2/
│   ├── nginx-bastionado.conf   # Config con cabeceras OWASP
│   ├── html/index.html         # Portal (bastionado)
│   ├── motor_control.py        # Motor NAC en Python
│   └── Dockerfile.vulnerable   # Imagen para demo Trivy
├── fase3/
│   ├── README-pentesting.md    # Guia de pentesting
│   ├── escaneo_red.sh          # Script de reconocimiento
│   └── ataque_dos.sh           # Simulacion DoS
├── fase4/
│   ├── nginx-defensa.conf      # Config con Rate Limiting
│   └── html/
│       ├── index.html          # Portal (protegido)
│       └── 503.html            # Pagina de limite excedido
├── .github/workflows/
│   └── seguridad.yml           # Pipeline DevSecOps
└── informe/
    └── plantilla-informe.md    # Plantilla del informe final
```
