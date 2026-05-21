-- ============================================================
-- 02_genericos_profundos.adb
-- Cuerpo del paquete genérico Cola_Prioridad.
-- Heap binario de mínimos sobre array estático.
-- ============================================================

package body Cola_Prioridad is

   -- --------------------------------------------------------
   -- Utilidades internas del heap
   -- --------------------------------------------------------

   function Padre (I : Positive) return Positive is (I / 2);
   function Hijo_Izq (I : Positive) return Positive is (2 * I);
   function Hijo_Der (I : Positive) return Positive is (2 * I + 1);

   procedure Intercambiar (C : in out Cola; I, J : Positive) is
      Tmp : constant Elemento := C.Datos (I);
   begin
      C.Datos (I) := C.Datos (J);
      C.Datos (J) := Tmp;
   end Intercambiar;

   -- Sube el elemento en posición I hacia la raíz
   procedure Flotar (C : in out Cola; I : Positive) is
      Pos : Positive := I;
   begin
      while Pos > 1 and then C.Datos (Pos) < C.Datos (Padre (Pos)) loop
         Intercambiar (C, Pos, Padre (Pos));
         Pos := Padre (Pos);
      end loop;
   end Flotar;

   -- Hunde el elemento en posición I hacia las hojas
   procedure Hundir (C : in out Cola; I : Positive) is
      Pos   : Positive := I;
      Menor : Positive;
   begin
      loop
         Menor := Pos;

         if Hijo_Izq (Pos) <= C.Fin
           and then C.Datos (Hijo_Izq (Pos)) < C.Datos (Menor)
         then
            Menor := Hijo_Izq (Pos);
         end if;

         if Hijo_Der (Pos) <= C.Fin
           and then C.Datos (Hijo_Der (Pos)) < C.Datos (Menor)
         then
            Menor := Hijo_Der (Pos);
         end if;

         exit when Menor = Pos;
         Intercambiar (C, Pos, Menor);
         Pos := Menor;
      end loop;
   end Hundir;

   -- --------------------------------------------------------
   -- Operaciones públicas
   -- --------------------------------------------------------

   procedure Insertar (C : in out Cola; E : Elemento) is
   begin
      if Esta_Llena (C) then
         raise Cola_Llena;
      end if;
      C.Fin             := C.Fin + 1;
      C.Datos (C.Fin)   := E;
      Flotar (C, C.Fin);
   end Insertar;

   procedure Extraer (C : in out Cola; E : out Elemento) is
   begin
      if Esta_Vacia (C) then
         raise Cola_Vacia;
      end if;
      E              := C.Datos (1);        -- el mínimo siempre está en la raíz
      C.Datos (1)    := C.Datos (C.Fin);    -- mueve la última hoja a la raíz
      C.Fin          := C.Fin - 1;
      if C.Fin > 0 then
         Hundir (C, 1);
      end if;
   end Extraer;

   function Primero (C : Cola) return Elemento is (C.Datos (1));

   function Esta_Vacia (C : Cola) return Boolean is (C.Fin = 0);
   function Esta_Llena (C : Cola) return Boolean is (C.Fin = Capacidad);
   function Tamano     (C : Cola) return Natural  is (C.Fin);

end Cola_Prioridad;
