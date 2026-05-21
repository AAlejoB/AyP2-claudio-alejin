-- ============================================================================
-- interfaz.ads
-- Capa de interfaz de usuario por consola.
--
-- Su única responsabilidad es leer/imprimir cosas: NO contiene lógica de
-- negocio. Toda la lógica vive en los TAD (Clinica, Medico, Paciente,
-- Turno). Esto sigue el patrón del ejemplo de la cátedra (ver
-- ejemplo_tf_extraido/interfaz.ads).
-- ============================================================================

with Clinica;

package Interfaz is

   procedure Mostrar_Menu;
   function Leer_Opcion return Character;

   procedure Menu_Alta_Medico        (C : in out Clinica.Tipoclinica);
   procedure Menu_Baja_Medico        (C : in out Clinica.Tipoclinica);
   procedure Menu_Buscar_Medico      (C : in     Clinica.Tipoclinica);
   procedure Menu_Listar_Medicos     (C : in     Clinica.Tipoclinica);
   procedure Menu_Listar_OS_Medico   (C : in     Clinica.Tipoclinica);
   procedure Menu_Agregar_OS_Medico  (C : in out Clinica.Tipoclinica);
   procedure Menu_Modificar_Max_Turnos (C : in out Clinica.Tipoclinica);

   procedure Menu_Alta_Paciente      (C : in out Clinica.Tipoclinica);
   procedure Menu_Baja_Paciente      (C : in out Clinica.Tipoclinica);
   procedure Menu_Buscar_Paciente    (C : in     Clinica.Tipoclinica);
   procedure Menu_Listar_Pacientes   (C : in     Clinica.Tipoclinica);

   procedure Menu_Buscar_Turno_Disp  (C : in     Clinica.Tipoclinica);
   procedure Menu_Sacar_Turno        (C : in out Clinica.Tipoclinica);
   procedure Menu_Cancelar_Turno     (C : in out Clinica.Tipoclinica);
   procedure Menu_Disponibles_Por_Esp (C : in     Clinica.Tipoclinica);
   procedure Menu_Listar_Agenda_Medico (C : in   Clinica.Tipoclinica);

end Interfaz;
