"""
============================================================
FASE 2 - Motor de Control de Acceso (NAC) - Semana 6
Simulacion de Cortafuegos con Zonas de Red y Politica
de Minimo Privilegio (Default Deny)
============================================================
"""


class Regla:
    """Representa una regla de control de acceso (simbolo)."""
    def __init__(self, puerto, protocolo, accion="DENY"):
        self.puerto = str(puerto)
        self.protocolo = protocolo.upper()
        self.accion = accion.upper()


class Zona:
    """Representa un ambito de red o zona de seguridad (scope)."""
    def __init__(self, nombre, zona_padre=None):
        self.nombre = nombre
        self.reglas = {}
        self.zona_padre = zona_padre


class MotorControlAcceso:
    """Gestor principal de la Tabla de Reglas (firewall simulado)."""

    def __init__(self):
        self.zona_actual = Zona("GLOBAL")
        print(f"[*] Firewall inicializado en zona: {self.zona_actual.nombre}")
        print(f"[*] Politica por defecto: DENY ALL (Minimo Privilegio)")
        print("=" * 60)

    def entrar_zona(self, nombre):
        """Crea y entra a una zona hija (scope anidado)."""
        nueva_zona = Zona(nombre, zona_padre=self.zona_actual)
        self.zona_actual = nueva_zona
        print(f"\n---> Entrando a zona de seguridad: '{nombre}'")

    def salir_zona(self):
        """Regresa a la zona padre (destruye el scope actual)."""
        if self.zona_actual.zona_padre:
            nombre_anterior = self.zona_actual.nombre
            self.zona_actual = self.zona_actual.zona_padre
            print(f"\n<--- Saliendo de zona: '{nombre_anterior}' -> '{self.zona_actual.nombre}'")
        else:
            print("[!] Ya estas en la zona raiz (GLOBAL).")

    def definir(self, puerto, protocolo, accion="ALLOW"):
        """Registra una regla en la zona actual."""
        regla = Regla(puerto, protocolo, accion)
        clave = f"{puerto}/{protocolo.upper()}"
        self.zona_actual.reglas[clave] = regla
        print(f"[REGLA] {accion} {clave} guardada en zona '{self.zona_actual.nombre}'")

    def buscar(self, puerto, protocolo):
        """Busqueda escalada de reglas (herencia de scopes)."""
        clave = f"{str(puerto)}/{protocolo.upper()}"
        zona = self.zona_actual
        while zona:
            if clave in zona.reglas:
                return zona.reglas[clave]
            zona = zona.zona_padre
        return None

    def verificar_acceso(self, puerto, protocolo):
        """Verifica si se permite el acceso al par puerto/protocolo."""
        regla = self.buscar(puerto, protocolo)
        if regla and regla.accion == "ALLOW":
            print(f"  [PERMITIDO] Trafico {puerto}/{protocolo} en '{self.zona_actual.nombre}'")
        else:
            print(f"  [BLOQUEADO] Trafico {puerto}/{protocolo} -> POLITICA POR DEFECTO (DENY)")


if __name__ == "__main__":
    print()
    print("=" * 60)
    print(" SecureCorp - Motor de Control de Acceso (NAC)")
    print(" Simulacion de Cortafuegos con Zonas de Red")
    print("=" * 60)
    print()

    acm = MotorControlAcceso()

    # --- ZONA GLOBAL (Internet / Red Publica) ---
    print("\n--- Configurando ZONA GLOBAL (Red Publica) ---")
    acm.definir("80", "TCP", accion="ALLOW")
    acm.definir("443", "TCP", accion="ALLOW")
    acm.verificar_acceso("80", "TCP")
    acm.verificar_acceso("443", "TCP")
    acm.verificar_acceso("22", "TCP")

    # --- ZONA DMZ (Servicios Internos) ---
    print("\n--- Configurando ZONA DMZ ---")
    acm.entrar_zona("DMZ_SERVICIOS")
    acm.verificar_acceso("80", "TCP")
    acm.definir("3306", "TCP", accion="ALLOW")
    acm.definir("3000", "TCP", accion="ALLOW")
    acm.verificar_acceso("3306", "TCP")
    acm.verificar_acceso("3000", "TCP")

    # --- ZONA ADMIN (Acceso Restringido) ---
    print("\n--- Configurando ZONA ADMIN ---")
    acm.entrar_zona("ADMIN_SSH")
    acm.definir("22", "TCP", accion="ALLOW")
    acm.verificar_acceso("22", "TCP")
    acm.verificar_acceso("80", "TCP")
    acm.verificar_acceso("3306", "TCP")

    # --- PRUEBA DE AISLAMIENTO ---
    print("\n--- PRUEBA DE AISLAMIENTO DE ZONAS ---")
    acm.salir_zona()
    acm.salir_zona()

    print("\n[PRUEBA CRITICA] Intentando acceder a servicios internos desde GLOBAL:")
    acm.verificar_acceso("3306", "TCP")
    acm.verificar_acceso("22", "TCP")
    acm.verificar_acceso("3000", "TCP")
    acm.verificar_acceso("80", "TCP")

    print()
    print("=" * 60)
    print(" RESULTADO: Las reglas internas (3306, 22, 3000) fueron")
    print(" BLOQUEADAS al salir de sus zonas. Solo el puerto 80")
    print(" (GLOBAL) permanece accesible. Aislamiento exitoso.")
    print("=" * 60)
