-- ============================================================================
-- paciente.adb
-- Implementación del TAD Paciente.
--
-- PASO A PASO de los puntos no triviales:
--   * Para guardar un String de longitud variable en un Cadena (string fijo
--     de 50), usamos un helper "Copiar_A_Cadena" que rellena con espacios
--     y guarda la longitud real.
--   * Imprimir muestra solo la porción "viva" del string (1..longitud).
--   * Igual compara DNI; pero los comparadores Menor/Mayor (que el package
--     Lista_Ordenada usa para ordenar) comparan por apellido y nombre.
--     IMPORTANTE: para que la lista funcione bien, debe valer la propiedad:
--     "Igual(x,y) ⇒ no Menor(x,y) y no Mayor(x,y)". Como dos pacientes con
--     mismo DNI son la misma persona y tendrán mismo apellido/nombre, esto
--     se cumple en la práctica. (Si hubiera homónimos con distinto DNI,
--     la lista los acepta a ambos sin duplicar porque Igual los distingue.)
-- ============================================================================

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

package body Paciente is

   ---------------------------------------------------------------------------
   -- HELPER privado: copia un String "fuente" a un Cadena (string fijo)
   -- y devuelve la longitud copiada.
   ---------------------------------------------------------------------------
   procedure Copiar_A_Cadena (Fuente : in  String;
                              Destino: out Cadena;
                              Long   : out Natural) is
   begin
      if Fuente'Length > Long_Cadena then
         raise Cadena_Demasiado_Larga;
      end if;
      -- Inicializamos todo a espacio y copiamos lo necesario.
      Destino := (others => ' ');
      Destino (1 .. Fuente'Length) := Fuente;
      Long := Fuente'Length;
   end Copiar_A_Cadena;

   ---------------------------------------------------------------------------
   function Crear (Nombre, Apellido : String;
                   Dni              : Integer;
                   Obra_Social      : String) return Tipopaciente is
      P : Tipopaciente;
   begin
      if Dni <= 0 or else Dni > 99_999_999 then
         raise DNI_Invalido;
      end if;
      P.Dni := Dni;
      Copiar_A_Cadena (Nombre,      P.Nombre,      P.Long_Nombre);
      Copiar_A_Cadena (Apellido,    P.Apellido,    P.Long_Apellido);
      Copiar_A_Cadena (Obra_Social, P.Obra_Social, P.Long_OS);
      return P;
   end Crear;

   ---------------------------------------------------------------------------
   function Por_Dni (Dni : Integer) return Tipopaciente is
      P : Tipopaciente;
   begin
      if Dni <= 0 or else Dni > 99_999_999 then
         raise DNI_Invalido;
      end if;
      P.Dni := Dni;
      return P;
   end Por_Dni;

   ---------------------------------------------------------------------------
   function Get_Dni (P: Tipopaciente) return Integer is
   begin
      return P.Dni;
   end Get_Dni;

   function Get_Nombre (P: Tipopaciente) return String is
   begin
      return P.Nombre (1 .. P.Long_Nombre);
   end Get_Nombre;

   function Get_Apellido (P: Tipopaciente) return String is
   begin
      return P.Apellido (1 .. P.Long_Apellido);
   end Get_Apellido;

   function Get_Obra_Social (P: Tipopaciente) return String is
   begin
      return P.Obra_Social (1 .. P.Long_OS);
   end Get_Obra_Social;

   ---------------------------------------------------------------------------
   procedure Set_Obra_Social (P: in out Tipopaciente; Nueva : String) is
   begin
      Copiar_A_Cadena (Nueva, P.Obra_Social, P.Long_OS);
   end Set_Obra_Social;

   ---------------------------------------------------------------------------
   procedure Imprimir (P: Tipopaciente) is
   begin
      Put ("DNI: ");          Put (P.Dni, Width => 9);
      Put (" | Apellido: ");  Put (Get_Apellido (P));
      Put (" | Nombre: ");    Put (Get_Nombre (P));
      Put (" | O.Social: ");  Put (Get_Obra_Social (P));
      New_Line;
   end Imprimir;

   ---------------------------------------------------------------------------
   -- Comparadores. Orden: por apellido, luego nombre. Igual: por DNI.
   ---------------------------------------------------------------------------
   function Igual (X, Y : Tipopaciente) return Boolean is
   begin
      return X.Dni = Y.Dni;
   end Igual;

   function Menor (X, Y : Tipopaciente) return Boolean is
      Ax : constant String := Get_Apellido (X);
      Ay : constant String := Get_Apellido (Y);
   begin
      if Ax < Ay then return True;  end if;
      if Ax > Ay then return False; end if;
      return Get_Nombre (X) < Get_Nombre (Y);
   end Menor;

   function Mayor (X, Y : Tipopaciente) return Boolean is
   begin
      return Menor (Y, X);
   end Mayor;

   ---------------------------------------------------------------------------
   -- Persistencia simple: 1 línea por campo.
   -- Formato:
   --   <DNI>
   --   <NOMBRE>
   --   <APELLIDO>
   --   <OBRA_SOCIAL>
   ---------------------------------------------------------------------------
   procedure Guardar (Archivo : in out Ada.Text_IO.File_Type;
                      P       : in Tipopaciente) is
   begin
      Put_Line (Archivo, Integer'Image (P.Dni));
      Put_Line (Archivo, Get_Nombre (P));
      Put_Line (Archivo, Get_Apellido (P));
      Put_Line (Archivo, Get_Obra_Social (P));
   end Guardar;

   procedure Cargar (Archivo : in out Ada.Text_IO.File_Type;
                     P       : out Tipopaciente) is
      L_Dni, L_Nom, L_Ape, L_OS : Natural;
      Buf_Dni, Buf_Nom, Buf_Ape, Buf_OS : String (1 .. 200);
   begin
      Get_Line (Archivo, Buf_Dni, L_Dni);
      Get_Line (Archivo, Buf_Nom, L_Nom);
      Get_Line (Archivo, Buf_Ape, L_Ape);
      Get_Line (Archivo, Buf_OS,  L_OS);
      P := Crear (Nombre      => Buf_Nom (1 .. L_Nom),
                  Apellido    => Buf_Ape (1 .. L_Ape),
                  Dni         => Integer'Value (Buf_Dni (1 .. L_Dni)),
                  Obra_Social => Buf_OS  (1 .. L_OS));
   end Cargar;

end Paciente;
