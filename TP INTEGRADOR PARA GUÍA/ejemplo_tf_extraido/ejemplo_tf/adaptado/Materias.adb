with ada.Text_IO,ada.Characters.Handling;--se llaman los paquetes que hagan falta..
use ada.Text_IO,ada.Characters.Handling;
package body Materias is
   
   procedure Altamateria(M: in out Tmaterias; Elem: Tmateria) is
      
   begin
      if not Esta(M, Elem) then
         Insertar(M, Elem);--este insertar es el de la lista ordenada..
      else
         raise materia_repetida;
         end if;      
   end Altamateria;
   
   procedure Bajamateria(M: in out Tmaterias; Elem: Tmateria) is
   begin
      if not Esta(M, Elem) then
         raise Materia_Inexistente;
      else
         suprimir(m, elem);
         end if;
      end       bajamateria;
   --##
   --etc
   --##
      procedure guardarinfo(M: Tmaterias; Creararchivo: Boolean) is--deberia guardar la informacion en un archivo
      begin
            new_line;
      put("se guardo materias en un archivo");
    end Guardarinfo;
   
   procedure cargarinfo(M: out Tmaterias) is
   begin
         new_line;
      put("se cargo el archivo materias");
   end Cargarinfo;
   
--##aca definimos lo que quedo pendiente del ads
--Menor(X, Y: Tmateria) return Boolean;
--Mayor(X, Y: Tmateria) return Boolean;
--Igual(X, Y: Tmateria) return Boolean;

   function Menor(X, Y: Tmateria) return Boolean is    
   begin
      return x.nombre < y.nombre;
   end Menor;
   
   function Mayor(X, Y: Tmateria) return Boolean is
   begin
      return x.nombre>y.nombre;
   end Mayor;
   
   function Igual(X, Y: Tmateria) return Boolean is
   begin
      return X.Long=Y.Long and then to_upper(X.Nombre(1..X.Long)) = to_upper(Y.Nombre(1..Y.Long));
      --esta comparacion esta mejor que las anteriores...
      end igual;


   
end materias;
