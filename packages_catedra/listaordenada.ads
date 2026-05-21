--ORTEGA ZAHIR


generic 
   type Tipoelem is private; 
   with function menor (X, Y: TipoElem) return Boolean;
   with function mayor (X, Y: Tipoelem) return Boolean;
   
   package Listaordenada is 
      type Tipolista is private;
      Procedure Crearlistaordenada (Lista: out tipolista);
      procedure Limpiar (Lista: in out Tipolista);
      function Vacia (Lista: in Tipolista) return Boolean;
      function Esta (Lista: Tipolista; Elemento: Tipoelem) return Boolean;
      function Info (Lista: in Tipolista) return Tipoelem;
      function Sig (Lista: in Tipolista) return Tipolista;
      procedure Insertar (Lista: in out Tipolista; Elemento: in Tipoelem);
      procedure Suprimir (Lista: in out Tipolista; Elemento: in Tipoelem);
      
Listavacia: exception;
      
      private 
      type Tiponodo;
      type Tipolista is access Tiponodo;
      type tiponodo is
         record
         Info: Tipoelem;
         Sig: Tipolista;
      end record;
      
   end Listaordenada; 
   
      
         
      
       
      

      

      
