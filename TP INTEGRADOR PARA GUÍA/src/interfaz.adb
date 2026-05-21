-- ============================================================================
-- interfaz.adb
-- Implementación de la interfaz por consola.
--
-- PASO A PASO:
--   * Leer_Cadena lee una línea entera. Devuelve el string ya recortado.
--     Como Get_Line necesita un buffer, usamos uno de tamaño fijo (200).
--   * Cada Menu_X primero pide los datos necesarios y después llama al
--     TAD correspondiente envolviendo en bloque begin/exception/end para
--     mostrar mensajes legibles si algo falla.
-- ============================================================================

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Medico;
with Paciente;
with Turno;

package body Interfaz is

   ---------------------------------------------------------------------------
   -- HELPER: leer una línea de la consola y devolverla como String "ajustado".
   ---------------------------------------------------------------------------
   function Leer_Cadena (Prompt : String) return String is
      Buf : String (1 .. 200);
      L   : Natural;
   begin
      Put (Prompt);
      Get_Line (Buf, L);
      return Buf (1 .. L);
   end Leer_Cadena;

   ---------------------------------------------------------------------------
   function Leer_Entero (Prompt : String) return Integer is
      X : Integer;
   begin
      Put (Prompt);
      Get (X);
      Skip_Line;  -- consume el ENTER pendiente para que el próximo Get_Line
                  -- no devuelva una línea vacía.
      return X;
   end Leer_Entero;

   ---------------------------------------------------------------------------
   procedure Mostrar_Menu is
   begin
      New_Line;
      Put_Line ("============================================");
      Put_Line ("       Sistema de Gestión de Clínica");
      Put_Line ("============================================");
      Put_Line (" a. Alta de médico");
      Put_Line (" b. Baja de médico");
      Put_Line (" c. Buscar médico (por nombre / apellido / esp.)");
      Put_Line (" d. Listar médicos (todos o por especialidad)");
      Put_Line (" e. Listar obras sociales de un médico");
      Put_Line (" f. Agregar obra social a un médico");
      Put_Line (" h. Modificar máx. turnos diarios de un médico");
      Put_Line ("--");
      Put_Line (" i. Alta de paciente");
      Put_Line (" j. Baja de paciente");
      Put_Line (" k. Buscar paciente por DNI");
      Put_Line (" l. Listar pacientes");
      Put_Line ("--");
      Put_Line (" m. Buscar turno disponible (por especialidad y fecha)");
      Put_Line (" n. Sacar turno");
      Put_Line (" o. Cancelar turno");
      Put_Line (" p. Disponibilidad por especialidad para un día");
      Put_Line (" q. Listar agenda de un médico (día / semana)");
      Put_Line ("--");
      Put_Line (" g. Guardar y salir");
      Put_Line (" s. Salir SIN guardar");
      Put_Line ("============================================");
   end Mostrar_Menu;

   ---------------------------------------------------------------------------
   function Leer_Opcion return Character is
      Linea : String (1 .. 4);
      L     : Natural;
   begin
      Put ("Opción: ");
      Get_Line (Linea, L);
      if L = 0 then
         return ' ';
      end if;
      return Linea (1);
   end Leer_Opcion;

   ---------------------------------------------------------------------------
   -- MÉDICOS
   ---------------------------------------------------------------------------
   procedure Menu_Alta_Medico (C : in out Clinica.Tipoclinica) is
   begin
      declare
         Dni  : constant Integer := Leer_Entero  ("DNI: ");
         Nom  : constant String  := Leer_Cadena  ("Nombre: ");
         Ape  : constant String  := Leer_Cadena  ("Apellido: ");
         Esp  : constant String  := Leer_Cadena  ("Especialidad: ");
         MaxT : constant Integer := Leer_Entero  ("Máx turnos por día: ");
         M    : constant Medico.Tipomedico :=
            Medico.Crear (Nombre         => Nom,
                          Apellido       => Ape,
                          Especialidad   => Esp,
                          Dni            => Dni,
                          Max_Turnos_Dia => Positive (MaxT));
      begin
         Clinica.Agregar_Medico (C, M);
         Put_Line ("[OK] Médico dado de alta.");
      end;
   exception
      when Clinica.Medico_Repetido =>
         Put_Line ("[ERROR] Ya existe un médico con ese DNI.");
      when Medico.DNI_Invalido =>
         Put_Line ("[ERROR] DNI fuera de rango.");
      when Medico.Cadena_Demasiado_Larga =>
         Put_Line ("[ERROR] Alguno de los textos supera los 50 caracteres.");
      when Constraint_Error =>
         Put_Line ("[ERROR] Valor numérico inválido (ej: max turnos <= 0).");
   end Menu_Alta_Medico;

   procedure Menu_Baja_Medico (C : in out Clinica.Tipoclinica) is
      Dni : Integer;
   begin
      Dni := Leer_Entero ("DNI del médico a eliminar: ");
      Clinica.Eliminar_Medico (C, Dni);
      Put_Line ("[OK] Médico eliminado.");
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
   end Menu_Baja_Medico;

   procedure Menu_Buscar_Medico (C : in Clinica.Tipoclinica) is
      Modo  : Character;
      Linea : String (1 .. 4);
      L     : Natural;
   begin
      Put_Line ("¿Buscar por (n)ombre/apellido o (e)specialidad?");
      Put ("Opción: ");
      Get_Line (Linea, L);
      if L = 0 then return; end if;
      Modo := Linea (1);
      case Modo is
         when 'n' | 'N' =>
            declare
               Q : constant String := Leer_Cadena ("Texto a buscar: ");
            begin
               Clinica.Buscar_Medico_Por_Nombre (C, Q);
            end;
         when 'e' | 'E' =>
            declare
               Q : constant String := Leer_Cadena ("Especialidad: ");
            begin
               Clinica.Buscar_Medico_Por_Especialidad (C, Q);
            end;
         when others =>
            Put_Line ("Opción no válida.");
      end case;
   end Menu_Buscar_Medico;

   procedure Menu_Listar_Medicos (C : in Clinica.Tipoclinica) is
      Linea : String (1 .. 4);
      L     : Natural;
   begin
      Put_Line ("¿Listar (t)odos o (e)specialidad?");
      Put ("Opción: ");
      Get_Line (Linea, L);
      if L = 0 then
         Clinica.Listar_Medicos (C);
         return;
      end if;
      case Linea (1) is
         when 'e' | 'E' =>
            declare
               Esp : constant String := Leer_Cadena ("Especialidad: ");
            begin
               Clinica.Listar_Medicos_Por_Especialidad (C, Esp);
            end;
         when others =>
            Clinica.Listar_Medicos (C);
      end case;
   end Menu_Listar_Medicos;

   procedure Menu_Listar_OS_Medico (C : in Clinica.Tipoclinica) is
      Dni : Integer;
   begin
      Dni := Leer_Entero ("DNI del médico: ");
      Clinica.Listar_Obras_Sociales_Por_Medico (C, Dni);
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
   end Menu_Listar_OS_Medico;

   procedure Menu_Agregar_OS_Medico (C : in out Clinica.Tipoclinica) is
      Dni : Integer;
   begin
      Dni := Leer_Entero ("DNI del médico: ");
      declare
         M  : Medico.Tipomedico := Clinica.Buscar_Medico_Por_Dni (C, Dni);
         OS : constant String   := Leer_Cadena ("Obra social a agregar: ");
      begin
         Medico.Agregar_Obra_Social (M, OS);
         Clinica.Modificar_Medico (C, M);
         Put_Line ("[OK] Obra social agregada.");
      end;
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
      when Medico.Maximo_Obras_Sociales =>
         Put_Line ("[ERROR] El médico ya alcanzó el máximo de OS admitidas.");
   end Menu_Agregar_OS_Medico;

   procedure Menu_Modificar_Max_Turnos (C : in out Clinica.Tipoclinica) is
      Dni  : Integer;
      Max  : Integer;
   begin
      Dni := Leer_Entero ("DNI del médico: ");
      Max := Leer_Entero ("Nuevo máx. turnos por día: ");
      declare
         M : Medico.Tipomedico := Clinica.Buscar_Medico_Por_Dni (C, Dni);
      begin
         Medico.Modificar_Max_Turnos (M, Positive (Max));
         Clinica.Modificar_Medico (C, M);
         Put_Line ("[OK] Máximo actualizado.");
      end;
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
      when Constraint_Error =>
         Put_Line ("[ERROR] El nuevo máximo debe ser > 0.");
   end Menu_Modificar_Max_Turnos;

   ---------------------------------------------------------------------------
   -- PACIENTES
   ---------------------------------------------------------------------------
   procedure Menu_Alta_Paciente (C : in out Clinica.Tipoclinica) is
   begin
      declare
         Dni : constant Integer := Leer_Entero ("DNI: ");
         Nom : constant String  := Leer_Cadena ("Nombre: ");
         Ape : constant String  := Leer_Cadena ("Apellido: ");
         OS  : constant String  := Leer_Cadena ("Obra social: ");
         P   : constant Paciente.Tipopaciente :=
            Paciente.Crear (Nombre      => Nom,
                            Apellido    => Ape,
                            Dni         => Dni,
                            Obra_Social => OS);
      begin
         Clinica.Agregar_Paciente (C, P);
         Put_Line ("[OK] Paciente dado de alta.");
      end;
   exception
      when Clinica.Paciente_Repetido =>
         Put_Line ("[ERROR] Ya existe un paciente con ese DNI.");
      when Paciente.DNI_Invalido =>
         Put_Line ("[ERROR] DNI fuera de rango.");
      when Paciente.Cadena_Demasiado_Larga =>
         Put_Line ("[ERROR] Alguna cadena supera los 50 caracteres.");
   end Menu_Alta_Paciente;

   procedure Menu_Baja_Paciente (C : in out Clinica.Tipoclinica) is
      Dni : Integer;
   begin
      Dni := Leer_Entero ("DNI del paciente a eliminar: ");
      Clinica.Eliminar_Paciente (C, Dni);
      Put_Line ("[OK] Paciente eliminado.");
   exception
      when Clinica.Paciente_Inexistente =>
         Put_Line ("[ERROR] No existe paciente con ese DNI.");
   end Menu_Baja_Paciente;

   procedure Menu_Buscar_Paciente (C : in Clinica.Tipoclinica) is
      Dni : Integer;
   begin
      Dni := Leer_Entero ("DNI del paciente: ");
      declare
         P : constant Paciente.Tipopaciente :=
            Clinica.Buscar_Paciente_Por_Dni (C, Dni);
      begin
         Paciente.Imprimir (P);
      end;
   exception
      when Clinica.Paciente_Inexistente =>
         Put_Line ("[ERROR] No existe paciente con ese DNI.");
   end Menu_Buscar_Paciente;

   procedure Menu_Listar_Pacientes (C : in Clinica.Tipoclinica) is
   begin
      Clinica.Listar_Pacientes (C);
   end Menu_Listar_Pacientes;

   ---------------------------------------------------------------------------
   -- TURNOS
   ---------------------------------------------------------------------------
   procedure Menu_Buscar_Turno_Disp (C : in Clinica.Tipoclinica) is
      Esp  : constant String  := Leer_Cadena  ("Especialidad: ");
      Anio : constant Integer := Leer_Entero  ("Año (AAAA): ");
      Mes  : constant Integer := Leer_Entero  ("Mes (1-12): ");
      Dia  : constant Integer := Leer_Entero  ("Día (1-31): ");
   begin
      Clinica.Buscar_Turno_Disponible
         (C, Esp, Turno.Tipoanio (Anio), Turno.Tipomes (Mes), Turno.Tipodia (Dia));
   exception
      when Constraint_Error =>
         Put_Line ("[ERROR] Fecha inválida.");
   end Menu_Buscar_Turno_Disp;

   procedure Menu_Sacar_Turno (C : in out Clinica.Tipoclinica) is
      Dni_M : constant Integer := Leer_Entero ("DNI médico: ");
      Dni_P : constant Integer := Leer_Entero ("DNI paciente: ");
      Anio  : constant Integer := Leer_Entero ("Año (AAAA): ");
      Mes   : constant Integer := Leer_Entero ("Mes (1-12): ");
      Dia   : constant Integer := Leer_Entero ("Día (1-31): ");
      H     : constant Integer := Leer_Entero ("Hora (0-23): ");
      M     : constant Integer := Leer_Entero ("Minutos (0-59): ");
      T     : Turno.Tipoturno;
   begin
      T := Turno.Crear
         (Anio          => Turno.Tipoanio (Anio),
          Mes           => Turno.Tipomes  (Mes),
          Dia           => Turno.Tipodia  (Dia),
          Hora_Minutos  => Turno.Tipohora (H * 60 + M),
          Dni_Paciente  => Dni_P);
      Clinica.Sacar_Turno (C, Dni_M, Dni_P, T);
      Put_Line ("[OK] Turno reservado.");
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
      when Clinica.Paciente_Inexistente =>
         Put_Line ("[ERROR] No existe paciente con ese DNI.");
      when Clinica.Sin_Disponibilidad =>
         Put_Line ("[ERROR] No hay disponibilidad para ese turno.");
      when Constraint_Error | Turno.Fecha_Invalida =>
         Put_Line ("[ERROR] Fecha u hora inválida.");
   end Menu_Sacar_Turno;

   procedure Menu_Cancelar_Turno (C : in out Clinica.Tipoclinica) is
      Dni_M : constant Integer := Leer_Entero ("DNI médico: ");
      Anio  : constant Integer := Leer_Entero ("Año (AAAA): ");
      Mes   : constant Integer := Leer_Entero ("Mes (1-12): ");
      Dia   : constant Integer := Leer_Entero ("Día (1-31): ");
      H     : constant Integer := Leer_Entero ("Hora (0-23): ");
      M     : constant Integer := Leer_Entero ("Minutos (0-59): ");
      T     : Turno.Tipoturno;
   begin
      T := Turno.Por_Fecha_Hora
         (Anio         => Turno.Tipoanio (Anio),
          Mes          => Turno.Tipomes  (Mes),
          Dia          => Turno.Tipodia  (Dia),
          Hora_Minutos => Turno.Tipohora (H * 60 + M));
      Clinica.Cancelar_Turno (C, Dni_M, T);
      Put_Line ("[OK] Turno cancelado.");
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
      when Clinica.Turno_Inexistente =>
         Put_Line ("[ERROR] No existe ese turno en la agenda del médico.");
      when Constraint_Error | Turno.Fecha_Invalida =>
         Put_Line ("[ERROR] Fecha u hora inválida.");
   end Menu_Cancelar_Turno;

   procedure Menu_Disponibles_Por_Esp (C : in Clinica.Tipoclinica) is
      Esp  : constant String  := Leer_Cadena  ("Especialidad: ");
      Anio : constant Integer := Leer_Entero  ("Año (AAAA): ");
      Mes  : constant Integer := Leer_Entero  ("Mes (1-12): ");
      Dia  : constant Integer := Leer_Entero  ("Día (1-31): ");
      N    : Natural;
   begin
      N := Clinica.Disponibles_Por_Especialidad
         (C, Esp,
          Turno.Tipoanio (Anio), Turno.Tipomes (Mes), Turno.Tipodia (Dia));
      Put_Line ("Turnos disponibles para " & Esp & " ese día: " & Natural'Image (N));
   exception
      when Constraint_Error =>
         Put_Line ("[ERROR] Fecha inválida.");
   end Menu_Disponibles_Por_Esp;

   procedure Menu_Listar_Agenda_Medico (C : in Clinica.Tipoclinica) is
      Dni_M : constant Integer := Leer_Entero ("DNI médico: ");
      Modo  : Character;
      Linea : String (1 .. 4);
      L     : Natural;
   begin
      declare
         M : constant Medico.Tipomedico :=
            Clinica.Buscar_Medico_Por_Dni (C, Dni_M);
      begin
         Put_Line ("¿Listar (d)ía o (s)emana?");
         Put ("Opción: ");
         Get_Line (Linea, L);
         if L = 0 then return; end if;
         Modo := Linea (1);
         declare
            Anio : constant Integer := Leer_Entero ("Año (AAAA): ");
            Mes  : constant Integer := Leer_Entero ("Mes (1-12): ");
            Dia  : constant Integer := Leer_Entero ("Día (1-31): ");
         begin
            case Modo is
               when 'd' | 'D' =>
                  Medico.Listar_Turnos_Dia
                     (M, Turno.Tipoanio (Anio),
                      Turno.Tipomes (Mes), Turno.Tipodia (Dia));
               when 's' | 'S' =>
                  Medico.Listar_Turnos_Semana
                     (M, Turno.Tipoanio (Anio),
                      Turno.Tipomes (Mes), Turno.Tipodia (Dia));
               when others =>
                  Put_Line ("Opción no válida.");
            end case;
         end;
      end;
   exception
      when Clinica.Medico_Inexistente =>
         Put_Line ("[ERROR] No existe médico con ese DNI.");
      when Constraint_Error =>
         Put_Line ("[ERROR] Fecha inválida.");
   end Menu_Listar_Agenda_Medico;

end Interfaz;
