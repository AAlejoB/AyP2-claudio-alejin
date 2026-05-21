--ORTEGA ZAHIR



package body Vec_completo is
   
   procedure Leer(Vec: out Tipovec) is
   begin
      for I in Indice'range loop
         Get(Vec(I));
      end loop;
   end Leer;
   
   procedure Imprimir(Vec: in Tipovec) is
   begin
      for I in Indice'range loop
         Put(Vec(I));
      end loop;
   end Imprimir;
    
   
   function Comparacion(Vec1,Vec2: in Tipovec) return Boolean is
      Aux_Uno,Aux_Dos: Tipodato:= Valorinicial;
      Norma1,Norma2:Float;
   
   begin
      for I in Indice'range loop
         Aux_Uno:="+"(Aux_Uno, "*"(Vec1(I),vec1(i)));
         Aux_Dos:="+"(Aux_Dos, "*"(Vec2(I),vec2(i)));
      end loop;
      
      Norma1:=Raiz(Aux_Uno);
      Norma2:=Raiz(Aux_Dos);
      
     return norma1=norma2;
      
end comparacion;
      


  
   
   procedure Ordenamiento(Vec: in out Tipovec) is
      Aux: Tipodato;
   begin
      for I in Indice'range loop
         for J in Indice'First..Indice'Pred(Indice'Last) loop
            if mayor(vec(J),Vec(indice'succ(J))) then
               aux:=vec(j);
               Vec(J):=Vec(indice'succ(J));
               Vec(indice'succ(J)):=Aux;
            end if;
         end loop;
      end loop;
   end Ordenamiento;
         
   procedure Busqueda(Vec: Tipovec; Dato: Tipodato; Encontrado:out Boolean; Pos:out Indice) is
      begin
         Encontrado:=False;
         for I in Indice'range loop
         if Dato=Vec(I) then
            Encontrado:=True;
            Pos:=I;
            return;
         end if;
      end loop;
      
   end Busqueda;
   
   
 end Vec_completo;

               
        
      
