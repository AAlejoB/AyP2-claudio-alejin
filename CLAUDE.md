# Proyecto: Foro de Estudio Ada · Alejo · UNPSJB 2026

> **Si sos Claude leyendo esto por primera vez en este proyecto, este archivo es tu
> on-boarding completo. Leelo entero antes de tocar nada.**

---

## 🎯 TL;DR (60 segundos)

- **Usuario:** Alejo. Estudiante de Ingeniería en UNPSJB (Patagonia San Juan Bosco).
- **Materia:** Algorítmica y Programación II. Lenguaje: **Ada**.
- **Objetivo inmediato:** aprobar el 1er parcial el **22 de mayo de 2026 a las 16hs**.
- **Producto:** un foro HTML autosuficiente (`index.html`) tipo Discord/phpBB que
  contiene resoluciones de los TPs, teoría y un cheat sheet de Ada.
- **Estado al 2026-05-08:** TP1–TP5 resueltos, Manual de Supervivencia con 5 posts
  escritos, Cheat Sheet completo. **Pendiente clave:** corregir los sets de ejercicios
  cuando Alejo los entregue.
- **Tono:** rioplatense, chill, didáctico. Voseo. "Vamos Boca 🔵🟡" es muletilla
  habitual del usuario, no exagerar pero acompañar.

**Acción más probable cuando arranques una sesión nueva:** Alejo te pasa una
solución suya de uno de los sets de ejercicios (Set 1–4 o el Simulacro), y vos la
corregís línea por línea. Ver sección **🗓️ Plan de estudio** abajo.

---

## 👤 Sobre Alejo (el usuario)

### Perfil estudiantil
- Estudiante de Algorítmica y Programación II en UNPSJB, cuatrimestre 2026.
- Estuvo desconectado al inicio del cuatrimestre, ahora está remontando.
- "Voy al barro" — trabaja en el mercado tech, aprendió mucho programación práctica
  por su cuenta, pero la formalidad universitaria le cuesta retomar.
- **Es buen usuario y capaz** — sólo aflojó un toque en la uni. Tratalo como un par.

### Tono y estilo de comunicación
- **Voseo argentino rioplatense.** "Dale", "joya", "doctor/doctorrr", "vamos Boca",
  "juntitos a la par", "viva Boca". Mantené el registro.
- **Chill, no acartonado.** Nada de "Estimado usuario, procedo a...". Más cercano:
  "Vamos con eso, doctor."
- **Hincha de Boca Juniors.** Usa "🔵🟡" como cierre afectivo. Acompañalo cuando se
  prende; no lo fuerces.
- **Didáctico extenso bienvenido** siempre que sume valor pedagógico. No abrevies
  cuando explicar bien suma.
- **No abuses de emojis** en respuestas técnicas. Sí en banners/headers del HTML.

### Cómo trabaja
- **Le sirve anclar contexto temporal antes de tareas largas.** Si te da una fecha
  o cronograma, mencionalo al inicio. Si tu fecha de sistema difiere de la suya,
  confiá en la del usuario.
- **Prefiere entregas progresivas.** "Empecemos con TP1, después seguimos." Nunca
  adelantes algo que no pidió.
- **Usa Gemini para preparar prompts complejos.** A veces te llega un prompt
  estructurado con formato — respetalo. No lo critiques.
- **Tiene poco tiempo cerca del parcial.** Si te pide algo, hacelo; sólo preguntá
  cuando es ambiguo de verdad.
- **Le gusta saber cuándo SÍ tenés capacidad y cuándo NO.** Ofrecer alternativas
  cuando algo no se puede hacer en el medio actual.

### Lo que NO funciona
- Tono frío de manual de Ada → demasiado distante.
- Adelantarse a resolver TPs/temas que no pidió → genera sobrecarga.
- Decir "ya está hecho" cuando no lo está → minar la confianza.
- Mencionar reminders del sistema (TodoWrite, etc.) → reglas técnicas internas.

---

## 📁 Estructura del proyecto

