with Materias, lista_ordenada;--deben agregar el paquete de lista ordenada
use materias;
package Alumnos is
   type Talumno is private;
   type Talumnos is private;--mas abajo defino Talumnos..
alumno_repetido, alumno_inexistente: exception;--se tiene que atrapar la excepcion en algun lado...when alumno_repetido => 

   procedure Altaalumno(A: IN OUT Talumnos; Elem: Talumno); --da de alta un alumno nuevo.
   procedure Bajaalumno(A: in out Talumnos; Elem: Talumno); --da de alta un alumno nuevo.
   --##
   --etc
   --##
      procedure Guardarinfo(A: Talumnos);--deberia guardar la informacion en un archivo
      procedure cargarInfo(a: in out talumnos);
   
   private
   type Talumno is record
      Dni: Integer;
      Nombre: Cadena50;
      longnom: positive;
      Apellido: Cadena50;
      Longape: Positive;
      Materias: Tmaterias;
end record;      
function Menor(X, Y: Talumno) return Boolean;--lo defino en el adb..
function Mayor(X, Y: Talumno) return Boolean;--lo defino en el adb..
function Igual(X, Y: Talumno) return Boolean;--lo defino en el adb..


package Lisalu is new Lista_Ordenada(Talumno, Menor, Mayor, Igual);--esta instanciacion depende de su paquete...
use Lisalu;
type Talumnos is new tipolista;


end Alumnos;
