-- ============================================================================
-- paciente.ads
-- TAD Paciente.
--
-- Un Paciente tiene: nombre, apellido, DNI y obra social.
--
-- Decisiones de diseño:
--   * Tipo PRIVATE: el detalle de los campos se oculta. Quien quiera leer
--     un campo usa los "getters" (Get_Dni, Get_Nombre, ...).
--   * Igualdad por DNI: dos pacientes son el "mismo paciente" si comparten
--     DNI. Esto es importante porque cuando guardemos pacientes en una
--     Lista_Ordenada, será la función Igual la que prevenga duplicados.
--   * Orden por apellido y luego nombre (alfabético): para listados.
--   * Las cadenas se almacenan en strings de longitud fija con un campo
--     "longitud usada" — patrón estándar en Ada cuando no se quiere usar
--     Unbounded_Strings (que requiere with Ada.Strings.Unbounded).
-- ============================================================================

with Ada.Text_IO;

package Paciente is

   --------------------------------------------------------------------------
   -- Tamaños de campos.
   -- subtype define un alias con restricciones; "string(1..N)" es un string
   -- de longitud fija.
   --------------------------------------------------------------------------
   Long_Cadena : constant := 50;
   subtype Cadena is String (1 .. Long_Cadena);

   --------------------------------------------------------------------------
   -- Tipo opaco (privado): el cliente no ve la estructura interna.
   --------------------------------------------------------------------------
   type Tipopaciente is private;

   --------------------------------------------------------------------------
   -- Excepciones del TAD.
   --------------------------------------------------------------------------
   DNI_Invalido       : exception;  -- DNI <= 0 o fuera de rango razonable.
   Cadena_Demasiado_Larga : exception;

   --------------------------------------------------------------------------
   -- CONSTRUCTOR
   --------------------------------------------------------------------------
   function Crear (Nombre, Apellido : String;
                   Dni              : Integer;
                   Obra_Social      : String) return Tipopaciente;
   --  Crea un paciente con los datos indicados.
   --  Pre: 1 <= Dni <= 99_999_999, todas las cadenas <= 50 chars.
   --  Excepciones: DNI_Invalido, Cadena_Demasiado_Larga.

   --------------------------------------------------------------------------
   -- ACCESORES (getters) — devuelven copias.
   --------------------------------------------------------------------------
   function Get_Dni         (P: Tipopaciente) return Integer;
   function Get_Nombre      (P: Tipopaciente) return String;
   function Get_Apellido    (P: Tipopaciente) return String;
   function Get_Obra_Social (P: Tipopaciente) return String;

   --------------------------------------------------------------------------
   -- MUTADOR para obra social (el resto se considera "datos identitarios"
   -- que requieren baja+alta para cambiar).
   --------------------------------------------------------------------------
   procedure Set_Obra_Social (P: in out Tipopaciente; Nueva : String);

   --------------------------------------------------------------------------
   -- IMPRIMIR
   --------------------------------------------------------------------------
   procedure Imprimir (P: Tipopaciente);

   --------------------------------------------------------------------------
   -- COMPARADORES (para usar en Lista_Ordenada).
   -- Igual compara por DNI (clave primaria).
   -- Menor/Mayor ordenan por apellido y luego por nombre.
   --------------------------------------------------------------------------
   function Menor (X, Y : Tipopaciente) return Boolean;
   function Mayor (X, Y : Tipopaciente) return Boolean;
   function Igual (X, Y : Tipopaciente) return Boolean;

   --------------------------------------------------------------------------
   -- "Constructor de búsqueda": construye un Paciente con solo el DNI
   -- cargado, para usar como clave en Esta/Buscar/Suprimir.
   --------------------------------------------------------------------------
   function Por_Dni (Dni : Integer) return Tipopaciente;

   --------------------------------------------------------------------------
   -- I/O por archivo (útiles para persistencia desde Clínica).
   -- Trabajan con un Ada.Text_IO.File_Type ya abierto.
   --------------------------------------------------------------------------
   procedure Guardar (Archivo : in out Ada.Text_IO.File_Type;
                      P       : in Tipopaciente);
   procedure Cargar  (Archivo : in out Ada.Text_IO.File_Type;
                      P       : out Tipopaciente);

private

   type Tipopaciente is record
      Dni            : Integer  := 0;
      Nombre         : Cadena   := (others => ' ');
      Long_Nombre    : Natural  := 0;
      Apellido       : Cadena   := (others => ' ');
      Long_Apellido  : Natural  := 0;
      Obra_Social    : Cadena   := (others => ' ');
      Long_OS        : Natural  := 0;
   end record;

end Paciente;
