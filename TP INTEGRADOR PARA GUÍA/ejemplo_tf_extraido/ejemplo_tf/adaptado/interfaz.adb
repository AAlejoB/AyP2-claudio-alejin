with ada.Text_IO, materias;
use ada.Text_IO, materias;
package body Interfaz is
   
   function interfazOpciones return Character is
      elijo: character:='1';
   begin
      Put_Line("Alumnos: menú principal.");
      Put_Line("");
      Put_Line("Elija opción: ");
      Put_Line("1. Alta de alumno");
      Put_Line("2. Modificar datos de un alumno");
      Put_Line("3. Baja de alumno");
      Put_Line("4. Ver los alumnos");
      Put_Line("5. Alta de materia para un alumno");
      Put_Line("6. Modificar promedio de una materia para un alumno");
      Put_Line("7. Baja de una materia en un alumno");
      Put_Line("8. Ver promedios de un alumno");
      put_line("9. Ver el promedio de una materia en todos los alumnos");
put_line("g. Guardar y salir");
      Put_Line("s. Salir sin guardar");
      --etc
      return elijo;--valor de onda
      end interfazopciones;

procedure Interfazaltaalumno(A: in out Talumnos) is
   alu:talumno;
begin
      new_line;
      Put_Line("se Agrega un alumno..");
      Altaalumno(A, Alu);    
      
      end interfazaltaalumno;

   procedure Interfazbajaalumno(A: in out Talumnos) is
         alu:talumno;
   begin
         new_line;
            Put_Line("se baja un alumno..");
            bajaalumno(a, alu);
      end interfazbajaalumno;

end Interfaz;

