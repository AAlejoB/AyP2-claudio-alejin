with Interfaz, alumnos;
use interfaz, alumnos;
procedure ejemplo is--programa muyy basico, solo de ejemplo..

   A: Talumnos;
   opcion: character;

begin
   --deberia haber un loop, para que no termine el programa hasta que el usuario final quiera salir
cargarinfo(a);   --carga informacion de alumnos, desde un archivo...
      Opcion := Interfazopciones;
      if Opcion='1' then
         Interfazaltaalumno(A);
      elsif Opcion='2' then
         Interfazbajaalumno(A);
--         ##etc
--            ##
         end if;
 end ejemplo;
