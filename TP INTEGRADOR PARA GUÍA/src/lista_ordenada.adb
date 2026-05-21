-- ============================================================================
-- lista_ordenada.adb
-- Implementación del package genérico Lista_Ordenada.
--
-- PASO A PASO de las decisiones clave:
--   1. Usamos "Ada.Unchecked_Deallocation" para liberar manualmente la memoria
--      reservada con "new". Es un genérico de la librería estándar; al
--      instanciarlo creamos un procedimiento "Free" para nuestro tipo nodo.
--   2. Insertar mantiene el invariante: "lista ordenada de menor a mayor".
--      → Si la lista está vacía, el nuevo nodo queda solo.
--      → Si el nuevo elemento es menor que la cabeza, se inserta al principio.
--      → Si ya hay un elemento Igual, no se inserta (evita duplicados).
--      → En otro caso, se busca la posición y se enlaza entre Ant y Ptr.
--   3. Suprimir recorre buscando un Igual y, cuando lo encuentra, ajusta los
--      punteros para sacarlo y libera el nodo.
-- ============================================================================

with Ada.Unchecked_Deallocation;

package body Lista_Ordenada is

   ---------------------------------------------------------------------------
   -- INSTANCIACIÓN DE Ada.Unchecked_Deallocation
   --
   -- "new Ada.Unchecked_Deallocation(...)" instancia el genérico de la stdlib
   -- y nos da un procedimiento "Free" para liberar nodos de Tiponodo.
   -- Lo usamos en Limpiar y Suprimir.
   ---------------------------------------------------------------------------
   procedure Free is new Ada.Unchecked_Deallocation
      (Object => Tiponodo, Name => Tipolista);

   ---------------------------------------------------------------------------
   procedure Crear (Lista: out Tipolista) is
   begin
      Lista := null;  -- "null" es el puntero "no apunta a nada".
   end Crear;

   ---------------------------------------------------------------------------
   procedure Limpiar (Lista: in out Tipolista) is
      Temp : Tipolista;
   begin
      -- Recorrido clásico: vamos avanzando y liberando nodo por nodo.
      while Lista /= null loop
         Temp  := Lista;
         Lista := Lista.Sig;
         Free (Temp);
      end loop;
   end Limpiar;

   ---------------------------------------------------------------------------
   function Vacia (Lista: in Tipolista) return Boolean is
   begin
      return Lista = null;
   end Vacia;

   ---------------------------------------------------------------------------
   function Esta (Lista: in Tipolista; Elemento: in Tipoelem) return Boolean is
      Ptr : Tipolista := Lista;
   begin
      while Ptr /= null loop
         -- Igual lo aporta quien instancia el package. Para Médico/Paciente
         -- típicamente compara por DNI; para Turno por fecha+hora+médico, etc.
         if Igual (Ptr.Info, Elemento) then
            return True;
         end if;
         -- Optimización: como la lista está ORDENADA, si el elemento actual
         -- ya es Mayor que el buscado, no tiene sentido seguir.
         exit when Mayor (Ptr.Info, Elemento);
         Ptr := Ptr.Sig;
      end loop;
      return False;
   end Esta;

   ---------------------------------------------------------------------------
   function Info (Lista: in Tipolista) return Tipoelem is
   begin
      if Lista = null then
         raise Listavacia;
      end if;
      return Lista.Info;
   end Info;

   ---------------------------------------------------------------------------
   function Sig (Lista: in Tipolista) return Tipolista is
   begin
      if Lista = null then
         raise Listavacia;
      end if;
      return Lista.Sig;
   end Sig;

   ---------------------------------------------------------------------------
   procedure Insertar (Lista: in out Tipolista; Elemento: in Tipoelem) is
      -- "new Tiponodo'(...)" reserva memoria en el heap y devuelve el puntero
      -- al nuevo nodo, ya inicializado con la "aggregate notation".
      Nuevo : Tipolista := new Tiponodo'(Elemento, null);
      Ptr   : Tipolista := Lista;
      Ant   : Tipolista := null;
   begin
      -- Caso 1: lista vacía → el nuevo nodo es la cabeza.
      if Lista = null then
         Lista := Nuevo;
         return;
      end if;

      -- Caso 2: el elemento va al principio (es menor que la cabeza).
      if Menor (Elemento, Lista.Info) then
         Nuevo.Sig := Lista;
         Lista     := Nuevo;
         return;
      end if;

      -- Caso 3: avanzar mientras el elemento actual sea menor que el nuevo.
      -- Si encontramos uno Igual, NO insertamos (evita duplicados) y
      -- liberamos el nodo recién reservado.
      while Ptr /= null and then Mayor (Elemento, Ptr.Info) loop
         Ant := Ptr;
         Ptr := Ptr.Sig;
      end loop;

      if Ptr /= null and then Igual (Elemento, Ptr.Info) then
         Free (Nuevo);  -- duplicado: lo descartamos.
         return;
      end if;

      -- Enlazar el nuevo nodo entre Ant y Ptr.
      Nuevo.Sig := Ptr;
      Ant.Sig   := Nuevo;
   end Insertar;

   ---------------------------------------------------------------------------
   procedure Suprimir (Lista: in out Tipolista; Elemento: in Tipoelem) is
      Actual : Tipolista := Lista;
      Ant    : Tipolista := null;
   begin
      -- Avanzamos hasta encontrar un Igual o pasarnos por orden.
      while Actual /= null and then not Igual (Actual.Info, Elemento) loop
         exit when Mayor (Actual.Info, Elemento);
         Ant    := Actual;
         Actual := Actual.Sig;
      end loop;

      if Actual = null or else not Igual (Actual.Info, Elemento) then
         raise Elemento_No_Esta;
      end if;

      -- Re-enlazado: si era la cabeza, mover Lista. Si no, saltar el nodo.
      if Ant = null then
         Lista := Actual.Sig;
      else
         Ant.Sig := Actual.Sig;
      end if;

      Free (Actual);
   end Suprimir;

   ---------------------------------------------------------------------------
   function Largo (Lista: in Tipolista) return Natural is
      Ptr : Tipolista := Lista;
      N   : Natural   := 0;
   begin
      while Ptr /= null loop
         N   := N + 1;
         Ptr := Ptr.Sig;
      end loop;
      return N;
   end Largo;

   ---------------------------------------------------------------------------
   function Buscar (Lista: in Tipolista; Elemento: in Tipoelem) return Tipoelem is
      Ptr : Tipolista := Lista;
   begin
      while Ptr /= null loop
         if Igual (Ptr.Info, Elemento) then
            return Ptr.Info;
         end if;
         exit when Mayor (Ptr.Info, Elemento);
         Ptr := Ptr.Sig;
      end loop;
      raise Elemento_No_Esta;
   end Buscar;

   ---------------------------------------------------------------------------
   procedure Recorrer (Lista: in Tipolista) is
      Ptr : Tipolista := Lista;
   begin
      while Ptr /= null loop
         Accion (Ptr.Info);
         Ptr := Ptr.Sig;
      end loop;
   end Recorrer;

end Lista_Ordenada;
