-- ============================================================================
-- clinica.adb
-- Implementación del TAD Clínica.
--
-- PASO A PASO:
--
--   * Para cada modificación a un médico (cargar nueva OS, reservar turno,
--     etc.) se aplica el patrón:
--          Tmp := Buscar (lista, dni)   -- copia del médico
--          Suprimir (lista, tmp)        -- saca el original
--          ... modificar tmp ...
--          Insertar (lista, tmp)        -- vuelve a ponerlo
--     Ya está documentado en medico.adb por qué es necesario (los records
--     con campos "access" se copian shallow).
--
--   * "Agregar_X" levanta excepciones X_Repetido cuando ya existe alguien
--     con el mismo DNI. Esto se chequea con la operación "Esta" de la lista
--     ordenada, que internamente usa Igual (que para Médico/Paciente
--     compara por DNI).
--
--   * Para listar/filtrar por nombre o especialidad, recorremos la lista
--     completa y mostramos los que matchean (es O(n), pero la lista está
--     ordenada por apellido, no por especialidad: filtrar por especialidad
--     siempre requiere recorrido completo, y eso está bien).
-- ============================================================================

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.IO_Exceptions;

package body Clinica is

   ---------------------------------------------------------------------------
   procedure Crear (C : out Tipoclinica; Nombre : in String) is
   begin
      C.Nombre := (others => ' ');
      if Nombre'Length <= Largo_Nombre_Clinica then
         C.Nombre (1 .. Nombre'Length) := Nombre;
         C.Long_Nombre := Nombre'Length;
      else
         C.Nombre := Nombre (Nombre'First .. Nombre'First + Largo_Nombre_Clinica - 1);
         C.Long_Nombre := Largo_Nombre_Clinica;
      end if;
      Lista_Medicos.Crear (C.Medicos);
      Lista_Pacientes.Crear (C.Pacientes);
   end Crear;

   function Get_Nombre (C : Tipoclinica) return String is
   begin
      return C.Nombre (1 .. C.Long_Nombre);
   end Get_Nombre;

   ---------------------------------------------------------------------------
   -- MÉDICOS
   ---------------------------------------------------------------------------
   procedure Agregar_Medico (C : in out Tipoclinica; M : in Medico.Tipomedico) is
   begin
      if Lista_Medicos.Esta (C.Medicos, M) then
         raise Medico_Repetido;
      end if;
      Lista_Medicos.Insertar (C.Medicos, M);
   end Agregar_Medico;

   procedure Eliminar_Medico (C : in out Tipoclinica; Dni : in Integer) is
      Clave : constant Medico.Tipomedico := Medico.Por_Dni (Dni);
   begin
      if not Lista_Medicos.Esta (C.Medicos, Clave) then
         raise Medico_Inexistente;
      end if;
      Lista_Medicos.Suprimir (C.Medicos, Clave);
   end Eliminar_Medico;

   function Buscar_Medico_Por_Dni
      (C : Tipoclinica; Dni : Integer) return Medico.Tipomedico is
      Clave : constant Medico.Tipomedico := Medico.Por_Dni (Dni);
   begin
      if not Lista_Medicos.Esta (C.Medicos, Clave) then
         raise Medico_Inexistente;
      end if;
      return Lista_Medicos.Buscar (C.Medicos, Clave);
   end Buscar_Medico_Por_Dni;

   procedure Modificar_Medico (C : in out Tipoclinica;
                               M_Modificado : in Medico.Tipomedico) is
   begin
      if not Lista_Medicos.Esta (C.Medicos, M_Modificado) then
         raise Medico_Inexistente;
      end if;
      Lista_Medicos.Suprimir (C.Medicos, M_Modificado);
      Lista_Medicos.Insertar (C.Medicos, M_Modificado);
   end Modificar_Medico;

   procedure Listar_Medicos (C : Tipoclinica) is
      L : Lista_Medicos.Tipolista := C.Medicos;
   begin
      Put_Line ("=== Médicos de la Clínica " & Get_Nombre (C) & " ===");
      if Lista_Medicos.Vacia (L) then
         Put_Line ("(no hay médicos cargados)");
         return;
      end if;
      while not Lista_Medicos.Vacia (L) loop
         Medico.Imprimir (Lista_Medicos.Info (L));
         L := Lista_Medicos.Sig (L);
      end loop;
   end Listar_Medicos;

   procedure Listar_Medicos_Por_Especialidad
      (C : Tipoclinica; Esp : String) is
      L : Lista_Medicos.Tipolista := C.Medicos;
      Hubo : Boolean := False;
   begin
      Put_Line ("=== Médicos con especialidad """ & Esp & """ ===");
      while not Lista_Medicos.Vacia (L) loop
         if Medico.Get_Especialidad (Lista_Medicos.Info (L)) = Esp then
            Medico.Imprimir (Lista_Medicos.Info (L));
            Hubo := True;
         end if;
         L := Lista_Medicos.Sig (L);
      end loop;
      if not Hubo then
         Put_Line ("(ninguno)");
      end if;
   end Listar_Medicos_Por_Especialidad;

   procedure Buscar_Medico_Por_Nombre (C : Tipoclinica; Nombre_O_Apellido : String) is
      L : Lista_Medicos.Tipolista := C.Medicos;
      Hubo : Boolean := False;
   begin
      Put_Line ("=== Búsqueda de médicos por '" & Nombre_O_Apellido & "' ===");
      while not Lista_Medicos.Vacia (L) loop
         declare
            M : constant Medico.Tipomedico := Lista_Medicos.Info (L);
         begin
            if Medico.Get_Apellido (M) = Nombre_O_Apellido
               or Medico.Get_Nombre (M) = Nombre_O_Apellido then
               Medico.Imprimir (M);
               Hubo := True;
            end if;
         end;
         L := Lista_Medicos.Sig (L);
      end loop;
      if not Hubo then
         Put_Line ("(no se encontraron coincidencias)");
      end if;
   end Buscar_Medico_Por_Nombre;

   procedure Buscar_Medico_Por_Especialidad (C : Tipoclinica; Esp : String) is
   begin
      Listar_Medicos_Por_Especialidad (C, Esp);
   end Buscar_Medico_Por_Especialidad;

   procedure Listar_Obras_Sociales_Por_Medico (C : Tipoclinica; Dni : Integer) is
      M : constant Medico.Tipomedico := Buscar_Medico_Por_Dni (C, Dni);
   begin
      Medico.Listar_Obras_Sociales (M);
   end Listar_Obras_Sociales_Por_Medico;

   ---------------------------------------------------------------------------
   -- PACIENTES
   ---------------------------------------------------------------------------
   procedure Agregar_Paciente  (C : in out Tipoclinica; P : in Paciente.Tipopaciente) is
   begin
      if Lista_Pacientes.Esta (C.Pacientes, P) then
         raise Paciente_Repetido;
      end if;
      Lista_Pacientes.Insertar (C.Pacientes, P);
   end Agregar_Paciente;

   procedure Eliminar_Paciente (C : in out Tipoclinica; Dni : in Integer) is
      Clave : constant Paciente.Tipopaciente := Paciente.Por_Dni (Dni);
   begin
      if not Lista_Pacientes.Esta (C.Pacientes, Clave) then
         raise Paciente_Inexistente;
      end if;
      Lista_Pacientes.Suprimir (C.Pacientes, Clave);
   end Eliminar_Paciente;

   function Buscar_Paciente_Por_Dni
      (C : Tipoclinica; Dni : Integer) return Paciente.Tipopaciente is
      Clave : constant Paciente.Tipopaciente := Paciente.Por_Dni (Dni);
   begin
      if not Lista_Pacientes.Esta (C.Pacientes, Clave) then
         raise Paciente_Inexistente;
      end if;
      return Lista_Pacientes.Buscar (C.Pacientes, Clave);
   end Buscar_Paciente_Por_Dni;

   procedure Listar_Pacientes (C : Tipoclinica) is
      L : Lista_Pacientes.Tipolista := C.Pacientes;
   begin
      Put_Line ("=== Pacientes de la Clínica " & Get_Nombre (C) & " ===");
      if Lista_Pacientes.Vacia (L) then
         Put_Line ("(no hay pacientes cargados)");
         return;
      end if;
      while not Lista_Pacientes.Vacia (L) loop
         Paciente.Imprimir (Lista_Pacientes.Info (L));
         L := Lista_Pacientes.Sig (L);
      end loop;
   end Listar_Pacientes;

   ---------------------------------------------------------------------------
   -- TURNOS
   ---------------------------------------------------------------------------
   procedure Sacar_Turno (C            : in out Tipoclinica;
                          Dni_Medico   : in Integer;
                          Dni_Paciente : in Integer;
                          T            : in Turno.Tipoturno) is
      M : Medico.Tipomedico;
   begin
      -- Validamos paciente.
      if not Lista_Pacientes.Esta
         (C.Pacientes, Paciente.Por_Dni (Dni_Paciente))
      then
         raise Paciente_Inexistente;
      end if;
      -- Tomamos copia del médico, actualizamos su agenda y lo re-insertamos.
      M := Buscar_Medico_Por_Dni (C, Dni_Medico);  -- copia
      begin
         Medico.Reservar_Turno (M, T);
      exception
         when Medico.Sin_Disponibilidad =>
            raise Sin_Disponibilidad;
      end;
      Modificar_Medico (C, M);
   end Sacar_Turno;

   procedure Cancelar_Turno (C          : in out Tipoclinica;
                             Dni_Medico : in Integer;
                             T          : in Turno.Tipoturno) is
      M : Medico.Tipomedico := Buscar_Medico_Por_Dni (C, Dni_Medico);
   begin
      begin
         Medico.Cancelar_Turno (M, T);
      exception
         when Medico.Turno_Inexistente =>
            raise Turno_Inexistente;
      end;
      Modificar_Medico (C, M);
   end Cancelar_Turno;

   procedure Buscar_Turno_Disponible
      (C    : Tipoclinica;
       Esp  : in String;
       Anio : Turno.Tipoanio;
       Mes  : Turno.Tipomes;
       Dia  : Turno.Tipodia) is
      L : Lista_Medicos.Tipolista := C.Medicos;
      Hubo : Boolean := False;
   begin
      Put_Line ("=== Turnos disponibles - Especialidad: " & Esp
                & " | Fecha: " & Integer'Image (Dia)
                & "/" & Integer'Image (Mes)
                & "/" & Integer'Image (Anio) & " ===");
      while not Lista_Medicos.Vacia (L) loop
         declare
            M : constant Medico.Tipomedico := Lista_Medicos.Info (L);
            Disp : constant Natural :=
               Medico.Disponibles_Dia (M, Anio, Mes, Dia);
         begin
            if Medico.Get_Especialidad (M) = Esp and Disp > 0 then
               Put ("  - Dr/a. ");
               Put (Medico.Get_Apellido (M));
               Put (", ");
               Put (Medico.Get_Nombre (M));
               Put (" (DNI ");
               Put (Medico.Get_Dni (M), Width => 0);
               Put_Line (") -> " & Natural'Image (Disp) & " turno(s) libre(s)");
               Hubo := True;
            end if;
         end;
         L := Lista_Medicos.Sig (L);
      end loop;
      if not Hubo then
         Put_Line ("(no hay turnos disponibles)");
      end if;
   end Buscar_Turno_Disponible;

   function Disponibles_Por_Especialidad
      (C : Tipoclinica;
       Esp  : String;
       Anio : Turno.Tipoanio;
       Mes  : Turno.Tipomes;
       Dia  : Turno.Tipodia) return Natural is
      L : Lista_Medicos.Tipolista := C.Medicos;
      Total : Natural := 0;
   begin
      while not Lista_Medicos.Vacia (L) loop
         declare
            M : constant Medico.Tipomedico := Lista_Medicos.Info (L);
         begin
            if Medico.Get_Especialidad (M) = Esp then
               Total := Total + Medico.Disponibles_Dia (M, Anio, Mes, Dia);
            end if;
         end;
         L := Lista_Medicos.Sig (L);
      end loop;
      return Total;
   end Disponibles_Por_Especialidad;

   ---------------------------------------------------------------------------
   -- PERSISTENCIA
   --
   -- Formato del archivo (texto):
   --   <NOMBRE_CLINICA>
   --   <CANT_MEDICOS>
   --   <CANT_MEDICOS bloques con Medico.Guardar>
   --   <CANT_PACIENTES>
   --   <CANT_PACIENTES bloques con Paciente.Guardar>
   ---------------------------------------------------------------------------
   procedure Guardar_En_Archivo (C : Tipoclinica; Ruta : String) is
      F : File_Type;
      LM : Lista_Medicos.Tipolista := C.Medicos;
      LP : Lista_Pacientes.Tipolista := C.Pacientes;
      Cant_M : constant Natural := Lista_Medicos.Largo (C.Medicos);
      Cant_P : constant Natural := Lista_Pacientes.Largo (C.Pacientes);
   begin
      Create (F, Out_File, Ruta);
      Put_Line (F, Get_Nombre (C));
      Put_Line (F, Integer'Image (Cant_M));
      while not Lista_Medicos.Vacia (LM) loop
         Medico.Guardar (F, Lista_Medicos.Info (LM));
         LM := Lista_Medicos.Sig (LM);
      end loop;
      Put_Line (F, Integer'Image (Cant_P));
      while not Lista_Pacientes.Vacia (LP) loop
         Paciente.Guardar (F, Lista_Pacientes.Info (LP));
         LP := Lista_Pacientes.Sig (LP);
      end loop;
      Close (F);
   end Guardar_En_Archivo;

   procedure Cargar_De_Archivo (C : in out Tipoclinica; Ruta : String) is
      F : File_Type;
      Linea : String (1 .. 200);
      Last  : Natural;
      Cant_M, Cant_P : Integer;
   begin
      begin
         Open (F, In_File, Ruta);
      exception
         when Ada.IO_Exceptions.Name_Error =>
            -- No existe aún → la clínica queda como está (vacía si recién
            -- la creó el llamador).
            return;
      end;

      Get_Line (F, Linea, Last);
      Crear (C, Linea (1 .. Last));

      Get_Line (F, Linea, Last);
      Cant_M := Integer'Value (Linea (1 .. Last));
      for I in 1 .. Cant_M loop
         declare
            M : Medico.Tipomedico;
         begin
            Medico.Cargar (F, M);
            Lista_Medicos.Insertar (C.Medicos, M);
         end;
      end loop;

      Get_Line (F, Linea, Last);
      Cant_P := Integer'Value (Linea (1 .. Last));
      for I in 1 .. Cant_P loop
         declare
            P : Paciente.Tipopaciente;
         begin
            Paciente.Cargar (F, P);
            Lista_Pacientes.Insertar (C.Pacientes, P);
         end;
      end loop;

      Close (F);
   end Cargar_De_Archivo;

end Clinica;
