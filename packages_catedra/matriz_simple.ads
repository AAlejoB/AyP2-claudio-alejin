generic 
   type Tipodato is private;
   type fila is (<>);
   type columna is (<>);
   with procedure Put (X: in Tipodato);
   with procedure Get (X: out Tipodato);
   
   package Matriz_Simple is
      type Tipomat is array (fila,columna) of Tipodato;
      procedure Leer_Matriz (Mat: out Tipomat);
      procedure Imprimir_Matriz(Mat: in Tipomat);
   end Matriz_Simple;
   
