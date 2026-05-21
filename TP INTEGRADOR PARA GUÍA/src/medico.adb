-- ============================================================================
-- medico.adb
-- Implementación del TAD Médico.
--
-- PASO A PASO de los puntos no triviales:
--
--   * Agenda: instanciamos en el spec privado un Lista_Ordenada de Tipoturno.
--     Acá usamos sus operaciones (Crear, Insertar, Suprimir, ...).
--
--   * NOTA SOBRE COPIAS: como Tipomedico es un record con un campo de tipo
--     access (Turnos_Reservados), copiar un Tipomedico por valor copia
--     "el puntero a la cabeza de la agenda", NO clona la lista. Si afuera
--     se trabaja con una COPIA de un Médico y se modifica su agenda, los
--     cambios SE PIERDEN cuando esa copia se descarte. Por eso, en la
--     Clínica, cuando se modifica un médico se sigue el patrón:
--          tmp := Buscar (lista, dni)         -- toma copia
--          Suprimir (lista, tmp)              -- saca la copia (libera nodo)
--          ... modificar tmp ...
--          Insertar (lista, tmp)              -- vuelve a meterla
--     Esto preserva las modificaciones porque la lista de médicos guarda
--     la versión final y la "agenda" (puntero) viajó dentro de tmp.
--
--   * Para "Disponibles_Dia" recorremos la agenda contando los turnos que
--     caen en la fecha pedida. Se podría optimizar con un índice por día
--     pero, dado que un médico no tiene más que decenas de turnos por día,
--     el costo lineal está bien.
-- ============================================================================

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

