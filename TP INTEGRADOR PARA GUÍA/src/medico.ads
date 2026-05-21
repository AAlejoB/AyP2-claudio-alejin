-- ============================================================================
-- medico.ads
-- TAD Médico.
--
-- Un Médico tiene:
--   * datos personales (nombre, apellido, DNI, especialidad)
--   * cantidad máxima de turnos que puede atender en un día (modificable)
--   * lista de OBRAS SOCIALES que admite
--   * AGENDA: lista de turnos reservados (ordenada cronológicamente)
--
-- Decisiones de diseño:
--
--   1. La agenda es una INSTANCIACIÓN INTERNA del package genérico
--      Lista_Ordenada con Tipoturno. Esto se hace en la zona "private"
--      del spec; los clientes nunca tocan la lista directamente, solo
--      las operaciones públicas Reservar_Turno / Cancelar_Turno / etc.
--
--   2. Las obras sociales se guardan en un ARREGLO de cadenas con un
--      contador de cuántas hay cargadas. Es más simple que otra lista
--      enlazada y un médico no admite tantas obras sociales como para
--      necesitar una estructura dinámica.
--
--   3. Para los comparadores:
--        Igual → mismo DNI (clave de identidad).
--        Menor / Mayor → orden por apellido y luego nombre (alfabético).
-- ============================================================================

with Ada.Text_IO;
with Lista_Ordenada;
with Turno;

package Medico is

   --------------------------------------------------------------------------
   -- Cadenas de longitud fija (mismo patrón que Paciente).
   --------------------------------------------------------------------------
   Long_Cadena : constant := 50;
   subtype Cadena is String (1 .. Long_Cadena);

   Max_Obras_Sociales : constant := 20;

   --------------------------------------------------------------------------
   -- Tipo opaco.
   --------------------------------------------------------------------------
   type Tipomedico is private;

   --------------------------------------------------------------------------
   -- Excepciones del TAD.
   --------------------------------------------------------------------------
   DNI_Invalido            : exception;
   Cadena_Demasiado_Larga  : exception;
   Sin_Disponibilidad      : exception;
   Turno_Inexistente       : exception;
   Maximo_Obras_Sociales   : exception;

   --------------------------------------------------------------------------
   -- CONSTRUCTOR
   --------------------------------------------------------------------------
   function Crear (Nombre, Apellido, Especialidad : String;
                   Dni            : Integer;
                   Max_Turnos_Dia : Positive := 8) return Tipomedico;

   --------------------------------------------------------------------------
   -- ACCESORES de datos personales.
   --------------------------------------------------------------------------
   function Get_Dni            (M: Tipomedico) return Integer;
   function Get_Nombre         (M: Tipomedico) return String;
   function Get_Apellido       (M: Tipomedico) return String;
   function Get_Especialidad   (M: Tipomedico) return String;
   function Get_Max_Turnos_Dia (M: Tipomedico) return Positive;

   --------------------------------------------------------------------------
   -- MUTADOR de la cantidad máxima de turnos por día.
   -- Pre: Nuevo > 0.
   --------------------------------------------------------------------------
   procedure Modificar_Max_Turnos (M: in out Tipomedico; Nuevo: Positive);

   --------------------------------------------------------------------------
   -- OBRAS SOCIALES
   --------------------------------------------------------------------------
   procedure Agregar_Obra_Social (M: in out Tipomedico; OS: String);
   --  Agrega OS si no estaba. Levanta Maximo_Obras_Sociales si ya hay
   --  Max_Obras_Sociales cargadas.

   function Admite_Obra_Social (M: Tipomedico; OS: String) return Boolean;

   procedure Listar_Obras_Sociales (M: Tipomedico);

   --------------------------------------------------------------------------
   -- AGENDA / TURNOS
   --------------------------------------------------------------------------
   procedure Reservar_Turno (M: in out Tipomedico; T: in Turno.Tipoturno);
   --  Reserva el turno en la agenda. Levanta Sin_Disponibilidad si ya se
   --  alcanzó el máximo del día o si ese horario ya estaba ocupado.

   procedure Cancelar_Turno (M: in out Tipomedico; T: in Turno.Tipoturno);
   --  Saca el turno de la agenda. Levanta Turno_Inexistente si no estaba.

   function Cantidad_Turnos_Dia
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia)
      return Natural;

   function Disponibles_Dia
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia)
      return Natural;
   --  = Max_Turnos_Dia - Cantidad_Turnos_Dia.

   function Hay_Disponibilidad
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia)
      return Boolean;

   procedure Listar_Turnos_Dia
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia);

   procedure Listar_Turnos_Semana
      (M: Tipomedico;
       Anio_Inicio: Turno.Tipoanio;
       Mes_Inicio:  Turno.Tipomes;
       Dia_Inicio:  Turno.Tipodia);
   --  Lista los turnos de los próximos 7 días desde la fecha indicada.

   --------------------------------------------------------------------------
   -- IMPRIMIR datos básicos.
   --------------------------------------------------------------------------
   procedure Imprimir (M: Tipomedico);

   --------------------------------------------------------------------------
   -- COMPARADORES (para Lista_Ordenada de médicos en la Clínica).
   --------------------------------------------------------------------------
   function Menor (X, Y : Tipomedico) return Boolean;
   function Mayor (X, Y : Tipomedico) return Boolean;
   function Igual (X, Y : Tipomedico) return Boolean;

   function Por_Dni (Dni : Integer) return Tipomedico;
   --  Constructor de búsqueda (médico con solo el DNI cargado).

   --------------------------------------------------------------------------
   -- Persistencia.
   --------------------------------------------------------------------------
   procedure Guardar (Archivo : in out Ada.Text_IO.File_Type;
                      M       : in Tipomedico);
   procedure Cargar  (Archivo : in out Ada.Text_IO.File_Type;
                      M       : out Tipomedico);

private

   --------------------------------------------------------------------------
   -- INSTANCIACIÓN INTERNA: agenda de turnos del médico.
   -- Esta instanciación solo es visible para el cuerpo del package y para
   -- la zona privada de los clientes que vean el spec compilado, pero
   -- ningún cliente normal accede al tipo Agenda.Tipolista directamente.
   --------------------------------------------------------------------------
   package Agenda is new Lista_Ordenada
      (Tipoelem => Turno.Tipoturno,
       Menor    => Turno.Menor,
       Mayor    => Turno.Mayor,
       Igual    => Turno.Igual);

   --------------------------------------------------------------------------
   -- Sub-record para una obra social: cadena fija + longitud usada.
   --------------------------------------------------------------------------
   type Obra_Social is record
      Texto : Cadena  := (others => ' ');
      Long  : Natural := 0;
   end record;

   type Vector_OS is array (1 .. Max_Obras_Sociales) of Obra_Social;

   type Tipomedico is record
      Dni             : Integer  := 0;
      Nombre          : Cadena   := (others => ' ');
      Long_Nombre     : Natural  := 0;
      Apellido        : Cadena   := (others => ' ');
      Long_Apellido   : Natural  := 0;
      Especialidad    : Cadena   := (others => ' ');
      Long_Esp        : Natural  := 0;
      Max_Turnos_Dia  : Positive := 8;
      Turnos_Reservados : Agenda.Tipolista;
      Obras_Sociales  : Vector_OS;
      Cantidad_OS     : Natural  := 0;
   end record;

end Medico;
