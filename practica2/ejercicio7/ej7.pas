program ejercicio7P2;
type
  string20 = string[20];
  reg_maestro = record
    codigo_alumno, cursadas_aprobadas, finales_aprobados: integer;
    nombre, apellido: string20;
  end;
  archivo_maestro: file of reg_maestro;
  reg_cursada = record
    codigo_alumno, codigo_materia, anio: integer;
    aprobado: boolean;
  end;
  archivo_cursadas = file of reg_cursada;
  reg_final = record
    codigo_alumno, codigo_materia: integer;
    nota: real;
    fecha: string20;
  end;
  archivo_finales = file of reg_final;
var
  maestro: archivo_maestro;
  cursadas: archivo_cursadas;
  finales: archivo_finales;
  regMaestro: reg_maestro;
  regCursada: reg_cursada;
  regFinal: reg_final;
begin
  assign(maestro, 'alumnos_maestro');
  assign(cursadas, 'cursadas_detalle');
  assign(finales, 'finales_detalle');
  reset(maestro);
  reset(cursadas);
  reset(finales);
  
  leer(cursadas, regCursada);
  leer(finales, regFinal);
  minimo();
  
  close(maestro);
  close(cursadas);
  close(finales);
end.