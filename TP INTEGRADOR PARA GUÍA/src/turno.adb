-- ============================================================================
-- turno.adb
-- Implementación del TAD Turno.
--
-- PASO A PASO:
--   * "Codigo_Cronologico" devuelve un entero monotónico AAAA*10000+MM*100+DD,
--     que junto con Hora_Minutos sirve para comparar fechas y horas con
--     simples "<" y "=" sin escribir comparaciones campo por campo.
--   * Validamos que el día sea coherente con el mes (rangos 28/29/30/31).
-- ============================================================================

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

package body Turno is

   ---------------------------------------------------------------------------
   -- Función auxiliar: ¿es bisiesto el año A?
   ---------------------------------------------------------------------------
   function Bisiesto (A : Tipoanio) return Boolean is
   begin
      return (A mod 4 = 0 and A mod 100 /= 0) or (A mod 400 = 0);
   end Bisiesto;

   ---------------------------------------------------------------------------
   -- Función auxiliar: cantidad de días que tiene un (mes, año).
   ---------------------------------------------------------------------------
   function Dias_Del_Mes (M : Tipomes; A : Tipoanio) return Tipodia is
   begin
      case M is
         when 1 | 3 | 5 | 7 | 8 | 10 | 12 => return 31;
         when 4 | 6 | 9 | 11              => return 30;
         when 2 =>
            if Bisiesto (A) then return 29; else return 28; end if;
      end case;
   end Dias_Del_Mes;

   ---------------------------------------------------------------------------
   -- Codigo_Cronologico: clave entera monotónica para comparar por fecha.
   -- (No depende de la hora, solo de la fecha.)
   ---------------------------------------------------------------------------
   function Codigo_Cronologico (T : Tipoturno) return Integer is
   begin
      return T.Anio * 10_000 + T.Mes * 100 + T.Dia;
   end Codigo_Cronologico;

   ---------------------------------------------------------------------------
   function Crear (Anio          : Tipoanio;
                   Mes           : Tipomes;
                   Dia           : Tipodia;
                   Hora_Minutos  : Tipohora;
                   Dni_Paciente  : Integer) return Tipoturno is
      T : Tipoturno;
   begin
      if Dia > Dias_Del_Mes (Mes, Anio) then
         raise Fecha_Invalida;
      end if;
      T.Anio         := Anio;
      T.Mes          := Mes;
      T.Dia          := Dia;
      T.Hora_Minutos := Hora_Minutos;
      T.Dni_Paciente := Dni_Paciente;
      return T;
   end Crear;

   ---------------------------------------------------------------------------
   function Por_Fecha_Hora (Anio: Tipoanio;
                            Mes : Tipomes;
                            Dia : Tipodia;
                            Hora_Minutos : Tipohora) return Tipoturno is
   begin
      return Crear (Anio, Mes, Dia, Hora_Minutos, Dni_Paciente => 0);
   end Por_Fecha_Hora;

   ---------------------------------------------------------------------------
   function Get_Anio (T: Tipoturno) return Tipoanio is
   begin
      return T.Anio;
   end Get_Anio;

   function Get_Mes (T: Tipoturno) return Tipomes is
   begin
      return T.Mes;
   end Get_Mes;

   function Get_Dia (T: Tipoturno) return Tipodia is
   begin
      return T.Dia;
   end Get_Dia;

   function Get_Hora_Minutos (T: Tipoturno) return Tipohora is
   begin
      return T.Hora_Minutos;
   end Get_Hora_Minutos;

   function Get_Dni_Paciente (T: Tipoturno) return Integer is
   begin
      return T.Dni_Paciente;
   end Get_Dni_Paciente;

   ---------------------------------------------------------------------------
   function Mismo_Dia (T: Tipoturno;
                       Anio: Tipoanio; Mes: Tipomes; Dia: Tipodia)
                      return Boolean is
   begin
      return T.Anio = Anio and T.Mes = Mes and T.Dia = Dia;
   end Mismo_Dia;

   ---------------------------------------------------------------------------
   procedure Imprimir (T: Tipoturno) is
      H : constant Integer := T.Hora_Minutos / 60;
      M : constant Integer := T.Hora_Minutos mod 60;
   begin
      Put (Integer'Image (T.Dia));
      Put ("/");
      Put (Integer'Image (T.Mes));
      Put ("/");
      Put (Integer'Image (T.Anio));
      Put (" ");
      Put (Integer'Image (H));
      Put (":");
      if M < 10 then Put ("0"); end if;
      Put (Integer'Image (M));
      if T.Dni_Paciente /= 0 then
         Put ("  Paciente DNI:");
         Put (T.Dni_Paciente, Width => 9);
      else
         Put ("  (libre)");
      end if;
   end Imprimir;

   ---------------------------------------------------------------------------
   -- Comparadores: orden cronológico por (fecha, hora).
   -- Igual: misma fecha y misma hora (sin mirar Dni_Paciente, así un mismo
   -- slot temporal cuenta como UNO en la lista del médico).
   ---------------------------------------------------------------------------
   function Igual (X, Y : Tipoturno) return Boolean is
   begin
      return Codigo_Cronologico (X) = Codigo_Cronologico (Y)
         and X.Hora_Minutos = Y.Hora_Minutos;
   end Igual;

   function Menor (X, Y : Tipoturno) return Boolean is
      Cx : constant Integer := Codigo_Cronologico (X);
      Cy : constant Integer := Codigo_Cronologico (Y);
   begin
      if Cx < Cy then return True;  end if;
      if Cx > Cy then return False; end if;
      return X.Hora_Minutos < Y.Hora_Minutos;
   end Menor;

   function Mayor (X, Y : Tipoturno) return Boolean is
   begin
      return Menor (Y, X);
   end Mayor;

   ---------------------------------------------------------------------------
   procedure Guardar (Archivo : in out Ada.Text_IO.File_Type;
                      T       : in Tipoturno) is
   begin
      Put_Line (Archivo,
                Integer'Image (T.Anio)         & ASCII.HT &
                Integer'Image (T.Mes)          & ASCII.HT &
                Integer'Image (T.Dia)          & ASCII.HT &
                Integer'Image (T.Hora_Minutos) & ASCII.HT &
                Integer'Image (T.Dni_Paciente));
   end Guardar;

   procedure Cargar (Archivo : in out Ada.Text_IO.File_Type;
                     T       : out Tipoturno) is
      A, M, D, H, P : Integer;
   begin
      Get (Archivo, A);
      Get (Archivo, M);
      Get (Archivo, D);
      Get (Archivo, H);
      Get (Archivo, P);
      Skip_Line (Archivo);
      T := Crear (Anio         => A,
                  Mes          => M,
                  Dia          => D,
                  Hora_Minutos => H,
                  Dni_Paciente => P);
   end Cargar;

end Turno;
