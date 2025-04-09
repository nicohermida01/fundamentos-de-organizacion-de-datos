program cargarArchivos;
type
  producto = record
    codigo, stockActual, stockMin: integer;
    nombre: string;
    precio: real;
  end;
  venta = record
    codProd, cant: integer;
  end;

  fileProductos = file of producto;
  fileVenta = file of venta;
var
  productosCarga, ventasCarga: Text;
  productosMaster: fileProductos;
  ventasDetalle: fileVenta;
  p: producto;
  v: venta;
begin
  assign(productosCarga, 'productos.txt');
  assign(ventasCarga, 'ventas.txt');
  assign(productosMaster, 'productos_maestro');
  assign(ventasDetalle, 'ventas_detalle');

  reset(productosCarga);
  reset(ventasCarga);
  rewrite(productosMaster);
  rewrite(ventasDetalle);

  while (not eof(productosCarga)) do begin
    readln(productosCarga, p.codigo, p.precio, p.stockActual, p.stockMin, p.nombre);
    write(productosMaster, p);
  end;

  while (not eof(ventasCarga)) do begin
    readln(ventasCarga, v.codProd, v.cant);
    write(ventasDetalle, v);
  end;

  writeln('Archivos cargados correctamente!');

  close(productosCarga);
  close(ventasCarga);
  close(productosMaster);
  close(ventasDetalle);
end.