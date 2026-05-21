--ORTEGA ZAHIR

with Ada.Unchecked_Deallocation;

package body Coladinamica is
   
   procedure Free is new Ada.Unchecked_Deallocation(Tiponodo,Tipopun);
------------------------------------------------------------------------------ 
procedure CrearCola(Cola: out Tipocoladinamica) is
begin
   Cola.Frente := null;
   Cola.Final := null;
end Crearcola;
---------------------------------------------------------------  
   function Vacia (Cola: in Tipocoladinamica) return Boolean is
   begin
            return Cola.Frente = null;
   end Vacia;
------------------------------------------------------------------------------   -
----------------------------------------------------------------------------------
   
   procedure Inscola (Cola:in out Tipocoladinamica; Elemento: in Tipoelem) is
      Nuevonodo: Tipopun:= new Tiponodo'(Elemento, null);
   begin
      if Vacia (Cola) then Cola.Frente:= Nuevonodo;
      else Cola.Final.Sig:= Nuevonodo;
      end if;
      Cola.Final:= Nuevonodo; 
   end Inscola; 
   
-----------------------------------------------------------------------------   
   procedure Supcola (Cola:in out Tipocoladinamica; Elemento: out Tipoelem) is
      Temp: Tipopun:= Cola.Frente;
   begin
      if Vacia (Cola) then raise ColaVacia;
      else Elemento:= Cola.Frente.Info;
         Cola.Frente:= Cola.Frente.Sig; 
      end if;
      
      
      if Cola.Frente = null then Cola.Final:= null; 
      end if;
      
         Free (Temp);
   end Supcola;
-----------------------------------------------------------------------------
procedure limpiar (cola: in out tipocoladinamica) is
   temp: tipopun := cola.frente;
begin
   while not vacia(cola) loop
      cola.frente := cola.frente.sig;
      if cola.frente = null then
         cola.final := null;
      end if;
      free(temp);
      temp := cola.frente;
   end loop;
end Limpiar;
-----------------------------------------------------------------------------
   
end Coladinamica;

         
         
