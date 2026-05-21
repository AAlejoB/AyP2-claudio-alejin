--ORTEGA ZAHIR

generic
   type Tipoelem is private;
package Piladinamica is
   
      
      Pilavacia:exception;
      type Tipopiladinamica is private;
      
      procedure Crearpila (pila: out tipopilaDinamica);
      function Vacia (Pila: in Tipopiladinamica) return Boolean; 
      procedure Meter (Pila: in out Tipopiladinamica; Elemento: in Tipoelem);
      procedure sacar (Pila: in out Tipopiladinamica; Elemento: out Tipoelem);
      procedure Limpiar (Pila: in out Tipopiladinamica);
      
      
      
      private 
      type TipoNodo;
      type TipoPiladinamica is access TipoNodo;
      type TipoNodo is
      record
         Info: TipoElem;
         Sig: TipoPiladinamica;
      end record;
         
      
         
    
   end Piladinamica;
   

         
         
         
      


