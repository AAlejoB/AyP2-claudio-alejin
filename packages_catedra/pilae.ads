generic
   type Tipoelemento is private;
   package Pilae is 
      type Tipopila (Max:Positive) is private;
      Underflow,Overflow:exception;
      procedure Limpiar(Pila:in out Tipopila);
      function Vacia(Pila:in Tipopila) return Boolean;
      function Llena(Pila:in Tipopila) return Boolean;
      procedure Meter(Pila:in out Tipopila; Nuevoelemento:in Tipoelemento);
      procedure Sacar(Pila:in out Tipopila; Elementosacado:out Tipoelemento);
      private
      type Arreglopila is array (Positive range <>) of Tipoelemento;
      type Tipopila(Max:Positive) is 
      record
         Cabeza:Natural:=0;
         Elementos:Arreglopila(1..Max);
      end record;
   end Pilae;
   
      
