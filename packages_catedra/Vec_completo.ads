-- ORTEGA ZAHIR
generic
   type Tipodato is private;
   type Indice is (<>);
   Valorinicial: Tipodato;
   with procedure Put(X:in Tipodato);
   with procedure Get(X: out Tipodato);
   with function "+" (A,B:Tipodato) return Tipodato;
   with function "*" (A,B:Tipodato) return Tipodato;
   with function Raiz(A: Tipodato) return float;
   with function mayor(X,Y: in Tipodato) return boolean;   
 
package Vec_completo is
   type Tipovec is array(Indice) of Tipodato;
   procedure Leer(vec: out tipovec);
   procedure Imprimir(Vec: in Tipovec);
   
   function Comparacion(vec1,vec2:in tipovec) return boolean;
   procedure Ordenamiento(vec: in out tipovec);
   procedure Busqueda(vec: in tipovec; dato: in tipodato; encontrado:out boolean; pos:out indice);
end Vec_completo;
   
   
