# Blog del TP Integrador — Gestión de Clínica en Ada

> Bitácora paso-a-paso de la lógica usada para resolver el integrador.
> Pensado como material de estudio: explica POR QUÉ está cada cosa donde está,
> no solo QUÉ hace.

## Índice

1. [Mapa del proyecto](#1-mapa-del-proyecto)
2. [Cómo compilar y correr](#2-cómo-compilar-y-correr)
3. [El package genérico `Lista_Ordenada`](#3-el-package-genérico-lista_ordenada)
4. [TAD Paciente](#4-tad-paciente)
5. [TAD Turno](#5-tad-turno)
6. [TAD Médico (con agenda)](#6-tad-médico-con-agenda)
7. [TAD Clínica (orquestador)](#7-tad-clínica-orquestador)
8. [Interfaz por consola y `main`](#8-interfaz-por-consola-y-main)
9. [Persistencia en archivo de texto](#9-persistencia-en-archivo-de-texto)
10. [Errores típicos y cómo se manejan](#10-errores-típicos-y-cómo-se-manejan)
11. [Decisiones de diseño que valen la pena](#11-decisiones-de-diseño-que-valen-la-pena)
12. [Próximos pasos / Clínica 2](#12-próximos-pasos--clínica-2)

---

## 1. Mapa del proyecto

```
TP INTEGRADOR PARA GUÍA/
├── BLOG.md                 ← este archivo
├── COMO_COMPILAR.txt       ← instrucciones cortas
├── data/
│   └── clinica.txt         ← persistencia (se crea al "Guardar y salir")
├── ejemplo_tf_extraido/    ← ejemplo dado por la cátedra (no se modifica)
└── src/
    ├── lista_ordenada.ads / .adb
    ├── paciente.ads        / .adb
    ├── turno.ads           / .adb
    ├── medico.ads          / .adb
    ├── clinica.ads         / .adb
    ├── interfaz.ads        / .adb
    └── gestion_clinica.adb  ← procedimiento principal
```

Capas:

```
                       ┌─────────────────────────┐
gestion_clinica.adb →  │  procedimiento main     │
                       └────────────┬────────────┘
                                    │ usa
                       ┌────────────▼────────────┐
   interfaz.ads/adb ←  │   capa de I/O por menú  │
                       └────────────┬────────────┘
                                    │ delega
                       ┌────────────▼────────────┐
   clinica.ads/adb  ←  │   TAD orquestador       │
                       └───┬───────┬─────────┬───┘
                           │       │         │
                           ▼       ▼         ▼
                     paciente.ads medico.ads turno.ads
                                    │         ▲
                                    └─ usa ───┘
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │ lista_ordenada (genérico)│
                       └─────────────────────────┘
```

Regla de oro: **una dependencia siempre apunta hacia abajo en este diagrama**.
Eso evita imports circulares y mantiene las responsabilidades separadas.

---

## 2. Cómo compilar y correr

Necesitás tener instalado GNAT (cualquier versión ≥ 3.15). En el shell:

```bash
cd "TP INTEGRADOR PARA GUÍA/src"
gnatmake gestion_clinica.adb
./gestion_clinica.exe
```

`gnatmake` se encarga de:
1. Determinar qué `.adb`/`.ads` están relacionados.
2. Compilarlos en el orden correcto.
3. Linkear todo en un ejecutable `gestion_clinica.exe`.

Para limpiar:

```bash
rm -f *.ali *.o gestion_clinica.exe
```

> Si tu GNAT es Ada 2012+ (todo desde GNAT 4.x), también funciona sin
> cambiar nada — solo no usamos features de Ada 2005/2012 para mantener
> compatibilidad amplia.

---

## 3. El package genérico `Lista_Ordenada`

### 3.1 ¿Por qué genérico?

En todo el integrador necesitamos guardar listas ordenadas: médicos
(ordenados por apellido), pacientes (ordenados por apellido), turnos de un
médico (ordenados cronológicamente). En vez de copiar y pegar la
implementación tres veces, escribimos UNA y la **instanciamos** para cada
tipo.

Eso es lo que hace `generic`:

```ada
generic
   type Tipoelem is private;
   with function Menor (X, Y: Tipoelem) return Boolean;
   with function Mayor (X, Y: Tipoelem) return Boolean;
   with function Igual (X, Y: Tipoelem) return Boolean;
package Lista_Ordenada is
   type Tipolista is private;
   ...
end Lista_Ordenada;
```

`Tipoelem` es un parámetro de tipo: cuando instanciamos, decimos "este
parámetro va a ser `Tipopaciente`" (o `Tipomedico`, o `Tipoturno`). Las tres
funciones `Menor / Mayor / Igual` también son parámetros: el cliente nos
provee la lógica concreta de comparación porque la lista no sabe nada
sobre el dominio.

### 3.2 ¿Por qué TRES comparadores?

Lo más común son dos: `Menor` y `Mayor` (con eso ordenás). Acá usamos un
tercero, `Igual`, por una razón sutil: queremos que dos elementos sean "el
mismo" cuando coincide su CLAVE PRIMARIA, aunque el resto difiera.

Ejemplo: dos pacientes con el mismo DNI son la misma persona, aunque uno
tenga "OSDE" y otro "Swiss Medical" (porque cambió de obra social). Si
confiáramos en la igualdad estructural automática de records, NO los
veríamos como iguales y tendríamos duplicados en la lista.

```ada
function Igual (X, Y : Tipopaciente) return Boolean is
begin
   return X.Dni = Y.Dni;   -- solo el DNI define identidad
end Igual;
```

### 3.3 Tipo `private` y access types

```ada
type Tipolista is private;
private
   type Tiponodo;
   type Tipolista is access Tiponodo;
   type Tiponodo is record
      Info : Tipoelem;
      Sig  : Tipolista;
   end record;
```

- **`type Tipolista is private`**: el cliente no ve la estructura interna.
  Solo puede usar las operaciones públicas (Insertar, Suprimir, Esta, ...).
- **`type Tiponodo;`** (sin definición): es una declaración INCOMPLETA.
  Necesaria porque `Tipolista` es puntero a `Tiponodo` y `Tiponodo` se
  autorreferencia por `Sig`.
- **`type Tipolista is access Tiponodo`**: en Ada los punteros se llaman
  *access types* y son fuertemente tipados (no podés mezclar punteros a
  cosas distintas).

### 3.4 Instanciación: `Ada.Unchecked_Deallocation`

Para liberar memoria reservada con `new`, instanciamos un genérico de la
biblioteca estándar:

```ada
procedure Free is new Ada.Unchecked_Deallocation
   (Object => Tiponodo, Name => Tipolista);
```

Esto crea un procedimiento `Free` que toma un `Tipolista` (puntero) y
libera el nodo apuntado. Lo usamos en `Limpiar` y `Suprimir`.

### 3.5 `Insertar`: paso a paso

La lista mantiene siempre el invariante "ordenada de menor a mayor según
`Menor`". Al insertar:

1. **Lista vacía** → el nuevo nodo es la cabeza, listo.
2. **Elemento menor que la cabeza** → enlazar al frente.
3. **En otro caso**, recorrer con dos punteros (`Ant`, `Ptr`) hasta encontrar
   la posición:
   - mientras `Mayor(Elemento, Ptr.Info)`, avanzar.
   - si encontramos un `Igual` antes, NO insertamos (descartamos el nodo
     reservado con `Free`) → así evitamos duplicados.
4. Enlazar el nuevo nodo entre `Ant` y `Ptr`.

### 3.6 Iteración interna: `Recorrer`

Definimos un genérico ANIDADO:

```ada
generic
   with procedure Accion (E: in Tipoelem);
procedure Recorrer (Lista: in Tipolista);
```

Para usarlo, el cliente instancia `Recorrer` con su procedimiento. Es el
patrón "Visitor" sin exponer la estructura. (En el integrador igual usamos
mucho `Info`/`Sig` directamente porque a veces necesitamos contar/filtrar y
es más cómodo el bucle manual.)

---

## 4. TAD Paciente

### 4.1 Datos y representación

```ada
type Tipopaciente is record
   Dni            : Integer;
   Nombre         : Cadena;     -- string(1..50)
   Long_Nombre    : Natural;
   Apellido       : Cadena;
   Long_Apellido  : Natural;
   Obra_Social    : Cadena;
   Long_OS        : Natural;
end record;
```

Patrón **string-de-longitud-fija + contador**:
- `Cadena` es `String (1 .. 50)`.
- Junto guardamos cuántos caracteres del string están "vivos".
- Los getters devuelven el slice `(1 .. Long_X)`, así afuera ven solo lo
  que escribieron.

¿Por qué no usar `Unbounded_String`? Porque obligaría a hacer `with
Ada.Strings.Unbounded` en TODO el proyecto, complica la persistencia y es
ligeramente más lento. Para 50 caracteres de nombre, fijo y simple alcanza.

### 4.2 Comparadores

| Función | Compara por                       |
|---------|-----------------------------------|
| `Igual` | DNI (clave primaria)              |
| `Menor` | Apellido, desempate por nombre   |
| `Mayor` | inverso de `Menor`                |

Importante: la propiedad **`Igual(x,y) ⇒ no Menor(x,y) y no Mayor(x,y)`**
se cumple porque dos pacientes con mismo DNI representan la misma persona
(con mismo apellido y nombre).

### 4.3 Constructor de búsqueda: `Por_Dni`

```ada
function Por_Dni (Dni : Integer) return Tipopaciente;
```

Devuelve un Paciente con SOLO el DNI cargado. ¿Para qué? Para usarlo como
"clave de búsqueda" en `Esta`, `Buscar`, `Suprimir`. La lista ordenada usa
`Igual` para comparar, e `Igual` solo mira el DNI, así que no importa que
el resto del record esté vacío.

### 4.4 Persistencia (`Guardar` / `Cargar`)

Cada paciente se serializa como 4 líneas: DNI, nombre, apellido, OS. Es
texto plano legible (lo podés abrir con un editor y verificar). Para
volver a leer usamos `Get_Line` (procedimiento, Ada 95) con un buffer
y un `Last : Natural` que dice cuántos caracteres se leyeron.

---

## 5. TAD Turno

### 5.1 Representación inteligente de fecha y hora

```ada
subtype Tipoanio is Integer range 2024 .. 2100;
subtype Tipomes  is Integer range 1 .. 12;
subtype Tipodia  is Integer range 1 .. 31;
subtype Tipohora is Integer range 0 .. 24*60 - 1;
```

Tres trucos importantes:

1. **`subtype` con rango**: el compilador chequea que cualquier asignación
   a una variable de ese subtipo esté en rango. Si hacés `M : Tipomes := 13`,
   se levanta `Constraint_Error` automáticamente — no tenés que validarlo a
   mano.
2. **Hora en minutos del día (0..1439)**: en vez de guardar "hora" y
   "minuto" por separado, guardamos un único entero. Comparar dos turnos por
   hora es comparar dos enteros — chau lógica de campos.
3. **Validación cruzada mes/día**: el subtipo `Tipodia` permite 1..31 pero
   febrero no llega a 31. Eso lo chequea `Crear` con un helper
   `Dias_Del_Mes` (que considera años bisiestos: divisible por 4 pero NO
   por 100, salvo que sea por 400).

### 5.2 Comparación cronológica

Definimos `Codigo_Cronologico (T) = Anio*10000 + Mes*100 + Dia`. Es un
entero monotónico: el día 5/3/2026 da 20260305, el 4/4/2026 da 20260404.
Así, comparar fechas es comparar enteros, sin escribir "if año mayor; si
no, si mes mayor; si no...".

### 5.3 `Igual` por slot temporal

```ada
function Igual (X, Y : Tipoturno) return Boolean is
begin
   return Codigo_Cronologico (X) = Codigo_Cronologico (Y)
      and X.Hora_Minutos = Y.Hora_Minutos;
end Igual;
```

Dos turnos son "iguales" si caen en la misma fecha+hora, **sin mirar el
DNI del paciente**. Esto es porque cada slot temporal del médico es ÚNICO:
no podés tener dos pacientes a las 14:30 del mismo día. Así `Esta`/`Buscar`
prevén automáticamente el doble booking.

---

## 6. TAD Médico (con agenda)

### 6.1 Composición

Un médico es:
- Datos personales (nombre, apellido, DNI, especialidad)
- Capacidad: `Max_Turnos_Dia : Positive`
- Lista de obras sociales aceptadas (arreglo de tamaño fijo)
- **Agenda: una `Lista_Ordenada` de `Tipoturno` instanciada DENTRO del
  médico**.

La instanciación interna se hace en la zona privada del spec:

```ada
private
   package Agenda is new Lista_Ordenada
      (Tipoelem => Turno.Tipoturno,
       Menor    => Turno.Menor,
       Mayor    => Turno.Mayor,
       Igual    => Turno.Igual);

   type Tipomedico is record
      ...
      Turnos_Reservados : Agenda.Tipolista;
      ...
   end record;
```

### 6.2 Por qué obras sociales en arreglo y no en lista

Tres razones:

1. Un médico no acepta más de ~5-10 obras sociales en la práctica (límite
   `Max_Obras_Sociales = 20` por las dudas).
2. Un arreglo no necesita liberar memoria, no tiene problema de aliasing.
3. Una lista enlazada de strings sería otra instanciación genérica más, sin
   beneficio.

### 6.3 El "gotcha" del shallow copy

Esto es lo más importante de entender de todo el TAD Médico:

> Cuando copiás un `Tipomedico` por valor (asignándolo a una variable o
> devolviéndolo de una función), el campo `Turnos_Reservados` se copia
> COMO PUNTERO — apunta a los mismos nodos. Si modificás la agenda en la
> copia y la copia se descarta, los cambios pueden perderse.

Por eso, **modificar la agenda del médico requiere un patrón específico**:

```ada
M := Buscar_Medico_Por_Dni (Clinica, 12345678);   -- copia
Reservar_Turno (M, T);                             -- modifica copia
Modificar_Medico (Clinica, M);                     -- reemplaza original
```

`Modificar_Medico` hace `Suprimir` + `Insertar` en la lista de médicos: el
nodo viejo se libera (el campo de agenda viaja en M, así que no se libera
la lista de turnos), y un nodo nuevo se crea con M actualizado.

Está documentado dentro del cuerpo de `medico.adb` y `clinica.adb` para que
no se olvide.

### 6.4 Disponibilidad por día

```ada
Disponibles_Dia(M, año, mes, día) = Max_Turnos_Dia - Cantidad_Turnos_Dia(M,...)
```

`Cantidad_Turnos_Dia` recorre la agenda y cuenta los que matchean fecha.
Es O(n) en cantidad de turnos del médico — está bien, no esperamos miles.

### 6.5 `Listar_Turnos_Semana`: subprograma anidado

Para imprimir 7 días seguidos, necesitamos avanzar la fecha respetando
fines de mes y bisiestos. En vez de exportar un `Avanzar_Dia` público,
metemos sub-funciones anidadas dentro de `Listar_Turnos_Semana`:

```ada
procedure Listar_Turnos_Semana (...) is
   function Bisiesto (X) return Boolean is ... end;
   function Dias_Mes (M, A) return ... is ... end;
   procedure Avanzar_Dia is ... end;
begin
   for I in 1..7 loop
      Listar_Turnos_Dia (M, A, Me, D);
      Avanzar_Dia;
   end loop;
end Listar_Turnos_Semana;
```

Subprogramas anidados son una característica clásica de Ada/Pascal: ven
las variables del enclosing scope (`A`, `Me`, `D`) sin necesidad de
parámetros. Mantienen el código local sin polucionar el package con
helpers que solo usa una operación.

---

## 7. TAD Clínica (orquestador)

### 7.1 Composición

```ada
type Tipoclinica is record
   Nombre      : String (1 .. 80);
   Long_Nombre : Natural;
   Medicos     : Lista_Medicos.Tipolista;     -- instancia genérico
   Pacientes   : Lista_Pacientes.Tipolista;   -- instancia genérico
end record;
```

Dos instanciaciones distintas del mismo `Lista_Ordenada`, una por tipo.
Cada lista usa los `Menor / Mayor / Igual` propios de su tipo.

### 7.2 ¿Por qué la mayoría de operaciones de turno están aquí?

El enunciado dice "TAD Paciente: solicitar turno con un médico". Eso
necesita acceso a AMBAS listas (paciente y médico), así que vive en
`Clínica`. Esa es la decisión arquitectónica más típica: las operaciones
que cruzan TADs viven en el TAD que los contiene.

### 7.3 `Sacar_Turno`

```ada
procedure Sacar_Turno (C, Dni_Medico, Dni_Paciente, T) is
begin
   1. validar que el paciente existe   → Paciente_Inexistente
   2. obtener copia del médico         → Medico_Inexistente
   3. Reservar_Turno (M, T) en la copia → Sin_Disponibilidad
   4. Modificar_Medico (C, M)           -- reemplaza
end;
```

Cada paso traduce excepciones del nivel inferior a las del nivel Clínica
(ver bloque `exception` interno).

### 7.4 Filtros y búsquedas

Las operaciones tipo "Listar médicos por especialidad" recorren la lista
completa con `Esta` + `Sig` + `Info`. Es O(n), pero la lista está ordenada
por apellido, no por especialidad. Una alternativa sería un **índice
secundario por especialidad**, pero eso complica el modelo y el integrador
no lo pide. Si más adelante el set de médicos crece a miles, se rediseña.

---

## 8. Interfaz por consola y `main`

### 8.1 Capas

`gestion_clinica.adb` (main) → `interfaz` (UI) → `clinica` (lógica) → `medico/paciente/turno` → `lista_ordenada`.

`interfaz.adb` solo:
- pide datos al usuario,
- llama al TAD que hace falta,
- atrapa las excepciones del TAD y muestra un mensaje legible.

### 8.2 Por qué letras en lugar de números

Al principio el menú era "1..16". Pero `Get_Line` devuelve un string y
nuestra función `Leer_Opcion` toma solo el primer carácter, así que '1' y
'10' se confunden. Solución: opciones con letras (a..q), una por
operación. Es un cambio de UX chico que evita un parser entero.

### 8.3 Manejo de excepciones en la UI

Cada `Menu_X` hace `begin ... call ... exception when ... => Put_Line; end`.
Esto es **exception translation pragmática**: la lógica de negocio
levanta excepciones tipadas (`Medico_Inexistente`, `Sin_Disponibilidad`,
...), y la UI las traduce a mensajes en español que el usuario entiende.

Si no atrapáramos las excepciones acá, el programa moriría con un trace
de Ada en mitad del menú.

---

## 9. Persistencia en archivo de texto

### 9.1 Formato

`data/clinica.txt`:

```
<NOMBRE_CLINICA>
<CANT_MEDICOS>
   ... bloques de médico ...
<CANT_PACIENTES>
   ... bloques de paciente ...
```

Un bloque de médico:

```
<DNI>
<NOMBRE>
<APELLIDO>
<ESPECIALIDAD>
<MAX_TURNOS>
<CANT_OS>
<OS_1>
<OS_2>
...
<CANT_TURNOS>
<turno_1>   ← una línea: año tab mes tab día tab hora tab dni
<turno_2>
...
```

### 9.2 Por qué texto y no binario

- **Reproducibilidad / debugging**: lo abrís con un editor y verificás
  qué pasó.
- **Independiente de la plataforma**: no hay que preocuparse por
  endianness, padding de records, etc.
- **Simple**: con `Put_Line` y `Get_Line` alcanza.

Costo: archivo más grande y un poco más lento, pero para un integrador
con decenas de médicos/pacientes, irrelevante.

### 9.3 Cargar inteligente

Si el archivo no existe, `Cargar_De_Archivo` atrapa `Name_Error` y deja la
clínica como estaba (vacía). Así el primer arranque del programa funciona
sin tener que crear el archivo a mano.

---

## 10. Errores típicos y cómo se manejan

| Excepción                   | ¿Dónde se levanta?                | ¿Cómo la ve el usuario?               |
|-----------------------------|------------------------------------|----------------------------------------|
| `DNI_Invalido`              | Crear paciente/médico con DNI<=0  | "[ERROR] DNI fuera de rango."          |
| `Cadena_Demasiado_Larga`    | Nombre >50 chars                  | "[ERROR] Alguna cadena supera los 50." |
| `Medico_Repetido`           | Alta con DNI ya existente         | "[ERROR] Ya existe un médico..."       |
| `Medico_Inexistente`        | Baja/búsqueda con DNI inexistente | "[ERROR] No existe médico..."          |
| `Sin_Disponibilidad`        | Sacar turno cuando no hay         | "[ERROR] No hay disponibilidad..."     |
| `Turno_Inexistente`         | Cancelar turno que no existe      | "[ERROR] No existe ese turno..."       |
| `Constraint_Error`          | Subtypes fuera de rango (mes 13)  | "[ERROR] Fecha u hora inválida."       |
| `Maximo_Obras_Sociales`     | Agregar OS >20                    | "[ERROR] El médico ya alcanzó el máx." |

La regla didáctica: **levantar excepciones donde se descubre el error**,
**atraparlas y traducirlas en la UI**.

---

## 11. Decisiones de diseño que valen la pena

### 11.1 Tipos privados en TODO TAD

Cada `Tipopaciente`, `Tipomedico`, etc. es `private`. El cliente solo ve
las operaciones, no la estructura. Si mañana cambiamos de "string fijo
con longitud" a "Unbounded_String", **nada afuera del .adb se entera**.

### 11.2 `Por_Dni` como constructor de búsqueda

Patrón muy útil: una función que devuelve un valor del tipo con SOLO la
clave cargada. Permite usar las APIs `Esta(lista, clave)` /
`Suprimir(lista, clave)` sin necesitar el record completo.

### 11.3 Una sola lista ordenada genérica para todo

En vez de tres implementaciones de "lista de X", una sola genérica
instanciada tres veces. Menos código, una única fuente de verdad para
bugs como "Suprimir ajusta los punteros bien".

### 11.4 Excepciones por capa

Cada package define SUS propias excepciones (`Medico.Sin_Disponibilidad`,
`Clinica.Sin_Disponibilidad`, etc.). El TAD superior atrapa las del
inferior y las re-lanza con su propia tipificación. Es más prolijo que
exponer "primitivas" como `Listavacia` desde toda la pila.

### 11.5 Comentarios densos en español

Toda la base está comentada al estilo "explicación didáctica". El usuario
está atrasado en la cursada, y el TP tiene que servir como material de
estudio, no solo entrega.

---

## 12. Próximos pasos / Clínica 2

El enunciado de **Clínica 2** pide algunas cosas extra:

1. **"Obtener informe de asistencia médica"** (turnos atendidos por
   especialidad, ordenado por médico). Implica distinguir entre "turno
   reservado" y "turno atendido". Una opción: agregar un campo `Estado`
   al `Tipoturno` (Reservado/Atendido/Cancelado).
2. **"Reasignar turnos"** cuando un médico no puede atender. Operación en
   Clínica que mueve la agenda de un médico a otro de la misma especialidad.
3. **"Consultar historial de turnos del paciente"**. Hoy buscamos turnos
   por médico; necesitaríamos un índice secundario por DNI de paciente,
   o recorrer todos los médicos buscando turnos de ese paciente (más
   simple, suficiente).

Cuando llegue Clínica 2 se puede:
- Agregar `Estado : (Reservado, Atendido, Cancelado)` en `Tipoturno`.
- Agregar `Marcar_Atendido (M, T)` en `Medico`.
- Agregar `Informe_Asistencia (C)` en `Clinica`, ordenado por médico.
- Agregar `Reasignar (C, dni_origen, dni_destino, T)` en `Clinica`.
- Agregar `Historial_Paciente (C, dni)` que recorre médicos.

La arquitectura actual aguanta estos cambios sin reescribir nada.

---

## Apéndice: glosario de Ada

| Concepto                | Qué es / cuándo aparece                                           |
|--------------------------|--------------------------------------------------------------------|
| `package X is`           | Declara la INTERFACE pública de un módulo (.ads).                 |
| `package body X is`      | Implementación (.adb).                                             |
| `is private`             | El tipo se declara opaco; su detalle vive abajo de `private`.     |
| `generic`                | Plantilla de package o subprograma. Hay que instanciar para usar. |
| `package Y is new X(...)` | Instanciación de un genérico.                                     |
| `with X;`                | Importa el package X en este archivo.                              |
| `use X;`                 | Permite escribir `Foo` en vez de `X.Foo`. Cuidado con colisiones. |
| `access T`               | Puntero a T.                                                       |
| `new T'(...)`            | Reserva memoria en heap y devuelve puntero.                        |
| `Ada.Unchecked_Deallocation` | Genérico stdlib para liberar memoria reservada con `new`.     |
| `subtype`                | Alias con restricción (rango, accuracy, ...).                     |
| `'First`, `'Last`, `'Range` | Atributos automáticos de tipos discretos/arreglos.              |
| `raise X;`               | Lanza la excepción X.                                              |
| `exception when X => ...`| Atrapa la excepción X.                                             |
| `in / out / in out`      | Modos de paso de parámetros.                                       |
| `Constraint_Error`       | Excepción predefinida: subtype/index fuera de rango.              |

