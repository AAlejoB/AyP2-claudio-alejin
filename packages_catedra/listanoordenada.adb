with Ada.Unchecked_Deallocation;
package body Listanoordenada is

   procedure Free is new Ada.Unchecked_Deallocation (Tiponodo, Tipolista);

   procedure Crearlista (Lista : out Tipolista) is
   begin
      Lista := null;
   end Crearlista;

   procedure Limpiar (Lista : in out Tipolista) is
      Tmp : Tipolista := Lista;
   begin
      while Lista /= null loop
         Lista := Lista.Sig;
         Free (Tmp);
         Tmp := Lista;
      end loop;
   end Limpiar;

   function Vacia (Lista : in Tipolista) return Boolean is
   begin
      return Lista = null;
   end Vacia;

   function Esta (Lista : Tipolista; Elemento : Tipoelem) return Boolean is
      Ptr : Tipolista := Lista;
   begin
      while Ptr /= null loop
         if Ptr.Info = Elemento then return True; end if;
         Ptr := Ptr.Sig;
      end loop;
      return False;
   end Esta;

   function Info (Lista : in Tipolista) return Tipoelem is
   begin
      if Vacia (Lista) then raise Listavacia; end if;
      return Lista.Info;
   end Info;

   function Sig (Lista : in Tipolista) return Tipolista is
   begin
      if Vacia (Lista) then raise Listavacia; end if;
      return Lista.Sig;
   end Sig;

   procedure InsertarPpio (Lista : in out Tipolista; Elemento : in Tipoelem) is
   begin
      Lista := new Tiponodo'(Elemento, Lista);
   end InsertarPpio;

   procedure InsertarFin (Lista : in out Tipolista; Elemento : in Tipoelem) is
      Nuevo : Tipolista := new Tiponodo'(Elemento, null);
      Ptr   : Tipolista;
   begin
      if Lista = null then
         Lista := Nuevo;
      else
         Ptr := Lista;
         while Ptr.Sig /= null loop Ptr := Ptr.Sig; end loop;
         Ptr.Sig := Nuevo;
      end if;
   end InsertarFin;

   procedure Suprimir (Lista : in out Tipolista; Elemento : in Tipoelem) is
      Ant, Ptr : Tipolista;
   begin
      if Vacia (Lista) then raise Listavacia; end if;
      if Lista.Info = Elemento then
         Ptr := Lista; Lista := Lista.Sig; Free (Ptr); return;
      end if;
      Ant := Lista; Ptr := Lista.Sig;
      while Ptr /= null loop
         if Ptr.Info = Elemento then
            Ant.Sig := Ptr.Sig; Free (Ptr); return;
         end if;
         Ant := Ptr; Ptr := Ptr.Sig;
      end loop;
   end Suprimir;

end Listanoordenada;
