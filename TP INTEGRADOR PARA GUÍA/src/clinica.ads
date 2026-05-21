-- ============================================================================
-- clinica.ads
-- TAD Clínica.
--
-- Una Clínica tiene:
--   * un nombre
--   * una lista de médicos        (Lista_Ordenada de Tipomedico)
--   * una lista de pacientes      (Lista_Ordenada de Tipopaciente)
--
-- Operaciones requeridas por el enunciado (Clínica 1):
--   ✔ Crear clínica
--   ✔ Agregar / Eliminar / Buscar médico (por nombre o especialidad)
--   ✔ Listar médicos (completo o filtrado por especialidad)
--   ✔ Listar obras sociales admitidas por médico
--   ✔ Buscar turno disponible / Sacar turno / Cancelar turno
--   ✔ Agregar / Eliminar / Buscar paciente
--   ✔ Cantidad de turnos disponibles por especialidad para un día
--   ✔ Persistencia (cargar al inicio, guardar al final)
-- ============================================================================

with Ada.Text_IO;
with Lista_Ordenada;
with Medico;
with Paciente;
with Turno;

package Clinica is

   --------------------------------------------------------------------------
   -- Tipo opaco.
   --------------------------------------------------------------------------
   type Tipoclinica is private;

   --------------------------------------------------------------------------
   -- Excepciones del TAD.
   --------------------------------------------------------------------------
   Medico_Repetido        : exception;
   Medico_Inexistente     : exception;
   Paciente_Repetido      : exception;
   Paciente_Inexistente   : exception;
   Sin_Disponibilidad     : exception;
   Turno_Inexistente      : exception;

   --------------------------------------------------------------------------
   -- CONSTRUCTORES y NOMBRE
   --------------------------------------------------------------------------
   procedure Crear (C : out Tipoclinica; Nombre : in String);
   function  Get_Nombre (C : Tipoclinica) return String;

   --------------------------------------------------------------------------
   -- MÉDICOS
   --------------------------------------------------------------------------
   procedure Agregar_Medico  (C : in out Tipoclinica; M : in Medico.Tipomedico);
   procedure Eliminar_Medico (C : in out Tipoclinica; Dni : in Integer);

   function  Buscar_Medico_Por_Dni
      (C : Tipoclinica; Dni : Integer) return Medico.Tipomedico;
   --  Devuelve una COPIA del médico. Para modificar el médico de la clínica
   --  hay que usar Modificar_Medico (ver patrón Buscar+Suprimir+Insertar
   --  documentado en medico.adb).

   procedure Modificar_Medico (C : in out Tipoclinica;
                               M_Modificado : in Medico.Tipomedico);
   --  Reemplaza el médico de la clínica con mismo DNI por el provisto.
   --  Útil tras modificar atributos (max turnos, OS, agenda).

   procedure Listar_Medicos (C : Tipoclinica);
   procedure Listar_Medicos_Por_Especialidad
      (C : Tipoclinica; Esp : String);
   procedure Buscar_Medico_Por_Nombre (C : Tipoclinica; Nombre_O_Apellido : String);
   procedure Buscar_Medico_Por_Especialidad (C : Tipoclinica; Esp : String);

   procedure Listar_Obras_Sociales_Por_Medico (C : Tipoclinica; Dni : Integer);

   --------------------------------------------------------------------------
   -- PACIENTES
   --------------------------------------------------------------------------
   procedure Agregar_Paciente  (C : in out Tipoclinica; P : in Paciente.Tipopaciente);
   procedure Eliminar_Paciente (C : in out Tipoclinica; Dni : in Integer);

   function  Buscar_Paciente_Por_Dni
      (C : Tipoclinica; Dni : Integer) return Paciente.Tipopaciente;

   procedure Listar_Pacientes (C : Tipoclinica);

   --------------------------------------------------------------------------
   -- TURNOS
   --------------------------------------------------------------------------
   procedure Sacar_Turno (C            : in out Tipoclinica;
                          Dni_Medico   : in Integer;
                          Dni_Paciente : in Integer;
                          T            : in Turno.Tipoturno);
   --  Reserva el turno T en la agenda del médico Dni_Medico, asignándoselo
   --  al paciente Dni_Paciente. Levanta Medico_Inexistente,
   --  Paciente_Inexistente o Sin_Disponibilidad según corresponda.

   procedure Cancelar_Turno (C          : in out Tipoclinica;
                             Dni_Medico : in Integer;
                             T          : in Turno.Tipoturno);

   procedure Buscar_Turno_Disponible
      (C    : Tipoclinica;
       Esp  : in String;
       Anio : Turno.Tipoanio;
       Mes  : Turno.Tipomes;
       Dia  : Turno.Tipodia);
   --  Imprime los médicos de la especialidad indicada que tengan
   --  disponibilidad ese día y cuántos turnos les quedan.

   function Disponibles_Por_Especialidad
      (C : Tipoclinica;
       Esp  : String;
       Anio : Turno.Tipoanio;
       Mes  : Turno.Tipomes;
       Dia  : Turno.Tipodia) return Natural;
   --  Suma la disponibilidad de TODOS los médicos de una especialidad
   --  para un día dado.

   --------------------------------------------------------------------------
   -- PERSISTENCIA
   --------------------------------------------------------------------------
   procedure Guardar_En_Archivo (C : Tipoclinica; Ruta : String);
   procedure Cargar_De_Archivo  (C : in out Tipoclinica; Ruta : String);
   --  Lee/escribe el estado completo (médicos + pacientes) en archivo de
   --  texto. Si el archivo no existe en Cargar, deja la clínica vacía.

private

   --------------------------------------------------------------------------
   -- Instanciaciones internas: lista ordenada de médicos y de pacientes.
   --------------------------------------------------------------------------
   package Lista_Medicos is new Lista_Ordenada
      (Tipoelem => Medico.Tipomedico,
       Menor    => Medico.Menor,
       Mayor    => Medico.Mayor,
       Igual    => Medico.Igual);

   package Lista_Pacientes is new Lista_Ordenada
      (Tipoelem => Paciente.Tipopaciente,
       Menor    => Paciente.Menor,
       Mayor    => Paciente.Mayor,
       Igual    => Paciente.Igual);

   Largo_Nombre_Clinica : constant := 80;

   type Tipoclinica is record
      Nombre      : String (1 .. Largo_Nombre_Clinica) := (others => ' ');
      Long_Nombre : Natural := 0;
      Medicos     : Lista_Medicos.Tipolista;
      Pacientes   : Lista_Pacientes.Tipolista;
   end record;

end Clinica;
