
with Ada.Text_Io;
use ada.Text_IO;

package body Matrizcompleta is

   procedure Leer (
         Mat :    out Tmat) is
   begin
      for I in Fila'range loop
         for J in Columna'range loop
            Get(Mat(I,J));
         end loop;
      end loop;
   end Leer;

   procedure Imprimir (
         Mat : in     Tmat) is
   begin
      for I in Fila'range loop
         for J in Columna'range loop
            Put(Mat(I,J));
            
         end loop;
new_line;
      end loop;
   end Imprimir;

   procedure Get_Dato (
         Dato :    out Tipodato) is
   begin
      Get(Dato);
   end Get_Dato;

   function Comparar (
         Mat,
         Matb : Tmat;
         Porc : Float)
     return Boolean is
      Cuentamayores : Integer := 0;
      Cuentaposi    : Integer := 0;

   begin
      for I in Fila'range loop
         for J in Columna'range loop
            Cuentaposi:=Cuentaposi + 1;
            if Mat(I,J) > Matb(I,J) then
               Cuentamayores:= Cuentamayores+1;
            end if;
         end loop;
      end loop;
      if Float(Cuentamayores)/Float(Cuentaposi) > Porc then
         return True;
      else
         return False;
      end if;
   end Comparar;


   procedure Ordenamiento (
         Mat : in out Tmat;
         Col : in     Columna) is

      Hubo_Intercambio : Boolean;
      Auxmat           : Tipodato;
   begin
      for P in Fila'First..Fila'Pred(Fila'Last) loop
         Hubo_Intercambio:=False;
         --bucle interno--
         for I in Fila'First..Fila'Pred(Fila'Last) loop
            if Mat(I,Col) > Mat(Fila'Succ(I),Col) then


               for J in Columna'range loop
                  Auxmat:=Mat(I,J);
                  Mat(I,J):=Mat(Fila'Succ(I),J);
                  Mat(Fila'Succ(I),J):=Auxmat;
               end loop;
               Hubo_Intercambio:=True;

            end if;
         end loop;
         exit when not Hubo_Intercambio;
      end loop;
   end Ordenamiento;

   procedure Busqueda (
         Mat        : in     Tmat;
         Elemento   : in     Tipodato;
         Encontrado :    out Boolean;
         Posif      :    out Fila;
         Posic      :    out Columna) is
   begin
      Encontrado:=False;
      Bucle_Filas:
         for I in Fila'range loop
         for J in Columna'range loop
            if Mat(I,J)= Elemento then
               Encontrado:= True;
               Posif:=I;
               Posic:=J;
               exit Bucle_Filas;
            end if;
         end loop;
      end loop Bucle_Filas;
   end Busqueda;

   procedure Traspuesta (
         Mat   : in     Tmat;
         Mat_T :    out Tmat_T) is
   begin
      for I in Fila'range loop
         for J in Columna'range loop
            Mat_T(J,I):=Mat(I,J);
         end loop;
      end loop;
   end Traspuesta;

   procedure Imprimir_T (
         Mat : in     Tmat_T) is
   begin
      for I in Columna'range loop
         for J in Fila'range loop
            Put(Mat(I,J));
         end loop;
         New_Line;
      end loop;
   end Imprimir_T;



end Matrizcompleta;
      
               
               

    
      
