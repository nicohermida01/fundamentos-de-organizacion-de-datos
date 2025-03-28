program Ejercicio4;
type
  empleado = record
    numEmp: integer;
    apellido: string[20];
    nombre: string[20];
    edad: integer;
    dni: integer;
  end;
  fileOfEmpleados = file of empleado;
procedure mostrarMenu(var opcion: integer);
begin
  writeln('Menu de opciones:');
  writeln('1. Buscar empleado por nombre o apellido');
  writeln('2. Mostrar contenido del archivo');
  writeln('3. Mostrar empleados mayores de 70 años');
  writeln('4. Agregar empleados');
  writeln('5. Modificar edad de un empleado');
  writeln('6. Exportar empleados');
  writeln('7. Exportar empleados sin DNI');
  writeln('0. Salir');
  write('Ingrese una opcion: ');
  readln(opcion);
end;
procedure leerEmpleado(var emp: empleado);
begin
  write('Apellido: ');
  readln(emp.apellido);
  if (emp.apellido <> 'fin') then
  begin
    write('Nombre: ');
    readln(emp.nombre);
    write('Edad: ');
    readln(emp.edad);
    write('DNI: ');
    readln(emp.dni);
    write('Numero de empleado: ');
    readln(emp.numEmp);
  end;
end;
function numeroCargado(var empleados: fileOfEmpleados; numEmp: integer): boolean;
var
  emp: empleado;
  encontrado: boolean;
begin
  encontrado := false;
  seek(empleados, 0);
  while (not eof(empleados)) do
  begin
    read(empleados, emp);
    if (emp.numEmp = numEmp) then 
    begin
      encontrado := true;
      break;
    end;
  end;

  numeroCargado := encontrado;
end;
var
  empleados: fileOfEmpleados;
  emp: empleado;
  fileName, search: string;
  opcion, numEmpSearch: integer;
  todos_empleados, empleados_sin_dni: Text;
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
    assign(empleados, fileName);
    rewrite(empleados);
    
    writeln('Ingrese los datos de los empleados:');
    writeln('Para finalizar la carga, ingrese "fin" como apellido.');
    leerEmpleado(emp);
    while (emp.apellido <> 'fin') do
    begin
      write(empleados, emp);
      leerEmpleado(emp);
    end;

    close(empleados);
    writeln('Archivo creado con exito.');

    mostrarMenu(opcion);
    while (opcion <> 0) do
    begin
      case opcion of
        1: begin
          reset(empleados);
          write('Ingrese un nombre o apellido para buscar: ');
          readln(search);
          while not eof(empleados) do
          begin
            read(empleados, emp);
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
          close(empleados);
        end;
        2: begin
          reset(empleados);
          writeln('Contenido del archivo:');
          while not eof(empleados) do
          begin
            read(empleados, emp);
            writeln('Apellido: ', emp.apellido,
                    ', Nombre: ', emp.nombre,
                    ', Edad: ', emp.edad,
                    ', DNI: ', emp.dni,
                    ', Numero de empleado: ', emp.numEmp);
          end;
          close(empleados);
        end;
        3: begin
          reset(empleados);

          writeln('Empleados mayores de 70 años:');
          while not eof(empleados) do
          begin
            read(empleados, emp);
            if (emp.edad > 70) then
            begin
              writeln('Apellido: ', emp.apellido,
                      ', Nombre: ', emp.nombre,
                      ', Edad: ', emp.edad,
                      ', DNI: ', emp.dni,
                      ', Numero de empleado: ', emp.numEmp);
            end;
          end;

          close(empleados);
        end;
        4: begin
          reset(empleados);
          
          writeln('Ingrese los datos de los empleados:');
          writeln('Para finalizar la carga, ingrese "fin" como apellido.');
          leerEmpleado(emp);
          while (emp.apellido <> 'fin') do
          begin
            if (not numeroCargado(empleados, emp.numEmp)) then
            begin
              seek(empleados, filesize(empleados));
              write(empleados, emp);
            end
            else begin
              writeln('El numero de empleado ya existe.')
            end;

            leerEmpleado(emp);
          end;

          close(empleados);
        end;
        5: begin
          write('Ingrese el numero de empleado a modificar: ');
          readln(numEmpSearch);
          reset(empleados);
          while not eof(empleados) do begin
            read(empleados, emp);
            if (emp.numEmp = numEmpSearch) then begin
              writeln('Empleado encontrado.');
              write('Ingrese la nueva edad: ');
              readln(emp.edad);
              seek(empleados, filepos(empleados) - 1);
              write(empleados, emp);
              writeln('Edad modificada con exito.');
              break;
            end;
          end;
          close(empleados);
        end;
        6: begin
          reset(empleados);
          assign(todos_empleados, 'todos_empleados.txt');
          rewrite(todos_empleados);
          
          while not eof(empleados) do begin
            read(empleados, emp);
            writeln(todos_empleados, emp.apellido,' ', emp.nombre, ' ', emp.edad, ' ', emp.dni, ' ', emp.numEmp);
          end;

          close(todos_empleados);
          close(empleados);
        end;
        7: begin
          reset(empleados);
          assign(empleados_sin_dni, 'faltaDNIEmpleado.txt');
          rewrite(empleados_sin_dni);

          while not eof(empleados) do begin
            read(empleados, emp);
            if (emp.dni = 00) then begin
              writeln(empleados_sin_dni, emp.apellido,' ', emp.nombre, ' ', emp.edad, ' ', emp.dni, ' ', emp.numEmp);
            end;
          end;

          close(empleados_sin_dni);
          close(empleados);
        end;
      end;
      mostrarMenu(opcion);
    end;
  end;   
end.