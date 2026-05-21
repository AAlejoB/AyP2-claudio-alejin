-- ============================================================
-- 02_genericos_profundos.ads
-- Especificación de un paquete genérico con:
--   * Parámetros de tipo formal (privado, discreto, numérico)
--   * Parámetros de subprograma formal
--   * Tipo contenedor con operaciones verificadas
-- ============================================================

generic
   --  Tipo de elemento: cualquier tipo privado (con igualdad)
   type Elemento is private;

   --  Parámetro subprograma formal: el llamante decide cómo comparar
   with function "<" (A, B : Elemento) return Boolean is <>;

   --  Capacidad máxima como constante genérica
   Capacidad : Positive := 128;

package Cola_Prioridad is

   -- Tipo opaco: el usuario no conoce la representación interna
   type Cola is limited private;

   -- Excepción propia del paquete
   Cola_Llena  : exception;
   Cola_Vacia  : exception;

   -- Inserta un elemento manteniendo el orden
   procedure Insertar (C : in out Cola; E : Elemento)
     with Pre  => not Esta_Llena (C),
          Post => not Esta_Vacia (C);

   -- Extrae el elemento de mayor prioridad (mínimo según "<")
   procedure Extraer (C : in out Cola; E : out Elemento)
     with Pre  => not Esta_Vacia (C),
          Post => Tamano (C) = Tamano (C)'Old - 1;

   -- Inspecciona sin extraer
   function Primero (C : Cola) return Elemento
     with Pre => not Esta_Vacia (C);

   function Esta_Vacia  (C : Cola) return Boolean;
   function Esta_Llena  (C : Cola) return Boolean;
   function Tamano      (C : Cola) return Natural
     with Post => Tamano'Result <= Capacidad;

private

   -- Implementación basada en heap binario (array estático,
   -- sin memoria dinámica — ideal para sistemas embebidos).
   subtype Indice_Heap is Natural range 0 .. Capacidad;

   type Arreglo_Heap is array (1 .. Capacidad) of Elemento;

   type Cola is record
      Datos : Arreglo_Heap;
      Fin   : Indice_Heap := 0;
   end record;

end Cola_Prioridad;
