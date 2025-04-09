program Ejercicio2P2;
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
procedure mostrarMenu(var opcion: byte);
begin
  writeln('Menu de opciones:');
  writeln('1. Actualizar productos');
  writeln('2. Exportar productos sin stock');
  writeln('0. Salir');
  write('Ingrese una opcion: ');
  readln(opcion);
end;
var
  productos: fileProductos; // archivo maestro
  ventas: fileVenta; // archivo detalle
  opcion: byte;
  p: producto;
  v: venta;
  sinStock: Text;
begin
  mostrarMenu(opcion);
  while(opcion <> 0) do begin
    case opcion of
      1: begin
        assign(productos, 'productos_maestro');
        assign(ventas, 'ventas_detalle');
        reset(productos);
        reset(ventas);

        while(not eof(ventas)) do begin
          read(productos, p);
          read(ventas, v);

          // en el caso que la venta leida no coincida con el producto leido, buscamos el producto correspondiente a la venta.
          while (p.codigo <> v.codProd) do read(productos, p);

          // actualizamos el stock del producto que se esta procesando hasta que llegue una venta con codigo diferente
          while ((not eof(ventas)) and (p.codigo = v.codProd)) do begin
            p.stockActual := p.stockActual - v.cant;
            read(ventas, v);
          end;

          // volvemos atras el puntero de ventas para el sigueinte loop.
          // sin esto el algoritmo no funciona
          if (not eof(ventas)) then seek(ventas, filepos(ventas) -1);

          // escribimos el producto actualizado en el archivo
          seek(productos, filepos(productos) -1);
          write(productos, p)
        end;

        close(productos);
        close(ventas);
      end;
      2: begin
        assign(productos, 'productos_maestro');
        assign(sinStock, 'stock_minimo.txt');
        reset(productos);
        rewrite(sinStock);

        while (not eof(productos)) do begin
          read(productos, p);
          if (p.stockActual < p.stockMin) then writeln(sinStock, p.codigo,' ',p.precio:0:2,' ',p.stockActual,' ',p.stockMin,' ',p.nombre);
        end;

        close(productos);
        close(sinStock);
      end;
    end;
    mostrarMenu(opcion);
  end;
end.