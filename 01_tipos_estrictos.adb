-- ============================================================
-- 01_tipos_estrictos.adb
-- Demostración del sistema de tipos de Ada:
--   * Tipos discretos con rangos
--   * Subtipos vs tipos derivados
--   * Conversión explícita obligatoria
--   * Tipos modulares (wrap-around garantizado)
--   * Tipos de punto fijo y punto flotante con precisión declarada
-- ============================================================

with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Tipos_Estrictos is

   -- --------------------------------------------------------
   -- 1. TIPOS ENTEROS CON RANGO: el compilador rechaza valores
   --    fuera de rango en tiempo de compilación y lanza
   --    Constraint_Error en tiempo de ejecución.
   -- --------------------------------------------------------
   type Temperatura_Celsius is range -273 .. 10_000;
   type Edad               is range 0 .. 150;
   type Kilometraje        is range 0 .. 999_999;

   -- Subtype: misma representación, solo restringe el rango.
   subtype Fiebre is Temperatura_Celsius range 37 .. 42;

   -- Tipo DERIVADO: nuevo tipo, incompatible con el padre.
   -- Temperatura_F y Temperatura_Celsius NO son intercambiables.
   type Temperatura_F is new Integer range -460 .. 18_000;

   -- --------------------------------------------------------
   -- 2. TIPOS MODULARES: aritmética mod N, sin overflow.
   --    Útil para índices circulares, CRC, criptografía.
   -- --------------------------------------------------------
   type Byte       is mod 256;
   type Uint32     is mod 2**32;
   type Indice_Circular is mod 8;   -- 0..7, luego vuelve a 0

   -- --------------------------------------------------------
   -- 3. TIPOS ENUMERADOS: ordenados, con atributos 'Pos, 'Val,
   --    'Succ, 'Pred, 'First, 'Last.
   -- --------------------------------------------------------
   type Dia_Semana is (Lunes, Martes, Miercoles, Jueves,
                       Viernes, Sabado, Domingo);
   subtype Dia_Laboral is Dia_Semana range Lunes .. Viernes;

   -- --------------------------------------------------------
   -- 4. TIPOS DE PUNTO FIJO: precisión matemáticamente garantizada.
   --    "delta" es el incremento mínimo.
   --    "digits" sería para flotante.
   -- --------------------------------------------------------
   type Dinero   is delta 0.01 range -999_999.99 .. 999_999.99;
   type Angulo   is delta 0.001 range 0.0 .. 360.0;

   -- --------------------------------------------------------
   -- 5. TIPOS DE PUNTO FLOTANTE con precisión mínima declarada.
   -- --------------------------------------------------------
   type Real_Simple  is digits 6;   -- al menos 6 dígitos decimales
   type Real_Doble   is digits 15;  -- al menos 15 dígitos decimales

   -- --------------------------------------------------------
   -- Variables
   -- --------------------------------------------------------
   T1        : Temperatura_Celsius := 36;
   Fiebre_V  : Fiebre              := 38;
   Mi_Edad   : Edad                := 25;
   B1        : Byte                := 250;
   B2        : Byte                := 10;
   Idx       : Indice_Circular     := 7;
   Hoy       : Dia_Semana          := Miercoles;
   Precio    : Dinero              := 19.99;
   Pi_Aprox  : Real_Doble          := 3.14159265358979;

begin
   Put_Line ("=== Sistema de Tipos Estrictos en Ada ===");
   New_Line;

   -- Aritmética con tipos de rango
   Put_Line ("Temperatura (C): " & Temperatura_Celsius'Image (T1));
   Put_Line ("Fiebre: "          & Fiebre'Image (Fiebre_V));

   -- Conversión EXPLÍCITA obligatoria entre tipos compatibles
   T1 := Temperatura_Celsius (Fiebre_V);  -- OK: misma base
   Put_Line ("T1 tras conversión: " & Temperatura_Celsius'Image (T1));

   -- La siguiente línea NO compilaría (tipos distintos):
   --   T1 := Temperatura_F (100);   -- Error: incompatible types

   -- Módulo: 250 + 10 = 4 (mod 256)
   B1 := B1 + B2;
   Put_Line ("Byte (250+10 mod 256): " & Byte'Image (B1));

   -- Circular: 7 + 1 = 0 (mod 8)
   Idx := Idx + 1;
   Put_Line ("Índice circular (7+1 mod 8): " & Indice_Circular'Image (Idx));

   -- Atributos de tipos enumerados
   Put_Line ("Sucesor de Miercoles: " & Dia_Semana'Image (Dia_Semana'Succ (Hoy)));
   Put_Line ("Posición de Viernes:  " &
             Integer'Image (Dia_Semana'Pos (Viernes)));
   Put_Line ("Días laborales: " & Dia_Laboral'First'Image &
             " .. " & Dia_Laboral'Last'Image);

   -- Punto fijo
   Precio := Precio + 5.01;
   Put_Line ("Precio actualizado: " & Dinero'Image (Precio));

   -- Flotante de doble precisión
   Put_Line ("Pi (15 dígitos): " & Real_Doble'Image (Pi_Aprox));

   -- Detectar subtipo fuera de rango (Constraint_Error en runtime)
   declare
      Val : Fiebre;
   begin
      Val := 43;   -- fuera del rango 37..42
      Put_Line ("No debería llegar aquí: " & Fiebre'Image (Val));
   exception
      when Constraint_Error =>
         Put_Line ("CORRECTO: Constraint_Error al asignar 43 a Fiebre");
   end;

   -- Atributos universales útiles para depuración/reflexión
   Put_Line ("Temperatura_Celsius'Size:  " &
             Integer'Image (Temperatura_Celsius'Size) & " bits");
   Put_Line ("Temperatura_Celsius'First: " &
             Temperatura_Celsius'Image (Temperatura_Celsius'First));
   Put_Line ("Temperatura_Celsius'Last:  " &
             Temperatura_Celsius'Image (Temperatura_Celsius'Last));
   Put_Line ("Dinero'Delta: " & Dinero'Image (Dinero'Delta));

end Tipos_Estrictos;