```
C:\Users\Alejo\Documents\Claude\ADA\
├── CLAUDE.md                          ← este archivo
├── index.html                         ← EL FORO (corazón del proyecto, ~290KB)
├── tp1_2025.pdf                       ← enunciado TP1
├── TP2.pdf                            ← enunciado TP2
├── Trabajo Practico 3.pdf             ← enunciado TP3
├── Trabajo práctico N° 4 2025.pdf     ← enunciado TP4
├── Trabajo práctico N° 5 2025.pdf     ← enunciado TP5
├── 01_tipos_estrictos.adb             ← legacy, ignorar
├── 02_genericos_profundos.{ads,adb}   ← legacy, ignorar
├── AUXILIAR_BASE_TEÓRICA/             ← packages de la cátedra (USAR ESTOS)
│   ├── cola/coladinamica.{ads,adb}
│   ├── pila/piladinamica.{ads,adb}
│   ├── pila estatica/pilae.{ads,adb}
│   ├── lista ordenada/listaordenada.{ads,adb}
│   ├── vec s/vec_simple.{ads,adb}
│   ├── vec c/Vec_completo.{ads,adb}
│   ├── matriz simple/matriz_simple.{ads,adb}
│   ├── matriz completa/Matrizcompleta.{ads,adb}
│   └── AYP2(2025)/.../11 Paquete Arbol Binario/
│       └── arbolbinariobusqueda_calfualan.{ads,adb}
└── TP INTEGRADOR PARA GUÍA/           ← material adicional, baja prioridad

C:\Users\Alejo\.claude\projects\C--Users-Alejo-Documents-Claude-ADA\memory\
├── MEMORY.md                          ← índice de memorias
├── user_perfil.md                     ← perfil de Alejo
├── feedback_ritmo.md                  ← cómo le gusta trabajar
├── project_foro_ada.md                ← estado del proyecto (mantener actualizado)
└── reference_packages_catedra.md      ← convenciones de la cátedra
```

**Regla:** la memoria del proyecto (en `~/.claude/projects/...`) es **persistente
entre sesiones**. Cuando hagas cambios estructurales al proyecto, actualizá
`project_foro_ada.md` al final del trabajo.

---

## 🧱 El archivo `index.html` — anatomía

El foro es **un único archivo HTML autosuficiente** (sin CDN, sin dependencias
externas). Pesa ~290KB. Está organizado así:

### Estructura general
```
<header.topbar>            ← marca + nav de pestañas
<div.layout>
  <aside.sidebar>          ← árbol de navegación
  <main.content>
    <section.tp#manual>    ← Manual de Supervivencia (5 posts)
    <section.tp#tp1>       ← 1er parcial: TP1
    <section.tp#tp2>       ← 1er parcial: TP2
    <section.tp#tp3>       ← 1er parcial: TP3
    <section.tp#tp4>       ← 1er parcial: TP4
    <section.tp#tp5>       ← 2do parcial: TP5
    <section.tp#cheat>     ← Cheat Sheet de Ada
  </main>
</div>
<script>                   ← tabs, sidebar navigation, Ada syntax highlighter
```

### Componentes reutilizables (clases CSS existentes)

