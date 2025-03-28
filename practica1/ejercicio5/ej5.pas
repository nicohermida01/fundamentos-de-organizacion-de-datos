program Ejercicio5;
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
var
  celulares: fileOfCelulares;
  celularesFileName, search: string;
  carga, exportar: Text;
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
          writeln(exportar, c.codigo,' ',c.precio:0:2, c.marca);
          writeln(exportar, c.stock_disponible,' ',c.stock_minimo, c.descripcion);
          writeln(exportar, c.nombre);
        end;
        close(exportar);
        close(celulares);
        writeln('Archivo exportado correctamente.');
      end;
    end;
    mostrarMenu(opcion);
  end;
end.