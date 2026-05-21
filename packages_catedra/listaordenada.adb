--ORTEGA ZAHIR




with Ada.Unchecked_Deallocation; 
package body Listaordenada is 
   
   procedure Free is new Ada.Unchecked_Deallocation(Tiponodo,Tipolista);
------------
Procedure Crearlistaordenada (Lista: out tipolista) is 
begin
lista:=null;
end Crearlistaordenada;

--------------------------------------------------------------------------   
   procedure Limpiar (Lista: in out Tipolista) is
      Temp: Tipolista:= Lista;
   begin
      while Lista /= null loop
         Temp:= Lista;
         Lista:= Lista.Sig;
         Free (Temp);
      end loop;
   end Limpiar;
---------------------------------------------------------------------
   function Vacia (Lista: in Tipolista) return Boolean is
   begin 
            return Lista = null;
   end Vacia;   
---------------------------------------------------------------------   
---------------------------------------------------------------------
   function Esta (Lista: Tipolista; Elemento: Tipoelem) return Boolean is
      Ptr: Tipolista:= Lista;
   begin 
      if Vacia (Lista) then return False;
      else while Ptr /= null loop
            if Ptr.Info = Elemento then return True;
            end if;
            Ptr:= Ptr.Sig;
         end loop;
      end if;
      return false;
   end Esta;   
---------------------------------------------------------------------
function Info (Lista: in Tipolista) return Tipoelem is
   begin
      if Lista /= null then return Lista.Info;
      else raise Listavacia;
      end if;
   end Info;
------------------------------------------------------------------------
function Sig (Lista: in TipoLista) return Tipolista is
   begin
      if Vacia(Lista) then raise Listavacia;
      else return Lista.Sig;
      end if;
   end Sig;
 
-------------------------------------------------------------------------
procedure Insertar (lista: in out TipoLista; Elemento: in TipoElem) is
NuevoNodo: TipoLista:=new TipoNodo'(Elemento, null);
Ptr, ant: TipoLista:=null;
   Lugarencontrado: Boolean:=False;
   
begin
   if Vacia(Lista) then 
      Lista:= Nuevonodo;
   elsif menor(Elemento,Lista.Info) then 
      Nuevonodo.Sig:= Lista; 
      Lista:= Nuevonodo; 
   else 
      ptr:=lista;  
         while not Lugarencontrado and Ptr /=null loop
            if mayor(elemento,ptr.info) then
               Ant:= Ptr;
               Ptr:= Ptr.Sig;
         else Lugarencontrado:= True; 
         end if;
         end loop;
         Nuevonodo.Sig:= Ptr;
      if Ant=null then 
         Lista:=Nuevonodo;
      else 
         Ant.Sig:=Nuevonodo;      
         end if;
      end if;
   
   end Insertar;
--------------------------------------------------------------------------------------
procedure Suprimir (Lista: in out TipoLista; Elemento: in TipoElem) is
actual: TipoLista:= Lista;
   Ant: Tipolista:= null;
begin 
   while Actual /=null and then menor(Actual.Info,elemento) loop
      Ant:= Actual;
      Actual:= Actual.Sig;
   end loop;
   if Ant= null then 
      Lista:= Lista.Sig; 
   else
       Ant.Sig:= Actual.Sig; 
   end if;
   
      Free (Actual);
   end Suprimir;
--------------------------------------------------------------------------------------
   
end Listaordenada; 

