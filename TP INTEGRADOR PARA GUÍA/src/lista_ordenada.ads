-- ============================================================================
-- lista_ordenada.ads
-- Package GENÉRICO de Lista Enlazada Ordenada (con punteros / access types).
--
-- ¿Por qué genérico?
--   En Ada un "generic package" es una plantilla: define la lógica de la
--   estructura (lista enlazada ordenada) sin atarse a un tipo concreto. Quien
--   use el package debe instanciarlo pasando el tipo de los elementos y las
--   funciones que dicen cómo se comparan dos elementos. Así, esta misma lista
--   nos sirve para guardar Médicos, Pacientes, Turnos, etc.
--
-- ¿Por qué tres comparadores (Menor, Mayor, Igual) y no solo dos?
--   - Menor / Mayor son necesarios para insertar manteniendo el orden.
--   - Igual permite redefinir cuándo dos elementos son "el mismo" según la
--     semántica del TAD. Por ejemplo, dos Médicos pueden tener mismo apellido
--     pero distinto DNI: el TAD Médico puede definir Igual como "mismo DNI".
--     Si se confiara solo en el "=" automático de records, tendrían que ser
--     iguales TODOS los campos, lo cual no siempre es lo que queremos.
--
-- ¿Por qué tipo PRIVATE?
--   El cliente del package (TAD Médico, TAD Paciente, etc.) no debe conocer
--   ni manipular los punteros internos. Solo ve "Tipolista" como una caja
--   opaca y la usa con las operaciones públicas (Insertar, Suprimir, ...).
--   Esto es ENCAPSULAMIENTO: si mañana cambiamos lista enlazada por árbol,
--   los clientes no se enteran.
-- ============================================================================

generic
   --------------------------------------------------------------------------
   -- PARÁMETROS GENÉRICOS DE TIPO
   --------------------------------------------------------------------------
   -- Tipoelem: el tipo de los elementos que la lista va a guardar.
   -- "is private" significa "cualquier tipo no-limitado": records, integers,
   -- floats, etc. (No se puede instanciar con tipos limitados como tasks).
   type Tipoelem is private;

   --------------------------------------------------------------------------
   -- PARÁMETROS GENÉRICOS DE FUNCIÓN
   --------------------------------------------------------------------------
   -- "with function" indica que al instanciar el package debemos pasarle
   -- una función con esa misma firma. Estas funciones definen el orden total
   -- y la igualdad entre elementos.
   with function Menor (X, Y: Tipoelem) return Boolean;
   with function Mayor (X, Y: Tipoelem) return Boolean;
   with function Igual (X, Y: Tipoelem) return Boolean;

package Lista_Ordenada is

   --------------------------------------------------------------------------
   -- TIPO PÚBLICO OPACO
   --------------------------------------------------------------------------
   -- "is private" hace que el detalle (puntero a nodo) viva en la zona
   -- "private" del package. Para el código cliente, Tipolista es un tipo
   -- abstracto sin estructura visible.
   type Tipolista is private;

   --------------------------------------------------------------------------
   -- EXCEPCIONES DEL PACKAGE
   --------------------------------------------------------------------------
   Listavacia        : exception;  -- al pedir Info/Sig sobre lista vacía.
   Elemento_No_Esta  : exception;  -- al Suprimir un elemento ausente.

   --------------------------------------------------------------------------
   -- OPERACIONES PÚBLICAS
   --------------------------------------------------------------------------

   procedure Crear (Lista: out Tipolista);
   --  Pre:  ninguna.
   --  Post: Lista queda en estado "vacía".

   procedure Limpiar (Lista: in out Tipolista);
   --  Pre:  ninguna.
   --  Post: libera toda la memoria de la lista y la deja vacía.
   --        Importante llamar antes de salir del programa para no perder
   --        memoria reservada con "new".

   function Vacia (Lista: in Tipolista) return Boolean;
   --  Devuelve True si la lista no contiene elementos.

   function Esta (Lista: in Tipolista; Elemento: in Tipoelem) return Boolean;
   --  Devuelve True si existe en la lista un elemento "Igual" al pedido.

   function Info (Lista: in Tipolista) return Tipoelem;
   --  Devuelve el elemento del primer nodo de la lista.
   --  Levanta Listavacia si la lista está vacía.

   function Sig (Lista: in Tipolista) return Tipolista;
   --  Devuelve la "subcola" de la lista (todo menos el primer nodo).
   --  Permite recorrer la lista sin exponer punteros.
   --  Levanta Listavacia si la lista está vacía.

   procedure Insertar (Lista: in out Tipolista; Elemento: in Tipoelem);
   --  Inserta Elemento manteniendo el orden definido por Menor/Mayor.
   --  Si ya existe un elemento "Igual", no lo duplica (no hace nada).

   procedure Suprimir (Lista: in out Tipolista; Elemento: in Tipoelem);
   --  Quita el primer elemento "Igual" a Elemento.
   --  Levanta Elemento_No_Esta si no estaba.

   function Largo (Lista: in Tipolista) return Natural;
   --  Cantidad de elementos de la lista (recorrido O(n)).

   function Buscar (Lista: in Tipolista; Elemento: in Tipoelem) return Tipoelem;
   --  Devuelve el elemento almacenado "Igual" al buscado.
   --  Útil cuando "Igual" compara solo por una clave (ej. DNI) y queremos
   --  recuperar el record completo (con nombre, especialidad, etc.).
   --  Levanta Elemento_No_Esta si no está.

   --------------------------------------------------------------------------
   -- ITERACIÓN GENÉRICA
   --------------------------------------------------------------------------
   -- Recorre la lista aplicando Accion a cada elemento. Es el patrón clásico
   -- "Visitor" / "for_each" sin exponer la estructura interna.
   generic
      with procedure Accion (E: in Tipoelem);
   procedure Recorrer (Lista: in Tipolista);

private

   --------------------------------------------------------------------------
   -- IMPLEMENTACIÓN PRIVADA: lista enlazada simple
   --------------------------------------------------------------------------
   -- "type Tiponodo;" es una declaración INCOMPLETA: necesaria porque
   -- Tipolista (puntero a Tiponodo) se declara antes de la definición
   -- completa del record (que se autorreferencia con Sig: Tipolista).
   type Tiponodo;

   -- "access Tiponodo" = puntero a Tiponodo. Los punteros en Ada se llaman
   -- "access types" y son fuertemente tipados.
   type Tipolista is access Tiponodo;

   type Tiponodo is record
      Info : Tipoelem;
      Sig  : Tipolista;
   end record;

end Lista_Ordenada;
