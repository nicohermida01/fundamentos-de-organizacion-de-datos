program ejercicio4P2;
const stopValue = -1;
const cantDetalles = 30;
type
  producto = record
    codigo, stock, stockMin: integer;
    nombre, descripcion: string;
    precio: real;
  end;
  venta = record
    codigo, cant: integer;
  end;
  maestroFile = file of producto;
  detalleFile = file of venta;
  detallesArray = array [1..cantDetalles] of detalleFile;
  ventasArray = array [1..cantDetalles] of venta;
  
procedure leer(var det: detalleFile; var dato: venta);
begin
  if (not eof(det)) then read(det, dato)
  else dato.codigo := stopValue;
end;

procedure minimo(var detalles: detallesArray; var ventas: ventasArray; var min: venta);
var
  i, toRead: integer;
begin
  min:= ventas[1];
  toRead:= 1;
  for i:= 2 to cantDetalles do begin
    if (ventas[i].codigo < min.codigo) then begin
      min:= ventas[i];
      toRead:= i;
    end;
  end;
  
  leer(detalles[toRead], ventas[toRead]); // queda guardado el siguiente reg del seleccionado como "min"
end;  

var
  maestro: maestroFile;
  detalles: detallesArray;
  i: integer;
  ventas: ventasArray;
  min: venta;
  p: producto;
  sinStock: Text;
  numStr: string;
begin
  assign(maestro, 'productos');
  reset(maestro);
  assign(sinStock, 'por_debajo_del_minimo.txt');
  rewrite(sinStock);
  for i:= 1 to cantDetalles do begin
    Str(i, numStr);
    assign(detalles[i], 'venta-'+numStr);
    reset(detalles[i]);
  end;
  
  for i:= 1 to cantDetalles do leer(detalles[i], ventas[i]);
  minimo(detalles, ventas, min);
  
  while(min.codigo <> stopValue) do begin
    //1. leemos un registro del maestro.
    //2. buscamos que el registro maestro corresponda con el detalle minimo.
    //3. procesamos todos los detalles que se relacionen con ese registro maestro (gracias a que estan ordenados). Actualizamos el registro maestro con los datos correspondientes.
    //4. escribimos en el archivo maestro el registro maestro actualizado.
    
    read(maestro, p); // 1.
    while (p.codigo <> min.codigo) do read(maestro, p); // 2.
    while (min.codigo = p.codigo) do begin
      p.stock:= p.stock - min.cant;
      minimo(detalles, ventas, min);
    end; // 3.
    seek(maestro, filepos(maestro) -1);
    write(maestro, p); // 4.
    
    if (p.stock < p.stockMin) then begin
      writeln(sinStock, p.nombre);  
      writeln(sinStock, p.descripcion);
      writeln(sinStock, p.stock,' ',p.precio);
    end;
  end;
  
  close(maestro);
  for i:= 1 to cantDetalles do begin
    close(detalles[i]);
  end;
  close(sinStock);
end.