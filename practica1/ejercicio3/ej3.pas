program Ejercicio3;
type
  empleado = record
    numEmp: integer;
    apellido: string[20];
    nombre: string[20];
    edad: integer;
    dni: integer;
  end;
var
  fileOfEmpleados: file of empleado;
  emp: empleado;
  fileName, search: string;
begin
  fileName := 'empleados';
  assign(fileOfEmpleados, fileName);
  rewrite(fileOfEmpleados);

  writeln('Ingrese los datos de un empleado:');
  write('Apellido: ');
  readln(emp.apellido);
  while (emp.apellido <> 'fin') do
  begin
    write('Nombre: ');
    readln(emp.nombre);
    write('Edad: ');
    readln(emp.edad);
    write('DNI: ');
    readln(emp.dni);
    write('Numero de empleado: ');
    readln(emp.numEmp);

    write(fileOfEmpleados, emp);
    writeln('Ingrese los datos de un empleado:');
    write('Apellido: ');
    readln(emp.apellido);
  end;

  close(fileOfEmpleados);

  // Punto b
  assign(fileOfEmpleados, fileName);
  reset(fileOfEmpleados);

  // punto b1
  write('Ingrese un nombre o apellido para buscar: ');
  readln(search);

  while not eof(fileOfEmpleados) do
  begin
    read(fileOfEmpleados, emp);

    if (emp.apellido = search) or (emp.nombre = search) then
    begin
      writeln('Apellido: ', emp.apellido);
      writeln('Nombre: ', emp.nombre);
      writeln('Edad: ', emp.edad);
      writeln('DNI: ', emp.dni);
      writeln('Numero de empleado: ', emp.numEmp);
      writeln('--------------------------------');
    end;
  end;

  // Punto b2
  seek(fileOfEmpleados, 0);
  writeln('Contenido del archivo:');
  while not eof(fileOfEmpleados) do
  begin
    read(fileOfEmpleados, emp);
    writeln('Apellido: ', emp.apellido,
            ', Nombre: ', emp.nombre,
            ', Edad: ', emp.edad,
            ', DNI: ', emp.dni,
            ', Numero de empleado: ', emp.numEmp);
  end;

  // punto b3
  seek(fileOfEmpleados, 0);
  writeln('Empleados mayores de 70 años:');
  while not eof(fileOfEmpleados) do
  begin
    read(fileOfEmpleados, emp);
    if (emp.edad > 70) then
    begin
      writeln('Apellido: ', emp.apellido,
              ', Nombre: ', emp.nombre,
              ', Edad: ', emp.edad,
              ', DNI: ', emp.dni,
              ', Numero de empleado: ', emp.numEmp);
    end;
  end;

  close(fileOfEmpleados);
end.