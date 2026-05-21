with ada.Text_IO;
use ada.Text_IO;
package body Alumnos is
   procedure Altaalumno(A: in out Talumnos; Elem: Talumno) is
   begin
if esta(a, elem) then
raise alumno_repetido;
else
insertar(a, elem);--este insertar es el de la lista ordenada..
end if;
      end altaalumno;
      procedure BAJAalumno(A: IN OUT Talumnos; Elem: Talumno) is
begin
if not esta(a, elem) then
raise alumno_inexistente;
else
suprimir(a, elem);
end if;
end bajaalumno;

procedure Guardarinfo(A: Talumnos) is--deberia guardar la informacion en un archivo
begin
      new_line;
   put("se guardo la informacion en un archivo...");
   
   end guardarinfo;

procedure Cargarinfo(A: in out Talumnos) is
begin
   new_line;
   put("se cargo la informacion del archivo alumno...");
   end cargarinfo;
   --##
   --etc
   --##
   
--##aca definimos lo que quedo pendiente del ads
--Menor(X, Y: Talumno) return Boolean;
--Mayor(X, Y: Talumno) return Boolean;
--Igual(X, Y: Talumno) return Boolean;

function Menor(X, Y: Talumno) return Boolean is
begin
   return x.Dni < y.dni;
      end Menor;
      
      function Mayor(X, Y: Talumno) return Boolean is
      begin
         return x.Dni > y.dni;
         end mayor;

      function Igual(X, Y: Talumno) return Boolean is
      begin
         return x.dni = y.dni;
      end Igual;
      
end Alumnos;

