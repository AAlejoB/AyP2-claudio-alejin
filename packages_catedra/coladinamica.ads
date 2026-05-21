--ORTEGA ZAHIR

generic
   type Tipoelem is private;
   package Coladinamica is 
      
   Colavacia:exception;   
   type Tipocoladinamica is private;
   procedure crearcola(cola:out tipocoladinamica);
   function Vacia (Cola: in Tipocoladinamica) return Boolean;
   procedure Inscola (Cola:in out Tipocoladinamica; Elemento: in Tipoelem);
   procedure Supcola (Cola:in out Tipocoladinamica; Elemento: out Tipoelem);
   procedure Limpiar (Cola: in out Tipocoladinamica);
   
   private 
      
   type Tiponodo;
   type Tipopun is access Tiponodo;
   type TipoNodo is
   record
      Info: Tipoelem;
      Sig: Tipopun;
   end record;
   type Tipocoladinamica is 
   record
      Frente, Final: Tipopun;
   end record;
   

   
   

   
end Coladinamica; 
 
   

