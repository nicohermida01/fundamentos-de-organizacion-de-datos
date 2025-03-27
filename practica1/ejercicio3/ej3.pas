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
  opcion: integer;
begin
  writeln('Menu de opciones:');
  writeln('1. Crear archivo de empleados');
  writeln('0. Salir');
  write('Ingrese una opcion: ');
  readln(opcion);

  if (opcion = 1) then
  begin
    write('Ingrese el nombre del archivo: ');
    readln(fileName);
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
    writeln('Archivo creado con exito.');

    writeln('Menu de opciones:');
    writeln('1. Buscar empleado por nombre o apellido');
    writeln('2. Mostrar contenido del archivo');
    writeln('3. Mostrar empleados mayores de 70 años');
    writeln('0. Salir');
    write('Ingrese una opcion: ');
    readln(opcion);

    while (opcion <> 0) do
    begin
      if (opcion = 1) then
      begin
        reset(fileOfEmpleados);
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

        close(fileOfEmpleados);
      end
      else if (opcion = 2) then
      begin
        reset(fileOfEmpleados);

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

        close(fileOfEmpleados);
      end
      else if (opcion = 3) then
      begin
        reset(fileOfEmpleados);

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
      end;

      writeln('Menu de opciones:');
      writeln('1. Buscar empleado por nombre o apellido');
      writeln('2. Mostrar contenido del archivo');
      writeln('3. Mostrar empleados mayores de 70 años');
      writeln('0. Salir');
      write('Ingrese una opcion: ');
      readln(opcion);
    end
  end;   
end.