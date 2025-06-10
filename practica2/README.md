# Algoritmica clásica

## Actualización Maestro - Detalle

Actualizar un archivo maestro con uno o más archivos detalle implica reflejar en el archivo maestro los cambios realizados en los archivos detalle. Para poder realizar esta operación es necesario que se den las siguientes condiciones:

1. El archivo maestro y los archivos detalle deben estar ordenados por el mismo campo clave.
2. Cada registro del archivo detalle se corresponde con un registro del archivo maestro.

### Algoritmo general (con 1 archivo detalle)

```pascal
begin
  // 1. Abrir el archivo maestro y los archivos detalle
  // 2. Leer el primer registro del archivo maestro y del archivo detalle
  // 3. Mientras no sea EOF del archivo maestro hacer:
  //   a. Si clave detalle = clave maestro entonces
  //     i. Actualizar el registro del archivo maestro con los datos del archivo detalle
  //     ii. Leer el siguiente registro del archivo detalle
  //   b. Si clave detalle > clave maestro entonces no hacer nada
  //   c. Sobreescribir el registro del archivo maestro
  //   d. Leer el siguiente registro del archivo maestro
  // 4. Cerrar los archivos
end.
```

### Algoritmo general (con varios archivos detalle)

El algoritmo es similar al anterior, pero se debe hacer una comparacion con cada uno de los archivos detalle buscando el registro con clave menor. Este registro minimo es que se va a usar para comparar con la clave del archivo maestro.

```pascal
const stopValue = 'ZZZ'; // Valor que indica fin de archivo, valor "muy alto"

procedure leer(var det: detalle; var dato: regDetalle);
begin
  if (not eof(det)) then read(det, dato)
  else dato.cod := stopValue;
end;

procedure minimo(var det1,det2: detalle; var c1,c2,min: regDetalle);
begin
  if (c1.cod <= c2.cod) then begin
    min:= c1;
    leer(det1, c1);
  end
  else begin
    min:= c2;
    leer(det2, c2);
  end;
end;
```

## Corte de control

La operacion corte de control permite detectar cambios en el valor de una clave de control y realizar una acción cuando esto sucede. Por ejemplo, si tenemos un archivo de ventas ordenado por vendedor, podemos usar el corte de control para detectar cuando cambia el vendedor y realizar una acción como imprimir un informe de ventas por vendedor.

Es necesario que el archivo este ordenado por la clave de control para que el corte de control funcione correctamente.

### Algoritmo general

```pascal
begin
  // 1. Abrir el archivo y leer el primer registro
  // 2. Mientras no sea EOF hacer:
  //   a. Guardar el valor de la clave de control del registro actual en una variable auxiliar
  //   b. Leer el siguiente registro
  //   c. Mientras el valor de la clave no cambie hacer:
  //     i. Realizar la acción deseada (por ejemplo, acumular ventas)
  //     ii. Leer el siguiente registro
  //   d. Si el valor de la clave ha cambiado, realizar la acción final (por ejemplo, imprimir el informe)
  // 3. Cerrar el archivo
end.
```

## Merge de archivos

El merge de archivos es una operación que permite combinar varios archivos ordenados en uno solo, manteniendo el orden. Es útil cuando se tienen varios archivos con datos relacionados y se desea tener un único archivo con todos los datos ordenados.

Para realizar esta operacion se deben dar las siguientes condiciones:

1. Los archivos a combinar deben estar ordenados por la misma clave.
2. Los archivos deben tener el mismo formato de registro.

### Algoritmo general (con n archivos sin repetición)

```pascal
begin
  // 1. Abrir los archivos detalle y crear el archivo maestro
  // 2. Leer el primer registro de cada archivo detalle
  // 3. Invocar al proceso minimo para obtener el registro con la clave menor
  // 4. Mientras MIN no sea stopValue hacer:
  //   a. Escribir el registro MIN en el archivo maestro
  //   b. Invocar nuevamente al proceso minimo
  // 5. Cerrar los archivos
end.
```

### Algoritmo general (con n archivos con repetición)

```pascal
begin
  // 1. Abrir los archivos detalle y crear el archivo maestro
  // 2. Leer el primer registro de cada archivo detalle
  // 3. Invocar al proceso minimo para obtener el registro con la clave menor
  // 4. Mientras MIN no sea stopValue hacer:
  //   a. Inicializamos un nuevo registro maestro con los datos del registro MIN
  //   b. Mientras el registro MIN sea igual al registro maestro hacer:
  //     i. Acumular los datos del registro MIN en el registro maestro
  //     ii. Invocar nuevamente al proceso minimo
  //   c. Escribir el registro maestro en el archivo maestro
  // 5. Cerrar los archivos
end.
```
