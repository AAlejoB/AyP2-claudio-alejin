-- ============================================================================
-- gestion_clinica.adb
-- PROCEDIMIENTO PRINCIPAL del integrador.
--
-- Estructura del programa:
--   1. Crea una Clínica vacía y le da un nombre.
--   2. Intenta cargar el estado previo desde "data/clinica.txt".
--   3. Loop infinito: muestra menú, lee opción, ejecuta. Sale con 'g' (graba)
--      o 's' (sin grabar).
--
-- Decisión: la persistencia funciona del lado del TAD Clínica
-- (Cargar_De_Archivo / Guardar_En_Archivo); este main solo orquesta.
-- Las opciones del menú son letras (a..p) para evitar la ambigüedad
-- entre '1' y '10' al leer un único carácter.
-- ============================================================================

with Ada.Text_IO;  use Ada.Text_IO;
with Clinica;
with Interfaz;

procedure Gestion_Clinica is
   C       : Clinica.Tipoclinica;
   Op      : Character;
   Salir   : Boolean := False;
   Ruta    : constant String := "data/clinica.txt";
begin
   Clinica.Crear (C, "Clínica Integrador AyP II");
   Clinica.Cargar_De_Archivo (C, Ruta);
   Put_Line ("Estado cargado (si existía) desde: " & Ruta);

   while not Salir loop
      Interfaz.Mostrar_Menu;
      Op := Interfaz.Leer_Opcion;

      case Op is
         when 'a' => Interfaz.Menu_Alta_Medico         (C);
         when 'b' => Interfaz.Menu_Baja_Medico         (C);
         when 'c' => Interfaz.Menu_Buscar_Medico       (C);
         when 'd' => Interfaz.Menu_Listar_Medicos      (C);
         when 'e' => Interfaz.Menu_Listar_OS_Medico    (C);
         when 'f' => Interfaz.Menu_Agregar_OS_Medico   (C);
         when 'h' => Interfaz.Menu_Modificar_Max_Turnos (C);

         when 'i' => Interfaz.Menu_Alta_Paciente       (C);
         when 'j' => Interfaz.Menu_Baja_Paciente       (C);
         when 'k' => Interfaz.Menu_Buscar_Paciente     (C);
         when 'l' => Interfaz.Menu_Listar_Pacientes    (C);

         when 'm' => Interfaz.Menu_Buscar_Turno_Disp   (C);
         when 'n' => Interfaz.Menu_Sacar_Turno         (C);
         when 'o' => Interfaz.Menu_Cancelar_Turno      (C);
         when 'p' => Interfaz.Menu_Disponibles_Por_Esp (C);
         when 'q' => Interfaz.Menu_Listar_Agenda_Medico (C);

         when 'g' | 'G' =>
            Clinica.Guardar_En_Archivo (C, Ruta);
            Put_Line ("Estado guardado en " & Ruta & ". ¡Hasta luego!");
            Salir := True;

         when 's' | 'S' =>
            Put_Line ("Saliendo SIN guardar.");
            Salir := True;

         when others =>
            Put_Line ("Opción no reconocida.");
      end case;
   end loop;
end Gestion_Clinica;
