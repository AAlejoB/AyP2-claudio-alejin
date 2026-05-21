--ORTEGA ZAHIR

with Ada.Unchecked_Deallocation;
package body Piladinamica is 
   procedure Free is new
      Ada.Unchecked_Deallocation(Tiponodo, Tipopiladinamica);
      
   ---------------------------------------------------------------
   procedure Crearpila (pila:  out TipoPilaDinamica) is
begin
pila:=null;
end crearpila;

--------------------------------------------------------------------      
   function Vacia (Pila: in Tipopiladinamica) return Boolean is 
   begin
      return Pila = null;
   end Vacia;
   
------------------------------------------------------------------
   procedure Meter (Pila: in out Tipopiladinamica; Elemento: in Tipoelem) is
      Nuevonodo: Tipopiladinamica:= new Tiponodo'(Elemento, Pila);
   begin
      Pila:= Nuevonodo;
   end Meter;   
   
------------------------------------------------------------------
  procedure sacar (Pila: in out Tipopiladinamica; Elemento: out Tipoelem) is
      Temp: Tipopiladinamica:= Pila;
   begin
      if Vacia (Pila) then raise Pilavacia;
      else Elemento:= Pila.Info;
         Pila:= Pila.Sig;
         Free (Temp);
      end if;
   end Sacar;
-------------------------------------------------------------------   
   procedure Limpiar (Pila:in out Tipopiladinamica) is
      Temp: Tipopiladinamica:= Pila;
   begin 
      while not Vacia (Pila) loop
         Pila:= Pila.Sig;
         Free (Temp);
         Temp:= Pila;
      end loop;
   end Limpiar;   
-----------------------------------------------------------------

end Piladinamica; 

   
