program Ejercicio2;
var
  fileName: string;
  numbersFile: file of integer;
  number, sum, cant, lowerCant: integer;
begin
  sum := 0;
  cant := 0;
  lowerCant := 0;

  write('Ingrese el nombre del archivo: ');
  read(fileName);

  assign(numbersFile, fileName);
  reset(numbersFile);

  write('Contenido del archivo: ');

  while not eof(numbersFile) do
  begin
    read(numbersFile, number);
    write(number);

    sum := sum + number;
    cant := cant + 1;

    if (number < 1500) then lowerCant := lowerCant + 1;
  end;
  close(numbersFile);

  writeln;
  write('Promedio: ', sum / cant);
  writeln;
  write('Cantidad de numeros menores a 1500: ', lowerCant);
end.