generic
   type Tipoelem is private;
package Listanoordenada is

   type Tipolista is private;
   Listavacia : exception;

   procedure Crearlista     (Lista : out Tipolista);
   procedure Limpiar        (Lista : in out Tipolista);
   function  Vacia          (Lista : in Tipolista) return Boolean;
   function  Esta           (Lista : Tipolista; Elemento : Tipoelem) return Boolean;
   function  Info           (Lista : in Tipolista) return Tipoelem;
   function  Sig            (Lista : in Tipolista) return Tipolista;

   procedure InsertarPpio   (Lista : in out Tipolista; Elemento : in Tipoelem);
   procedure InsertarFin    (Lista : in out Tipolista; Elemento : in Tipoelem);

   --  Suprime la primera ocurrencia de Elemento (si existe).
   procedure Suprimir       (Lista : in out Tipolista; Elemento : in Tipoelem);

private
   type Tiponodo;
   type Tipolista is access Tiponodo;
   type Tiponodo is record
      Info : Tipoelem;
      Sig  : Tipolista;
   end record;
end Listanoordenada;
