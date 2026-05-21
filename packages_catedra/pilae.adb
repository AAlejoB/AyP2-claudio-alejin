package body Pilae is 
   procedure Limpiar(Pila:in out Tipopila) is 
   begin
      Pila.Cabeza:=0;
      end Limpiar;
      
   function Vacia (Pila:in Tipopila) return Boolean is 
   begin 
      return Pila.Cabeza=0;
   end Vacia;
   
   function Llena(Pila:in Tipopila) return Boolean is 
   begin
      return Pila.Cabeza=Pila.Max;
   end Llena;
   
   procedure Meter(Pila:in out Tipopila; Nuevoelemento:in Tipoelemento) is
   begin
      if not Llena(Pila) then Pila.Cabeza:=Pila.Cabeza+1;
         Pila.Elementos(Pila.Cabeza):=Nuevoelemento;
      else raise Overflow;
      end if;
   end Meter;
 
   procedure Sacar(Pila:in out Tipopila; Elementosacado: out Tipoelemento) is 
   begin
      if not Vacia(Pila) then Elementosacado:=Pila.Elementos(Pila.Cabeza);
         Pila.Cabeza:=Pila.Cabeza-1;
      else raise Underflow;
      end if;
   end Sacar;
   
end Pilae;

      
