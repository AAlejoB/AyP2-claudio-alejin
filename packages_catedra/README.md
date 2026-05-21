# 📦 Packages de cátedra — listos para llevar al parcial

Esta carpeta contiene los **9 packages** que se usan en Algorítmica y Programación II
(Ortega Zahir + CalfuAlan), versión "limpia": solo `.ads` (spec) y `.adb` (body),
sin backups numerados ni binarios.

## Contenido

| Package | Archivos | Para qué sirve |
|---|---|---|
| `Coladinamica` | `coladinamica.ads/.adb` | Cola dinámica genérica (FIFO) |
| `Piladinamica` | `piladinamica.ads/.adb` | Pila dinámica genérica (LIFO) |
| `Pile` (estática) | `pilae.ads/.adb` | Pila con tope acotado por `Max` |
| `Listaordenada` | `listaordenada.ads/.adb` | Lista enlazada ordenada (con `menor`/`mayor` genéricos) |
| `Listanoordenada` | `listanoordenada.ads/.adb` | Lista enlazada SIN orden (armada por Alejo en TP4) |
| `Vec_simple` | `vec_simple.ads/.adb` | Vector genérico básico |
| `Vec_completo` | `Vec_completo.ads/.adb` | Vector genérico con operaciones extra |
| `Matriz_simple` | `matriz_simple.ads/.adb` | Matriz genérica básica |
| `Matrizcompleta` | `Matrizcompleta.ads/.adb` | Matriz genérica con operaciones extra |

## Para el parcial del viernes 22/05/2026 · 16hs

El profe pidió **TADs en la PC + impresos**. Esta carpeta cumple ambas:

1. **Digital:** la tenés acá en `D:\workspace\ADA\packages_catedra\` y también
   pusheada al repo GitHub privado (acceso desde cualquier máquina con cuenta
   invitada).
2. **Impresa:** abrí cada `.ads` (solo la spec, no el body) e imprimilo. Son ~10
   páginas en total. Llevalos en un folio.

## Crédito

- La mayoría de los packages son de **Ortega Zahir** (cátedra UNPSJB).
- El ABB es de **CalfuAlan** (no está en esta carpeta; está en
  `AUXILIAR_BASE_TEÓRICA/AYP2(2025)/.../Paquete Arbol Binario/`).
- `Listanoordenada` es del **TP4** del cuatrimestre, código de Alejo.

## Cómo instanciarlos en el cliente

```ada
with Listanoordenada;
with Piladinamica;
with Coladinamica;

procedure Mi_Programa is
   package LInt  is new Listanoordenada (Tipoelem => Integer);
   package PFloat is new Piladinamica    (Tipoelem => Float);
   package CChar  is new Coladinamica    (Tipoelem => Character);
begin
   ...
end Mi_Programa;
```

Las firmas exactas de cada operación están en el `.ads` correspondiente.
