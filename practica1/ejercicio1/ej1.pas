program Ejercicio1;
var
  fileName: string;
  outputFile: file of integer;
  inputNumber: integer;
begin
  write('Ingrese un nombre para el archivo: ');
  read(fileName);

  assign(outputFile, fileName);
  rewrite(outputFile);

  write('Ingrese un numero entero: ');
  read(inputNumber);
  while (inputNumber <> 30000) do
  begin
    write(outputFile, inputNumber);
    write('Ingrese un numero entero: ');
    read(inputNumber);
  end;

  close(outputFile);
end.