program ejercicio6P2;
const cant_detalles = 10;
const stop_value = -1;
type
  reg_casos = record
    activos, nuevos, recuperados, fallecidos: integer;
  end;
  reg_detalle = record
    codigo_localidad, codigo_cepa: integer;
    casos: reg_casos;
  end;
  archivo_detalle = file of reg_detalle;
  array_detalles = array[1..cant_detalles] of archivo_detalle;
  array_reg_detalles = array[1..cant_detalles] of reg_detalle;
  reg_datos = record
    codigo: integer;
    nombre: string;
  end;
  reg_maestro = record
    localidad: reg_datos;
    cepa: reg_datos;
    casos: reg_casos;
  end;
  archivo_maestro = file of reg_maestro;
  
procedure leer(var detalle: archivo_detalle; var regDetalle: reg_detalle);
begin
  if (not eof(detalle)) then read(detalle, regDetalle)
  else regDetalle.codigo_localidad:= stop_value;
end;

procedure minimo(var detalles: array_detalles; var regDetalles: array_reg_detalles; var min: reg_detalle);
var
  i, pos: integer;
begin
  min:= regDetalles[1];
  pos:= 1;
  
  for i:= 2 to cant_detalles do begin
    if (regDetalles[i].codigo_localidad < min.codigo_localidad) then begin
      min:= regDetalles[i];
      pos:= i;
    end;
  end;
  
  leer(detalles[pos], regDetalles[pos]);
end;

// --- Programa Principal ---  
var
  maestro: archivo_maestro;
  detalles: array_detalles;
  regDetalles: array_reg_detalles;
  min: reg_detalle;
  regMaestro: reg_maestro;
  iStr: string;
  i, casosActivosLocalidad, cantLocalidadesInformar, localidadAux: integer;
begin
  assign(maestro, 'covid_maestro');
  reset(maestro);
  for i:= 1 to cant_detalles do begin
    Str(i, iStr);
    assign(detalles[i], 'covid_municipio-'+iStr);
    reset(detalles[i]);
  end;
  
  for i:= 1 to cant_detalles do leer(detalles[i], regDetalles[i]);
  minimo(detalles, regDetalles, min);
  
  while (min.codigo_localidad <> stop_value) do begin
    read(maestro, regMaestro);
    while(regMaestro.localidad.codigo <> min.codigo_localidad) do read(maestro, regMaestro);
    while(regMaestro.localidad.codigo = min.codigo_localidad) do begin
    
      regMaestro.casos.activos:= 0;
      regMaestro.casos.nuevos:= 0;
      while((regMaestro.cepa.codigo = min.codigo_cepa) and (regMaestro.localidad.codigo = min.codigo_localidad)) do begin
        regMaestro.casos.fallecidos:= regMaestro.casos.fallecidos + min.casos.fallecidos;
        regMaestro.casos.recuperados:= regMaestro.casos.recuperados + min.casos.recuperados;
        regMaestro.casos.activos:= regMaestro.casos.activos + min.casos.activos;
        regMaestro.casos.nuevos:= regMaestro.casos.nuevos + min.casos.nuevos;
        
        minimo(detalles, regDetalles, min);
      end;

      seek(maestro, filepos(maestro) -1);
      write(maestro, regMaestro);
    end;
  end;
  
  // calcular la cantidad de localidades con mas de 50 casos activos
  // proceso los registros maestros luego de la actualizacion para tener en cuenta las localidades que no fueron actualizadas.
  cantLocalidadesInformar:= 0;
  seek(maestro, 0);
  read(maestro, regMaestro);
  localidadAux:= regMaestro.localidad.codigo;
  casosActivosLocalidad:= regMaestro.casos.activos;
  while(not eof(maestro)) do begin
    read(maestro, regMaestro);
    if (regMaestro.localidad.codigo = localidadAux) then casosActivosLocalidad:= casosActivosLocalidad + regMaestro.casos.activos
    else begin
      if (casosActivosLocalidad > 50) then cantLocalidadesInformar:= cantLocalidadesInformar + 1;
      localidadAux:= regMaestro.localidad.codigo;
      casosActivosLocalidad:= regMaestro.casos.activos;
    end;
  end;
  
  close(maestro);
  for i:= 1 to cant_detalles do begin
    close(detalles[i]);
  end;
  
  writeln('Cantidad de localidades con mas de 50 casos activos: ', cantLocalidadesInformar);
end.