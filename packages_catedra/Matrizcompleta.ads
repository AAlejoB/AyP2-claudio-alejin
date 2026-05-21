generic
   type Tipodato is private;
   type Fila is (<>);
   type Columna is (<>);
   with procedure Put (X:in Tipodato);
   With procedure Get (X:out Tipodato);
   with function "+" (X,Y:Tipodato) return Tipodato;
   with function ">" (A,B:Tipodato) return Boolean;
   package Matrizcompleta is 
      type Tmat is Array (Fila,Columna) of  Tipodato;
      type tmat_t is array (columna,fila) of tipodato;
      procedure Leer (Mat: out Tmat);
      procedure Imprimir (Mat:in Tmat);
      procedure Get_Dato(Dato:out Tipodato);
      function Comparar (Mat,Matb:Tmat; Porc: Float) return Boolean;
      procedure Ordenamiento (Mat:in out Tmat; Col:in Columna);
      procedure Busqueda (Mat:In Tmat; Elemento: in Tipodato; Encontrado: out Boolean;Posif: out Fila; Posic: out Columna);
      procedure Traspuesta (Mat:in Tmat; Mat_T:out Tmat_T);
      procedure Imprimir_T(Mat:in Tmat_T);
      
   end MatrizCompleta;
   
      
      
      
      
      
   
