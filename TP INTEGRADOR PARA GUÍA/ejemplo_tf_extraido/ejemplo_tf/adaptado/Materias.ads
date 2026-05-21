with lista_ordenada;
package Materias is
   subtype cadena50 is string(1..50);
   type Tmateria is private;
   type tMaterias is private;--mas abajo defino TMaterias..
Materia_Repetida: exception; --si se intenta agregar dos veces la misma materia.
   materia_inexistente: exception; --si se quiere suprimir una materia que no esta.

   procedure Altamateria(M: in out tMaterias; elem: tMateria); --agrega una materia
      procedure bajaMateria(m: in out tMaterias; elem: tMateria); --quita una materia del alumno.
   --##
   --etc
   --##
         procedure Guardarinfo(M: Tmaterias; Creararchivo: Boolean); --deberia guardar la informacion en un archivo
         procedure cargarinfo(m: out tmaterias); 


            

private
      type Tmateria is record
      Nombre: Cadena50;
      long: positive;
      Promedio: Float;
      end record;

function Menor(X, Y: Tmateria) return Boolean;--lo defino en el adb..
function Mayor(X, Y: Tmateria) return Boolean;--lo defino en el adb..
function Igual(X, Y: Tmateria) return Boolean;--lo defino en el adb..


package Lismat is new Lista_Ordenada(Tmateria, Menor, Mayor, Igual);--esta instanciacion depende de su paquete...

use Lismat;

type tMaterias is new tipolista;

  

end materias;
