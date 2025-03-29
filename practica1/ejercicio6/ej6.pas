program Ejercicio6;
type
  celular = record
    codigo: integer;
    nombre: string[20];
    descripcion: string[50];
    marca: string[20];
    precio: real;
    stock_minimo: integer;
    stock_disponible: integer;
  end;
  fileOfCelulares = file of celular;
procedure mostrarMenu(var opcion: byte);
begin
  writeln('Menu de opciones:');
  writeln('1. Cargar datos de celulares desde un archivo de texto.');
  writeln('2. Mostrar celulares con stock disponible menor al minimo.');
  writeln('3. Buscar por descripcion.');
  writeln('4. Exportar archivo a .txt');
  writeln('5. Añadir nuevo celular.');
  writeln('6. Modificar stock de un celular.');
  writeln('7. Exportar celulares sin stock.');
  writeln('0. Salir');
  write('Ingrese una opcion: ');
  readln(opcion);
end;
function contieneSubcadena(cadena, subcadena: string): boolean;
var
  i, j: integer;
  contiene: boolean;
begin
  contiene := false;
  for i := 1 to length(cadena) do begin
    if (cadena[i] = subcadena[1]) then begin
      for j := 1 to length(subcadena) do begin
        if (cadena[i + j - 1] <> subcadena[j]) then begin
          break;
        end;
      end;

      if (j = length(subcadena)) then begin
        contiene := true;
        break;
      end;
    end;
  end;

  contieneSubcadena := contiene;
end;
procedure leerCelular(var c: celular);
begin
  writeln('Ingrese los datos del celular:');
  writeln('Para finalizar la carga ingrese "fin" en el nombre.');
  write('Nombre: ');
  readln(c.nombre);
  if (c.nombre <> 'fin') then begin
    write('Codigo: ');
    readln(c.codigo);
    write('Descripcion: ');
    readln(c.descripcion);
    write('Marca: ');
    readln(c.marca);
    write('Precio: ');
    readln(c.precio);
    write('Stock disponible: ');
    readln(c.stock_disponible);
    write('Stock minimo: ');
    readln(c.stock_minimo);
  end;
end;  
var
  celulares: fileOfCelulares;
  celularesFileName, search: string;
  carga, exportar, sinStockTxt: Text;
  c: celular;
  opcion: byte;
begin
  mostrarMenu(opcion);
  while (opcion <> 0) do begin
    case opcion of
      1: begin
        write('Ingrese un nombre para el archivo de celulares: ');
        readln(celularesFileName);
        assign(celulares, celularesFileName);
        rewrite(celulares);
        assign(carga, 'celulares.txt');
        reset(carga);
        while not eof(carga) do begin
          readln(carga, c.codigo, c.precio, c.marca);
          readln(carga, c.stock_disponible, c.stock_minimo, c.descripcion);
          readln(carga, c.nombre);
          write(celulares, c);
        end;
        writeln('Datos cargados correctamente.');
        close(carga);
        close(celulares);
      end;
      2: begin
        writeln('Celulares con stock disponible menor al minimo:');
        reset(celulares);
        while not eof(celulares) do begin
          read(celulares, c);
          if (c.stock_disponible < c.stock_minimo) then begin
            writeln('Codigo: ', c.codigo);
            writeln('Nombre: ', c.nombre);
            writeln('Descripcion: ', c.descripcion);
            writeln('Marca: ', c.marca);
            writeln('Precio: ', c.precio);
            writeln('Stock disponible: ', c.stock_disponible);
            writeln('Stock minimo: ', c.stock_minimo);
            writeln;
          end;
        end;
        close(celulares);
      end;
      3: begin
        write('Buscar por descripcion: ');
        readln(search);
        if (search <> '') then begin
          reset(celulares);
          while not eof(celulares) do begin
            read(celulares, c);
            if (c.descripcion <> '') then begin
              if (contieneSubcadena(c.descripcion, search)) then begin
                writeln('Codigo: ', c.codigo);
                writeln('Nombre: ', c.nombre);
                writeln('Descripcion: ', c.descripcion);
                writeln('Marca: ', c.marca);
                writeln('Precio: ', c.precio);
                writeln('Stock disponible: ', c.stock_disponible);
                writeln('Stock minimo: ', c.stock_minimo);
                writeln;
              end;
            end;
          end;
          close(celulares);
        end;
      end;
      4: begin
        reset(celulares);
        assign(exportar, 'celulares.txt');
        rewrite(exportar);
        while not eof(celulares) do begin
          read(celulares, c);
          writeln(exportar, c.codigo,' ',c.precio:0:2,' ',c.marca);
          writeln(exportar, c.stock_disponible,' ',c.stock_minimo,' ',c.descripcion);
          writeln(exportar, c.nombre);
        end;
        close(exportar);
        close(celulares);
        writeln('Archivo exportado correctamente.');
      end;
      5: begin
        reset(celulares);
        seek(celulares, filesize(celulares));
        leerCelular(c);
        while (c.nombre <> 'fin') do begin
          write(celulares, c);
          leerCelular(c);
        end;
        close(celulares);
        writeln('Celulares añadidos correctamente.');
      end;
      6: begin
        reset(celulares);
        write('Ingrese el nombre del celular a modificar: ');
        readln(search);
        while not eof(celulares) do begin
          read(celulares, c);
          if (c.nombre = search) then begin
            write('Ingrese el nuevo stock: ');
            readln(c.stock_disponible);
            seek(celulares, filepos(celulares) -1);
            write(celulares, c);
            writeln('Stock modificado correctamente.');
          end;
        end;
        close(celulares);
      end;
      7: begin
        reset(celulares);
        assign(sinStockTxt, 'SinStock.txt');
        rewrite(sinStockTxt);
        while not eof(celulares) do begin
          read(celulares, c);
          if (c.stock_disponible = 0) then begin
            writeln(sinStockTxt, c.codigo,' ',c.precio:0:2,' ',c.marca);
            writeln(sinStockTxt, c.stock_disponible,' ',c.stock_minimo,' ',c.descripcion);
            writeln(sinStockTxt, c.nombre);
          end;
        end;
        close(sinStockTxt);
        close(celulares);
        writeln('Celulares sin stock exportados correctamente.');
      end;
    end;
    mostrarMenu(opcion);
  end;
end.