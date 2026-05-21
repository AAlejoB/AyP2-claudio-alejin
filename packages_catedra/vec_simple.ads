--Ortega Zahir
generic
   type Tipodato is private;
   type Indice is (<>);
   
   with procedure Put(X:in Tipodato);
   with procedure Get(X: out Tipodato);
   
    
package Vec_simple is
   type Tipovec is array (Indice) of Tipodato;
   procedure Leer(vec: out tipovec);
   procedure Imprimir(Vec: in out Tipovec);
   end Vec_simple;
   
   