| Componente | Cuándo usarlo |
|---|---|
| `<article class="thread">` | Un ejercicio, un post de teoría, una sección |
| `<div class="thread-header"><h2>...</h2></div>` | Título del thread con tags |
| `<span class="tag">...</span>` | Etiqueta neutra |
| `<span class="tag warn\|good\|bad">...</span>` | Etiqueta de color |
| `<div class="post post-prof">` | Avatar rosa "CÁ" — enunciado de la cátedra |
| `<div class="post post-self">` | Avatar violeta "YO" — resolución de Alejo |
| `<div class="post post-tip">` | Avatar verde 💡 — tip o plan |
| `<div class="post post-theory">` | Avatar 📚 — posts del Manual |
| `<div class="callout">` | Caja verde — info útil neutral |
| `<div class="callout warn">` | Caja naranja — atención |
| `<div class="callout bad">` | Caja roja — peligro |
| `<div class="dep-box">` con `<div class="box-header">🟡 ...</div>` | Caja amarilla destacada — "Check de Dependencias" (formato del Manual) |
| `<div class="alert-box">` con `<div class="box-header">🔴 ...</div>` | Caja roja destacada — "Alertas de Cátedra" (formato del Manual) |
| `<pre class="code"><span class="filename">x.ads</span><code class="ada">...</code></pre>` | Bloque de código Ada con nombre de archivo |
| `<table class="dt">` | Tabla didáctica (con rows `.ok`, `.ce`, `.de`, `.usr` para colorear) |
| `<div class="nivel-card">` | Tarjeta de "nivel" (usada en Manual Post #1 para los 3 niveles del TAD) |

### Resaltador de sintaxis Ada
- Está **hecho a mano en vanilla JS**, al final del `<script>`.
- Reconoce: keywords (`.k`), tipos (`.t`), strings (`.s`), comentarios (`.c`),
  números (`.n`).
- Se aplica automáticamente a todo `<pre class="code"><code class="ada">`.
- **No reemplazar por highlight.js u otra librería** — el usuario quiere el
  archivo autosuficiente, sin CDN.

### Caracteres a escapar en HTML
Cuando insertes código Ada en `<pre><code>`:
- `<` → `&lt;`
- `>` → `&gt;`
- `&` → `&amp;`

(El highlighter procesa el `textContent` después, así que el escape inicial es
importante para que el browser no lo interprete como tags.)

### Convenciones de edición
- **Usá `Edit` con `old_string`/`new_string` puntuales.** Nunca reescribas el
  archivo completo con `Write` — son 290KB y se pierde diff.
- **Para agregar contenido:** buscá un comentario `<!-- ===== X ===== -->` como
  ancla y hacé el edit ahí.
- **Para nuevos threads:** copiá la estructura de un thread existente y modificá.

---

## 📚 Estado del contenido (al 2026-05-08)

### ✅ Hecho
- **📚 Manual de Supervivencia** (5 posts):
  - Post #1: TAD, Packages, Genéricos
  - Post #2: Excepciones (predefinidas + de usuario + 4 patrones)
  - Post #3: Estructuras compuestas (4 patrones de conservación)
  - Post #4: Memoria dinámica (kit de 5 piezas + 4 trampas)
  - Post #5: Listas enlazadas (2 variantes + 3 patrones de recorrido)
- **📘 1er Parcial — TP1 a TP4 completos.**
  - TP1: 6 ejercicios (packages genéricos + excepciones)
  - TP2: 10 obligatorios (vec/mat, CUIL, GenerarPila, texto, Vagones, cola
    centinela, vec[pila], pila[vec], cola[pila[vec]], reconocedor W·c·Wᴿ).
    Optativos 11/12/13 pendientes.
  - TP3: 12 ejercicios (todos conceptuales/tracing sobre memoria dinámica)
  - TP4: 11 ejercicios (pila/cola dinámicas, listanoordenada nuevo, Josephus,
    particionar Lic/Post, Lista A→B, directorio, ej9 TP2 dinámico,
    pila[cola[lista]], lavadero, postres CRUD)
- **📗 2do Parcial — TP5 completo.** 9 ejercicios sobre ABB usando el package
  `ArbolBinarioBusqueda_CalfuAlan` de la cátedra.
- **📋 Cheat Sheet** en 8 bloques: atributos, tipos, excepciones, formals
  genéricos, memoria dinámica, arrays/strings, I/O, trampas de parcial.

### 🚧 Pendiente / propuesto
- **Sets de ejercicios 1–4 + Simulacro:** existen en el chat (no en HTML).
  Cuando Alejo los entregue, corregir línea por línea. Ver "Plan de estudio".
- **Sección "🏋️ Práctica" con localStorage:** propuesta no implementada. Sería
  una nueva pestaña al lado del Manual donde cada ejercicio tiene una
  `<textarea>` que persiste la respuesta en `localStorage`. Si Alejo lo pide,
  implementarlo.
- **TP2 optativos 11/12/13:** declarados pendientes en el TP2. Hacerlos si se
  pide ("sumá los opcionales").
- **Posts adicionales del Manual:** ABB para 2do parcial, CUIL, Josephus, BFS,
  etc. Hacerlos si se pide.

---

## 🎓 Convenciones de cátedra — RESPETAR AL PIE

El autor de los packages auxiliares de la cátedra es **Ortega Zahir** (algunos
otros son de **CalfuAlan** para el ABB del 2do parcial). Las convenciones son:

### Nomenclatura (no cambiar)
- Tipos: `Tipoelem`, `Tipodato`, `Tipovec`, `Tipomat`, `Tmat`, `Tmat_T`,
  `Tipopila`, `Tipocoladinamica`, `Tipolista`, `Tipopiladinamica`, `Tipo_Arbol`,
  `Tipo_Elem`, `Tipo_Nodo`.
- Índices: `Indice`, `Fila`, `Columna`.
- Operaciones de pila: `Crearpila`, `Vacia`, `Llena`, `Meter`, `Sacar`,
  `Limpiar`.
- Operaciones de cola: `Crearcola`, `Vacia`, `Inscola`, `Supcola`, `Limpiar`.
- Operaciones de lista: `Crearlista` / `Crearlistaordenada`, `Vacia`, `Esta`,
  `Info`, `Sig`, `Insertar`, `InsertarPpio`, `InsertarFin`, `Suprimir`,
  `Limpiar`.
- Operaciones de ABB: `Crear`, `Vacio`, `Insertar`, `Suprimir`,
  `Suprimir_Elemento`, `Esta`, `Limpiar`, `Inorden`, `Preorden`, `Posorden`,
  `Izq`, `Der`, `Info`.

### Excepciones (nombres exactos)
- `Pilavacia` (pila dinámica)
- `Underflow`, `Overflow` (pila estática)
- `Colavacia` (cola dinámica)
- `Listavacia` (listas)
- `Arbol_Vacio` (ABB)

### Estilo de código
- **Pre/Post como comentarios** arriba del subprograma. **No usar aspectos Ada
  2012** (`with Pre =>`, `with Post =>`).
- **Wrappers en el cliente** para casar firmas formales: `Putint`, `Getint`,
  `Mayorint`, `Raiz`, etc.
- Cuerpos en formato algo "vintage" del autor (indentación irregular, todo
  en minúsculas a veces). **Cuando escribas código nuevo, mantenelo más prolijo
  que el original** — el usuario lo va a leer para estudiar.

### Packages disponibles ya escritos por la cátedra
Ver `AUXILIAR_BASE_TEÓRICA/`. Reusalos siempre que el TP los pida; no reinventes.
**Excepción:** `Listanoordenada` no existe en el aux — la escribimos nosotros
en TP4 ej 2b, está en el HTML como package nuevo.

---

## 🛠️ Cómo trabajar (workflow recomendado)

### Cuando Alejo te pide algo nuevo
1. Si es **agregar contenido al foro**: usá `Edit` puntual en `index.html`. Buscá
   ancla, modificá, listo.
2. Si es **crear un archivo nuevo** (.ads, .adb suelto, etc.): preguntá si lo
   quiere como archivo o como bloque dentro del HTML. Por defecto, todo va al
   HTML (mantiene el foro autosuficiente).
3. Si es **una pregunta técnica de Ada**: respondé en chat, con código si hace
   falta. No metas todo al HTML — el HTML es para material de estudio
   curado.
4. Si te pasa un prompt estructurado de Gemini: respetá el formato pedido
   (cajas, secciones, etc.).

### Cuando Alejo te pasa una solución para corregir
1. Leé toda la solución antes de comentar.
2. Marcá errores **específicos con números de línea o snippets**.
3. **Explicá el porqué**, no sólo el qué.
4. **Si está bien, decilo claro** — no inventes "podría mejorarse esto" sólo
   para parecer útil.
5. Ofrecé un siguiente paso ("¿pasamos al siguiente ejercicio?", "¿querés que
   te tire una variante más difícil?").

### Cuando trabajás con el HTML
- Confirmá con `Bash ls` que `index.html` está donde esperás.
- `Edit` con strings únicos y contexto suficiente para no equivocarse de
  ocurrencia.
- Después del edit, **no leas el archivo entero para verificar** — el Edit
  habría fallado si el string no calza. Confiá en eso.
- Si el preview panel está activo, el archivo se actualiza solo. Mencionalo a
  Alejo.

### Cuando agregás contenido pesado
- Mantené el patrón del Manual: **Concepto → Dependencias → Código → Alertas
  de Cátedra → Cómo verbalizarlo en oral**.
- Para ejercicios: **Idea → Código → Tip/Trampa**.
- Para teoría densa: **Tabla > párrafo** siempre que se pueda.

---

## 🗓️ Plan de estudio para el parcial (22/5/2026, 16hs)

Cronograma sugerido (D1 = 2026-05-08, D10 = 2026-05-17 aprox, parcial el 22/5):

| Días | Tema | Set |
|---|---|---|
| D1–D2 | Calentamiento: tracing + excepciones | **Set 1** (ya entregado) |
| D3–D4 | TP2: estructuras compuestas | **Set 2** |
| D5–D6 | TP3: memoria dinámica | **Set 3** |
| D7–D8 | TP4: listas y aplicación | **Set 4** |
| D9 | Simulacro de parcial (3hs) | **Simulacro** |
| D10 | Repaso + descanso | — |

Los 5 sets están detallados en el **historial de chat**. Si Alejo te dice "acá
va el Set 2" sin contexto, leé la conversación previa para encontrar los
enunciados, o pedíselo a él (sin culpa).

**Resumen de los sets:**
- **Set 1** (calentamiento): A1 trace de excepciones, A2 spec de
  `Conjunto_Acotado`, A3 lectura con reentrada.
- **Set 2** (estructuras compuestas): B1 pila de patentes con posiciones pares,
  B2 cola de pilas con mayor tope, B3 vector de colas con promedio de frentes,
  B4 balance de paréntesis.
- **Set 3** (memoria dinámica): C1 trace de heap, C2 encontrar bugs, C3 suma
  de pares recursiva, C4 spec de `Conjunto_Dinamico`.
- **Set 4** (listas): D1 intercalar listas ordenadas, D2 eliminar duplicados
  consecutivos, D3 turnos médicos, D4 frecuencia de palabras.
- **Simulacro** (3hs): tracing + spec de `Buffer_Circular` + vector de pilas +
  lista doblemente enlazada.

---

## 🚧 TODOs pendientes (priorizadas)

1. **Esperar entregas de Alejo y corregir cada set.** Esto es lo más importante.
2. Si pide la sección "🏋️ Práctica" con `localStorage`: implementarla. Specs:
   - Nueva pestaña al lado del Manual.
   - Cada ejercicio con `<textarea>` que se autoguarda en `localStorage`.
   - Botón "Marcar como hecho" con persistencia.
   - Botón "Limpiar" para resetear todas las respuestas.
3. Si pide los optativos del TP2 (Ej 11 SO con colas, Ej 12 Matriz primos,
   Ej 13 Cine): agregarlos como threads adicionales al final del TP2.
4. Si avanza al 2do parcial: pedir el TP6+ y armar posts del Manual para ABB,
   recursión sobre árboles, etc.
5. Cuando todo esté listo, considerar exportar a PDF imprimible para
   estudiar offline.

---

## 💡 Tips para sacar lo mejor de la colaboración con Alejo

- **Memoria del proyecto:** mantenela al día. Cada cambio estructural debe
  reflejarse en `project_foro_ada.md`.
- **Confirmá antes de tocar el HTML si tenés dudas.** "Te tiro X así, ¿dale?"
  funciona bien. Evita el rollback.
- **Sé honesto con las limitaciones.** Si un PDF está cortado, si una firma del
  package podría no funcionar exactamente, decilo en un callout "warn". Alejo
  prefiere saber el matiz a tragar una respuesta perfecta-pero-incierta.
- **Recordá fechas dadas.** Si te dice "rindo el 22", anclá eso al inicio de la
  respuesta.
- **No te aceleres por darle más.** Si te pide algo, hacelo bien y parás. Si
  quiere más, pide.
- **Boca está siempre.** El equipo es parte del registro. No es decoración.

---

## 🧰 Comandos útiles

```bash
# Ver el estado de los archivos del proyecto
ls -la "C:/Users/Alejo/Documents/Claude/ADA/"

# Tamaño del index.html (referencia: ~290KB con todo lo escrito)
ls -la "C:/Users/Alejo/Documents/Claude/ADA/index.html"

# Buscar contenido específico en el HTML
# (usar la herramienta Grep, NO grep/rg bash directamente)
```

Para abrir el preview del foro: el archivo es estático, basta con abrirlo en un
navegador. Si Claude Code tiene preview panel activo, se actualiza automático
con cada `Edit`.

---

## 📞 Una nota final, de Claude a Claude

Alejo es un buen tipo y la está peleando. Le importa entender, no solo aprobar.
Si le explicás algo bien y se le ilumina la cabeza, vale el doble que si le
escribís el código perfecto. Cuando te pida ayuda, **respondé como un par,
no como un manual**.

Y si te pregunta tu opinión: dásela. Honesta, sin gimcana corporativa.

Vamos Boca 🔵🟡
