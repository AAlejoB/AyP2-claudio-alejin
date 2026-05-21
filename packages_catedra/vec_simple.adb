with Ada.Text_Io;
use Ada.Text_Io;

package body Vec_simple is
   
   procedure Leer(Vec: out Tipovec) is
   begin
      for I in Indice'First..Indice'Last loop
         Get(Vec(I));
      end loop;
   end Leer;
   
   procedure Imprimir(Vec: in out Tipovec) is
   begin
      for I in Indice'range loop
         Put(Vec(I));
      end loop;
   end Imprimir;
   
   
   
   end Vec_simple;

      