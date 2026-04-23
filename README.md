# Práctica Mini Cloud Log

**Camarillo MOlina Cristian**
**23210553**

**Lenguajes de interfaz**

**Rene Solis Reyes**

## Implementación de un Mini Cloud Log Analyzer en ARM64

**Modalidad:** Individual
**Entorno de trabajo:** AWS Ubuntu ARM64 + GitHub Classroom
**Lenguaje:** ARM64 Assembly (GNU Assembler) + Bash + GNU Make

---

## Introducción

En esta práctica se desarrolla un Mini Cloud Log Analyzer utilizando ensamblador ARM64 (AArch64) en un entorno Linux, con el objetivo de comprender el funcionamiento de bajo nivel de un sistema de análisis de datos sin el uso de bibliotecas externas como libc. El programa procesa entradas provenientes de la entrada estándar (stdin), donde se reciben códigos HTTP línea por línea, y los clasifica mediante el uso de syscalls del sistema operativo.

El enfoque principal de la práctica es reforzar el entendimiento de la arquitectura ARM64, el manejo directo de memoria, el uso de registros del procesador y la implementación de lógica condicional en ensamblador. Además, se integra el flujo de trabajo con herramientas como GNU Make y Bash para automatizar la compilación y ejecución del programa.

En esta variante en particular, se implementa la detección de tres errores consecutivos dentro de una secuencia de códigos HTTP, así como el almacenamiento y posterior visualización de los códigos de error encontrados, permitiendo analizar el comportamiento del sistema ante fallos en servidores o clientes.

El programa procesará códigos de estado HTTP suministrados mediante entrada estándar (stdin):

```bash id="y1gcmc"
cat logs.txt | ./analyzer
```

---

## Objetivo general

DEl programa:
1. Lee datos desde stdin usando syscall read
2. Convierte bytes a números enteros
3. Clasifica códigos HTTP
4. Detecta errores consecutivos
5. Almacena errores en un arreglo en memoria
6. Imprime resultados con syscall write

---

## Objetivos específicos

El estudiante aplicará:

* programación en ARM64 bajo Linux
* manejo de registros
* direccionamiento y acceso a memoria
* instrucciones de comparación
* estructuras iterativas en ensamblador
* saltos condicionales
* uso de syscalls Linux
* compilación con GNU Make
* control de versiones con GitHub Classroom

Estos temas se alinean con contenidos clásicos de flujo de control, herramientas GNU, manejo de datos y convenciones de programación en ensamblador.   

---

## Variantes de la práctica aplicada

### Variante D

Detectar tres errores consecutivos.

- Lee códigos HTTP línea por línea
- Clasifica errores 4xx y 5xx
- Detecta si existen 3 errores consecutivos
- Guarda y muestra todos los códigos de error

---

## Compilación

```bash id="bmubtb"
make
```

---

## Ejecución

```bash id="gcqlf2"
cat logs.txt | ./analyzer
```

---

## Entregables

Cada estudiante deberá entregar en su repositorio:

* archivo fuente ARM64 funcional
* solución implementada
* README explicando diseño y lógica utilizada
* evidencia de ejecución
* commits realizados en GitHub Classroom

---

## Criterios de evaluación

| Criterio                    | Ponderación |
| --------------------------- | ----------- |
| Compilación correcta        | 20%         |
| Correctitud de la solución  | 35%         |
| Uso adecuado de ARM64       | 25%         |
| Documentación y comentarios | 10%         |
| Evidencia de pruebas        | 10%         |

---

## Restricciones

No está permitido:

* resolver la lógica en C
* resolver la lógica en Python
* modificar la variante asignada
* omitir el uso de ARM64 Assembly

---

## Competencia a desarrollar

Comprender cómo un problema de procesamiento de datos es implementado a nivel máquina mediante instrucciones ARM64.

---

## Nota

Aunque este problema puede resolverse fácilmente en lenguajes de alto nivel, el propósito de la práctica es implementar **cómo lo resolvería la arquitectura**, no únicamente obtener el resultado.

