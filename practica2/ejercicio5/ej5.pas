program ejercicio5P2;
const cantDetalles = 5;
const stopValue = -1;
type
  sesion = record
    usuario: integer;
    fecha: string;
    tiempo: real;
  end;
  detalleFile = file of sesion;
  detallesArray = array[1..cantDetalles] of detalleFile;
  detallesRegArray = array[1..cantDetalles] of sesion;

procedure leer(var detalle: detalleFile; var reg: sesion);
begin
  if (not eof(detalle)) then read(detalle, reg)
  else reg.usuario := stopValue;
end;

procedure minimo(var detalles: detallesArray; var regDetalles: detallesRegArray; var min: sesion);
var
  i, pos: integer;
begin
  min:= regDetalles[1];
  pos:= 1;

  for i:= 2 to cantDetalles do begin
    if (regDetalles[i].usuario < min.usuario) then begin
      min:= regDetalles[i];
      pos:= i;
    end;
  end;

  leer(detalles[pos], regDetalles[pos]);
end;

var
  detalles: detallesArray;
  regDetalles: detallesRegArray;
  maestro: detalleFile;
  min, regM: sesion;
  i: integer;
  numStr: string;
begin
  assign(maestro, '/var/log/sesiones_maestro');
  rewrite(maestro);
  for i:= 1 to cantDetalles do begin
    Str(i, numStr);
    assign(detalles[i], 'sesion-'+numStr);
    reset(detalles[i]);
  end;

  for i:= 1 to cantDetalles do leer(detalles[i], regDetalles[i]);
  minimo(detalles, regDetalles, min);

  while(min.usuario <> stopValue) do begin
    // 1. Inicializamos los datos unicos del registro maestro
    // 2. Actualizamos el dato "a procesar" en el registro maestro
    // 3. Escribimos el registro maestro en el archivo maestro

    regM.usuario := min.usuario;
    regM.fecha := min.fecha;
    regM.tiempo:= 0;

    while(regM.usuario = min.usuario) do begin
      regM.tiempo:= regM.tiempo + min.tiempo;
      minimo(detalles, regDetalles, min);  
    end;

    write(maestro, regM);
  end;

  close(maestro);
  for i:= 1 to cantDetalles do begin
    close(detalles[i]);
  end;
end.