package body Medico is

   ---------------------------------------------------------------------------
   -- Helper: copia String → Cadena con largo.
   ---------------------------------------------------------------------------
   procedure Copiar_A_Cadena (Fuente : in  String;
                              Destino: out Cadena;
                              Long   : out Natural) is
   begin
      if Fuente'Length > Long_Cadena then
         raise Cadena_Demasiado_Larga;
      end if;
      Destino := (others => ' ');
      Destino (1 .. Fuente'Length) := Fuente;
      Long := Fuente'Length;
   end Copiar_A_Cadena;

   ---------------------------------------------------------------------------
   -- Helper privado: comparación insensible a mayúsculas/espacios para OS.
   -- Acá lo dejamos simple (case-sensitive); puede hacerse más robusto.
   ---------------------------------------------------------------------------
   function Misma_OS (A : Obra_Social; Texto : String) return Boolean is
   begin
      return A.Long = Texto'Length
         and then A.Texto (1 .. A.Long) = Texto;
   end Misma_OS;

   ---------------------------------------------------------------------------
   function Crear (Nombre, Apellido, Especialidad : String;
                   Dni            : Integer;
                   Max_Turnos_Dia : Positive := 8) return Tipomedico is
      M : Tipomedico;
   begin
      if Dni <= 0 or else Dni > 99_999_999 then
         raise DNI_Invalido;
      end if;
      M.Dni := Dni;
      Copiar_A_Cadena (Nombre,       M.Nombre,       M.Long_Nombre);
      Copiar_A_Cadena (Apellido,     M.Apellido,     M.Long_Apellido);
      Copiar_A_Cadena (Especialidad, M.Especialidad, M.Long_Esp);
      M.Max_Turnos_Dia := Max_Turnos_Dia;
      Agenda.Crear (M.Turnos_Reservados);
      return M;
   end Crear;

   ---------------------------------------------------------------------------
   function Por_Dni (Dni : Integer) return Tipomedico is
      M : Tipomedico;
   begin
      if Dni <= 0 or else Dni > 99_999_999 then
         raise DNI_Invalido;
      end if;
      M.Dni := Dni;
      Agenda.Crear (M.Turnos_Reservados);
      return M;
   end Por_Dni;

   ---------------------------------------------------------------------------
   function Get_Dni (M: Tipomedico) return Integer is
   begin
      return M.Dni;
   end Get_Dni;

   function Get_Nombre (M: Tipomedico) return String is
   begin
      return M.Nombre (1 .. M.Long_Nombre);
   end Get_Nombre;

   function Get_Apellido (M: Tipomedico) return String is
   begin
      return M.Apellido (1 .. M.Long_Apellido);
   end Get_Apellido;

   function Get_Especialidad (M: Tipomedico) return String is
   begin
      return M.Especialidad (1 .. M.Long_Esp);
   end Get_Especialidad;

   function Get_Max_Turnos_Dia (M: Tipomedico) return Positive is
   begin
      return M.Max_Turnos_Dia;
   end Get_Max_Turnos_Dia;

   ---------------------------------------------------------------------------
   procedure Modificar_Max_Turnos (M: in out Tipomedico; Nuevo: Positive) is
   begin
      M.Max_Turnos_Dia := Nuevo;
   end Modificar_Max_Turnos;

   ---------------------------------------------------------------------------
   procedure Agregar_Obra_Social (M: in out Tipomedico; OS: String) is
   begin
      if OS'Length > Long_Cadena then
         raise Cadena_Demasiado_Larga;
      end if;
      -- Idempotente: si ya está, no se agrega de nuevo.
      for I in 1 .. M.Cantidad_OS loop
         if Misma_OS (M.Obras_Sociales (I), OS) then
            return;
         end if;
      end loop;
      if M.Cantidad_OS = Max_Obras_Sociales then
         raise Maximo_Obras_Sociales;
      end if;
      M.Cantidad_OS := M.Cantidad_OS + 1;
      M.Obras_Sociales (M.Cantidad_OS).Texto := (others => ' ');
      M.Obras_Sociales (M.Cantidad_OS).Texto (1 .. OS'Length) := OS;
      M.Obras_Sociales (M.Cantidad_OS).Long := OS'Length;
   end Agregar_Obra_Social;

   ---------------------------------------------------------------------------
   function Admite_Obra_Social (M: Tipomedico; OS: String) return Boolean is
   begin
      for I in 1 .. M.Cantidad_OS loop
         if Misma_OS (M.Obras_Sociales (I), OS) then
            return True;
         end if;
      end loop;
      return False;
   end Admite_Obra_Social;

   ---------------------------------------------------------------------------
   procedure Listar_Obras_Sociales (M: Tipomedico) is
   begin
      Put ("Obras sociales admitidas por Dr/a. ");
      Put (Get_Apellido (M));
      Put_Line (":");
      if M.Cantidad_OS = 0 then
         Put_Line ("  (ninguna cargada)");
      else
         for I in 1 .. M.Cantidad_OS loop
            Put ("  - ");
            Put_Line (M.Obras_Sociales (I).Texto (1 .. M.Obras_Sociales (I).Long));
         end loop;
      end if;
   end Listar_Obras_Sociales;

   ---------------------------------------------------------------------------
   -- Cantidad de turnos cargados para un día.
   -- Se podría usar el iterador "Recorrer", pero para CONTAR necesitamos
   -- una variable de estado (Counter), entonces hacemos el recorrido manual
   -- usando Info y Sig (operaciones públicas de Lista_Ordenada).
   ---------------------------------------------------------------------------
   function Cantidad_Turnos_Dia
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia)
      return Natural is
      L : Agenda.Tipolista := M.Turnos_Reservados;
      N : Natural := 0;
   begin
      while not Agenda.Vacia (L) loop
         if Turno.Mismo_Dia (Agenda.Info (L), Anio, Mes, Dia) then
            N := N + 1;
         end if;
         L := Agenda.Sig (L);
      end loop;
      return N;
   end Cantidad_Turnos_Dia;

   ---------------------------------------------------------------------------
   function Disponibles_Dia
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia)
      return Natural is
      Reservados : constant Natural := Cantidad_Turnos_Dia (M, Anio, Mes, Dia);
   begin
      if Reservados >= M.Max_Turnos_Dia then
         return 0;
      else
         return M.Max_Turnos_Dia - Reservados;
      end if;
   end Disponibles_Dia;

   ---------------------------------------------------------------------------
   function Hay_Disponibilidad
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia)
      return Boolean is
   begin
      return Disponibles_Dia (M, Anio, Mes, Dia) > 0;
   end Hay_Disponibilidad;

   ---------------------------------------------------------------------------
   procedure Reservar_Turno (M: in out Tipomedico; T: in Turno.Tipoturno) is
   begin
      -- ¿Queda capacidad ese día?
      if not Hay_Disponibilidad
         (M, Turno.Get_Anio (T), Turno.Get_Mes (T), Turno.Get_Dia (T))
      then
         raise Sin_Disponibilidad;
      end if;
      -- ¿El slot exacto está libre? (Esta lo chequea por Igual = misma
      -- fecha+hora.)
      if Agenda.Esta (M.Turnos_Reservados, T) then
         raise Sin_Disponibilidad;
      end if;
      Agenda.Insertar (M.Turnos_Reservados, T);
   end Reservar_Turno;

   ---------------------------------------------------------------------------
   procedure Cancelar_Turno (M: in out Tipomedico; T: in Turno.Tipoturno) is
   begin
      if not Agenda.Esta (M.Turnos_Reservados, T) then
         raise Turno_Inexistente;
      end if;
      Agenda.Suprimir (M.Turnos_Reservados, T);
   end Cancelar_Turno;

   ---------------------------------------------------------------------------
   procedure Listar_Turnos_Dia
      (M: Tipomedico;
       Anio: Turno.Tipoanio; Mes: Turno.Tipomes; Dia: Turno.Tipodia) is
      L     : Agenda.Tipolista := M.Turnos_Reservados;
      Hubo  : Boolean := False;
   begin
      Put_Line ("Turnos del Dr/a. " & Get_Apellido (M)
                & " para el " & Integer'Image (Dia)
                & "/" & Integer'Image (Mes)
                & "/" & Integer'Image (Anio) & ":");
      while not Agenda.Vacia (L) loop
         if Turno.Mismo_Dia (Agenda.Info (L), Anio, Mes, Dia) then
            Put ("  - ");
            Turno.Imprimir (Agenda.Info (L));
            New_Line;
            Hubo := True;
         end if;
         L := Agenda.Sig (L);
      end loop;
      if not Hubo then
         Put_Line ("  (sin turnos asignados ese día)");
      end if;
      Put_Line ("Disponibles ese día: "
                & Integer'Image (Disponibles_Dia (M, Anio, Mes, Dia)));
   end Listar_Turnos_Dia;

   ---------------------------------------------------------------------------
   -- Para listar la semana, simplificamos: mostramos cada día desde
   -- (Anio_Inicio, Mes_Inicio, Dia_Inicio) avanzando 7 jornadas.
   -- Para avanzar día a día respetando cambios de mes/año, encapsulamos
   -- la operación "siguiente día" en un helper local.
   ---------------------------------------------------------------------------
   procedure Listar_Turnos_Semana
      (M: Tipomedico;
       Anio_Inicio: Turno.Tipoanio;
       Mes_Inicio:  Turno.Tipomes;
       Dia_Inicio:  Turno.Tipodia) is

      A : Turno.Tipoanio := Anio_Inicio;
      Me: Turno.Tipomes  := Mes_Inicio;
      D : Turno.Tipodia  := Dia_Inicio;

      function Bisiesto (X : Turno.Tipoanio) return Boolean is
      begin
         return (X mod 4 = 0 and X mod 100 /= 0) or (X mod 400 = 0);
      end Bisiesto;

      function Dias_Mes (Mm: Turno.Tipomes; Aa: Turno.Tipoanio)
                        return Turno.Tipodia is
      begin
         case Mm is
            when 1 | 3 | 5 | 7 | 8 | 10 | 12 => return 31;
            when 4 | 6 | 9 | 11              => return 30;
            when 2 =>
               if Bisiesto (Aa) then return 29; else return 28; end if;
         end case;
      end Dias_Mes;

      procedure Avanzar_Dia is
      begin
         if D < Dias_Mes (Me, A) then
            D := D + 1;
         else
            D := 1;
            if Me = 12 then
               Me := 1;
               A  := A + 1;
            else
               Me := Me + 1;
            end if;
         end if;
      end Avanzar_Dia;

   begin
      for I in 1 .. 7 loop
         Listar_Turnos_Dia (M, A, Me, D);
         New_Line;
         Avanzar_Dia;
      end loop;
   end Listar_Turnos_Semana;

   ---------------------------------------------------------------------------
   procedure Imprimir (M: Tipomedico) is
   begin
      Put ("DNI: ");          Put (M.Dni, Width => 9);
      Put (" | Apellido: ");  Put (Get_Apellido (M));
      Put (" | Nombre: ");    Put (Get_Nombre (M));
      Put (" | Esp.: ");      Put (Get_Especialidad (M));
      Put (" | Max turnos/día: "); Put (Integer (M.Max_Turnos_Dia), Width => 3);
      New_Line;
   end Imprimir;

   ---------------------------------------------------------------------------
   function Igual (X, Y : Tipomedico) return Boolean is
   begin
      return X.Dni = Y.Dni;
   end Igual;

   function Menor (X, Y : Tipomedico) return Boolean is
      Ax : constant String := Get_Apellido (X);
      Ay : constant String := Get_Apellido (Y);
   begin
      if Ax < Ay then return True;  end if;
      if Ax > Ay then return False; end if;
      return Get_Nombre (X) < Get_Nombre (Y);
   end Menor;

   function Mayor (X, Y : Tipomedico) return Boolean is
   begin
      return Menor (Y, X);
   end Mayor;

   ---------------------------------------------------------------------------
   -- Persistencia. Formato:
   --   DNI
   --   NOMBRE
   --   APELLIDO
   --   ESPECIALIDAD
   --   MAX_TURNOS
   --   CANT_OS
   --   <CANT_OS líneas con la obra social>
   --   CANT_TURNOS
   --   <CANT_TURNOS turnos en formato Turno.Guardar>
   ---------------------------------------------------------------------------
   procedure Guardar (Archivo : in out Ada.Text_IO.File_Type;
                      M       : in Tipomedico) is
      L : Agenda.Tipolista := M.Turnos_Reservados;
      Cant_Turnos : constant Natural := Agenda.Largo (M.Turnos_Reservados);
   begin
      Put_Line (Archivo, Integer'Image (M.Dni));
      Put_Line (Archivo, Get_Nombre (M));
      Put_Line (Archivo, Get_Apellido (M));
      Put_Line (Archivo, Get_Especialidad (M));
      Put_Line (Archivo, Integer'Image (M.Max_Turnos_Dia));
      Put_Line (Archivo, Integer'Image (M.Cantidad_OS));
      for I in 1 .. M.Cantidad_OS loop
         Put_Line (Archivo,
            M.Obras_Sociales (I).Texto (1 .. M.Obras_Sociales (I).Long));
      end loop;
      Put_Line (Archivo, Integer'Image (Cant_Turnos));
      while not Agenda.Vacia (L) loop
         Turno.Guardar (Archivo, Agenda.Info (L));
         L := Agenda.Sig (L);
      end loop;
   end Guardar;

   procedure Cargar (Archivo : in out Ada.Text_IO.File_Type;
                     M       : out Tipomedico) is
      Linea : String (1 .. 200);
      Last  : Natural;
      V_Dni, Maxt, Cant_OS, Cant_Turnos : Integer;
      Nom, Ape, Esp : String (1 .. 200);
      Lnom, Lape, Lesp : Natural;
   begin
      -- Línea 1: DNI
      Get_Line (Archivo, Linea, Last);
      V_Dni := Integer'Value (Linea (1 .. Last));
      -- Líneas 2-4: textos
      Get_Line (Archivo, Nom, Lnom);
      Get_Line (Archivo, Ape, Lape);
      Get_Line (Archivo, Esp, Lesp);
      -- Línea 5: max turnos
      Get_Line (Archivo, Linea, Last);
      Maxt := Integer'Value (Linea (1 .. Last));

      M := Crear (Nombre         => Nom (1 .. Lnom),
                  Apellido       => Ape (1 .. Lape),
                  Especialidad   => Esp (1 .. Lesp),
                  Dni            => V_Dni,
                  Max_Turnos_Dia => Positive (Maxt));

      -- Línea 6: cantidad de OS
      Get_Line (Archivo, Linea, Last);
      Cant_OS := Integer'Value (Linea (1 .. Last));
      for I in 1 .. Cant_OS loop
         Get_Line (Archivo, Linea, Last);
         Agregar_Obra_Social (M, Linea (1 .. Last));
      end loop;

      -- Línea: cantidad de turnos
      Get_Line (Archivo, Linea, Last);
      Cant_Turnos := Integer'Value (Linea (1 .. Last));
      for I in 1 .. Cant_Turnos loop
         declare
            T : Turno.Tipoturno;
         begin
            Turno.Cargar (Archivo, T);
            Agenda.Insertar (M.Turnos_Reservados, T);
         end;
      end loop;
   end Cargar;

end Medico;
