with Ada.Text_Io;
use ada.Text_IO;
package body Matriz_simple is
   
   procedure Leer_Matriz(Mat:out Tipomat) is
   begin
      for I in fila'range loop
         for J in columna'range loop
            Get(Mat(I,J));
         end loop;
      end loop;
   end Leer_Matriz;
   
   procedure Imprimir_Matriz(Mat: in Tipomat)is
   begin
      for I in fila'range loop
         for J in columna'range loop
            Put(Mat(I,J));
         end loop;
         new_line;
      end loop;
   end Imprimir_Matriz;
   

end matriz_simple;
