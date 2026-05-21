-- ============================================================================
-- turno.ads
-- TAD Turno: una cita médica reservada.
--
-- Composición de un Turno:
--   * Fecha    (Año, Mes, Día)
--   * Hora     (codificada como minutos desde 00:00, p. ej. 9:30 → 570)
--   * Dni_Paciente que solicitó el turno.
--
-- ¿Por qué guardar la hora como minutos?
--   * Comparar dos horas es comparar dos enteros.
--   * Imprimir hh:mm es trivial dividiendo por 60.
--   * Evita arrastrar dos campos (hora y minuto) por todo el TAD.
--
-- Igualdad y orden:
--   * Igual: misma fecha + misma hora (un médico no puede tener dos turnos
--     simultáneos).
--   * Menor: por (fecha, hora). Permite que la lista de turnos del médico
--     quede ordenada cronológicamente.
-- ============================================================================

with Ada.Text_IO;

package Turno is

   --------------------------------------------------------------------------
   -- SUBTIPOS de rango: el compilador valida automáticamente que los valores
   -- estén en rango. Constraint_Error se levanta si se intenta asignar
   -- algo fuera de rango.
   --------------------------------------------------------------------------
   subtype Tipoanio is Integer range 2024 .. 2100;
   subtype Tipomes  is Integer range 1 .. 12;
   subtype Tipodia  is Integer range 1 .. 31;
   subtype Tipohora is Integer range 0 .. 24*60 - 1;  -- minutos del día

   --------------------------------------------------------------------------
   -- Tipo opaco.
   --------------------------------------------------------------------------
   type Tipoturno is private;

   --------------------------------------------------------------------------
   -- Excepciones del TAD.
   --------------------------------------------------------------------------
   Fecha_Invalida : exception;

   --------------------------------------------------------------------------
   -- CONSTRUCTOR
   --------------------------------------------------------------------------
   function Crear (Anio          : Tipoanio;
                   Mes           : Tipomes;
                   Dia           : Tipodia;
                   Hora_Minutos  : Tipohora;
                   Dni_Paciente  : Integer) return Tipoturno;

   --------------------------------------------------------------------------
   -- ACCESORES
   --------------------------------------------------------------------------
   function Get_Anio         (T: Tipoturno) return Tipoanio;
   function Get_Mes          (T: Tipoturno) return Tipomes;
   function Get_Dia          (T: Tipoturno) return Tipodia;
   function Get_Hora_Minutos (T: Tipoturno) return Tipohora;
   function Get_Dni_Paciente (T: Tipoturno) return Integer;

   --------------------------------------------------------------------------
   -- CONSULTA
   --------------------------------------------------------------------------
   function Mismo_Dia (T: Tipoturno;
                       Anio: Tipoanio; Mes: Tipomes; Dia: Tipodia)
                      return Boolean;
   --  True si el turno cae en la fecha indicada.

   --------------------------------------------------------------------------
   -- IMPRIMIR
   --------------------------------------------------------------------------
   procedure Imprimir (T: Tipoturno);

   --------------------------------------------------------------------------
   -- COMPARADORES (para Lista_Ordenada de turnos por médico).
   --------------------------------------------------------------------------
   function Menor (X, Y : Tipoturno) return Boolean;
   function Mayor (X, Y : Tipoturno) return Boolean;
   function Igual (X, Y : Tipoturno) return Boolean;
   --  Igual: misma fecha y hora (no importa el paciente, evita doble booking).

   --------------------------------------------------------------------------
   -- Constructor de búsqueda: turno con fecha+hora pero sin paciente
   -- (DNI_Paciente = 0). Útil para Esta/Buscar/Suprimir cuando se quiere
   -- localizar un slot por fecha/hora sin importar quién lo reservó.
   --------------------------------------------------------------------------
   function Por_Fecha_Hora (Anio: Tipoanio;
                            Mes : Tipomes;
                            Dia : Tipodia;
                            Hora_Minutos : Tipohora) return Tipoturno;

   --------------------------------------------------------------------------
   -- Persistencia
   --------------------------------------------------------------------------
   procedure Guardar (Archivo : in out Ada.Text_IO.File_Type;
                      T       : in Tipoturno);
   procedure Cargar  (Archivo : in out Ada.Text_IO.File_Type;
                      T       : out Tipoturno);

private

   type Tipoturno is record
      Anio          : Tipoanio := Tipoanio'First;
      Mes           : Tipomes  := 1;
      Dia           : Tipodia  := 1;
      Hora_Minutos  : Tipohora := 0;
      Dni_Paciente  : Integer  := 0;  -- 0 = "libre" / "clave de búsqueda"
   end record;

end Turno;
