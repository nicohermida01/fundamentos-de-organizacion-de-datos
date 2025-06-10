# Trabajando con archivos

## Tipos de archivos:

- Texto: con `text`
- Binarios: con `file of tipo`

```pascal
type
  TPersona = record
    Nombre: string;
    Edad: Integer;
  end;
  archivo_de_personas = file of TPersona;
var
  personas: archivo_de_personas;
  archivoTexto: Text;
```

## Asignación de archivo fisico a variable:

```pascal
assign(archivoTexto, 'archivo.txt');
assign(personas, 'personas.dat');
```

## Apertura de archivos:

- Abrir un archivo existente

```pascal
reset(archivoTexto); // reset posiciona el puntero al final del archivo
```

- Crear un archivo nuevo

```pascal
rewrite(archivoTexto); // rewrite crea un archivo nuevo o lo vacia si ya existe, posiciona el puntero al inicio
```

## Lectura de archivos

- Archivos binarios: usando `read(archivo, variable)` se guarda el registro apuntado por el puntero en la variable y se avanza el puntero al siguiente registro.

```pascal
read(personas, personaActual); // despues se podria usar personaActual.Nombre, personaActual.Edad.
```

- Archivos de texto: los archivos de texto se leen de forma diferente que los binarios. Se usa `readln()` para leer una linea completa y podemos especificar distintos tipos de campos en la misma linea. Tener en cuenta que para diferenciar un campo de otro se usa el separador de espacio ' ', por lo tanto, si un campo es de tipo texto siempre debe estar almacenado al final de la linea para que sus espacios en blanco no interfieran. Notar que solo puede haber un campo de tipo texto por linea.
  Por ejemplo, si tenemos un archivo de texto con el siguiente contenido:

```text
25 1.80 Juan Perez
30 1.75 Maria Lopez
```

```pascal
var
  edad: integer;
  altura: real;
  nombre: string;
begin
  readln(archivoTexto, edad, altura, nombre); // de esta forma se leen los campos de la linea
end.
```

## Escritura de archivos

- Archivos binarios: se usa `write(archivo, variable)` para escribir el registro variable en la posicion actual del puntero y avanzar el puntero al siguiente registro.

- Archivos de texto: se usa `writeln(archivo, reg.campo1,' ',reg.campo2,' ',reg.campo3)` para escribir una linea completa en el archivo de texto. Notar que los campos deben estar separados por espacios y que solo puede haber un campo de tipo texto por linea, el cual debe estar al final de la linea.

## Recorriendo un archivo

Cuando queremos trabajar con todos los registros de un archivo, podemos usar un bucle `while not eof(archivo)` para recorrerlo hasta el final. La función `eof(archivo)` devuelve `true` si el puntero esta al final del archivo.

## Agregar datos al final de un archivo

Para agregar datos al final de un archivo, debemos abrirlo con `reset` ya que el archivo existe y luego posicionar el puntero al final del archivo con `seek(archivo, filesize(archivo))`. Luego podemos usar `write` para agregar nuevos registros.

## Actualizar un registro

Para actualizar un registro en un archivo, primero debemos buscar el registro que queremos actualizar. Esto se hace recorriendo el archivo hasta encontrar el registro deseado. Una vez encontrado, debemos posicionar el puntero en la posicion anterior (ya que al usar `read` el puntero avanza al siguiente registro) y luego usar `write` para actualizar el registro.

```pascal
// Buscar el registro a actualizar
// Dato encontrado
seek(personas, filepos(personas) - 1); // Volver al registro anterior (el que queremos actualizar)
write(personas, update); // Actualizamos el registro
```

## Cerrar archivos

Al finalizar el trabajo con un archivo, es importante cerrarlo para liberar los recursos del sistema. Esto se hace con la función `close(archivo)`.
