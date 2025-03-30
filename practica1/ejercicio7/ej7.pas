program Ejercicio7;
type
  novela = record
    codigo: integer;
    nombre: string[20];
    genero: string[20];
    precio: real;
  end;
  fileOfNovelas = file of novela;
procedure mostrarMenu(var opcion: byte);
begin
  writeln('Menu de opciones:');
  writeln('1. Cargar novelas desde txt');
  writeln('2. Agregar novela');
  writeln('3. Modificar novela');
  writeln('4. Listar novelas cargadas');
  writeln('0. Salir');
  write('Ingrese una opcion: ');
  readln(opcion);
end;
procedure leerNovela(var n: novela);
begin
  writeln('Ingrese los datos de una novela.');
  writeln('Para finalizar la carga ingrese 0 en el codigo.');
  write('Codigo: ');
  readln(n.codigo);
  if (n.codigo <> 0) then begin
    write('Nombre: ');
    readln(n.nombre);
    write('Genero: ');
    readln(n.genero);
    write('Precio: ');
    readln(n.precio);
  end;
end;
var
  fileCarga: Text;
  novelasFileName: string;
  novelasFile: fileOfNovelas;
  n: novela;
  opcion: byte;
  codSearch: integer;
begin
  mostrarMenu(opcion);
  while (opcion <> 0) do begin
    case opcion of 
      1: begin
        assign(fileCarga, 'novelas.txt');
        reset(fileCarga);
        write('Ingrese un nombre para el archivo de datos: ');
        readln(novelasFileName);
        assign(novelasFile, novelasFileName);
        rewrite(novelasFile);
        while not eof(fileCarga) do begin
          readln(fileCarga, n.codigo, n.precio, n.genero);
          readln(fileCarga, n.nombre);
          write(novelasFile, n);
        end;
        close(novelasFile);
        close(fileCarga);
        writeln('Novelas cargadas correctamente.');
      end;
      2: begin
        reset(novelasFile);
        seek(novelasFile, filesize(novelasFile));
        leerNovela(n);
        while (n.codigo <> 0) do begin
          write(novelasFile, n);
          leerNovela(n);
        end;
        close(novelasFile);
        writeln('Novelas agregadas correctamente.');
      end;
      3: begin
        reset(novelasFile);
        write('Ingrese el codigo de la novela a modificar: ');
        readln(codSearch);
        while(not eof(novelasFile)) do begin
          read(novelasFile, n);
          if (n.codigo = codSearch) then begin
            write('Ingrese el nuevo precio de la novela: ');
            readln(n.precio);
            seek(novelasFile, filepos(novelasFile) -1);
            write(novelasFile, n);
          end;
        end;
        close(novelasFile);
        writeln('Novela actualizada correctamente.');
      end;
      4: begin
        reset(novelasFile);
        while(not eof(novelasFile)) do begin
          read(novelasFile, n);
          writeln('Codigo: ',n.codigo,'; Nombre: ',n.nombre,'; Genero: ',n.genero,'; Precio: ',n.precio:0:2);
        end;
        close(novelasFile);
      end;
    end;
    mostrarMenu(opcion);
  end;
end.