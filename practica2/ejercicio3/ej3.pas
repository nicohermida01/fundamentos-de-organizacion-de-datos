program ejercicio3P2;
const stopValue = 'ZZZ';
type 
  alfabetizacion = record
    provincia: string;
    nroAlfabetizados, totalEncuestados: integer;
  end;
  censo = record
    provincia: string;
    localidadCod, nroAlfabetizados, nroEncuestados: integer;
  end;

  fileAlfabetizacion = file of alfabetizacion;
  fileCensos = file of censo;
procedure leer(var det: fileCensos; var dato: censo);
begin
  if (not eof(det)) then read(det, dato)
  else dato.provincia := stopValue;
end;
procedure minimo(var det1,det2: fileCensos; var c1,c2,min: censo);
begin
  if (c1.provincia <= c2.provincia) then begin
    min:= c1;
    leer(det1, c1);
  end
  else begin
    min:= c2;
    leer(det2, c2);
  end;
end;
var
  master: fileAlfabetizacion;
  det1, det2: fileCensos;
  c1,c2,min: censo;
  datoMaster: alfabetizacion;
begin
  assign(master, 'alfabetizacion_argentina');
  assign(det1, 'censo_a');
  assign(det2, 'censo_B');
  reset(master);
  reset(det1);
  reset(det2);

  // leemos un registro de todos los detalles
  leer(det1, c1);
  leer(det2, c2);

  // buscamos el registro menor entre los registros leidos (los detalles deben estar ordenados de menor a mayor a priori)
  minimo(det1,det2,c1,c2,min);

  // procesamos los registros hasta terminar con todos los detalles
  while (min.provincia <> stopValue) do begin
    read(master, datoMaster);

    // buscamos le registro master que coincida con el detalle minimo
    while (datoMaster.provincia <> min.provincia) do read(master, datoMaster);

    // procesamos todos los registros detalles reclacionados con el registro maestro
    while (datoMaster.provincia = min.provincia) do begin
      datoMaster.nroAlfabetizados:= datoMaster.nroAlfabetizados + min.nroAlfabetizados; 
      datoMaster.totalEncuestados:= datoMaster.totalEncuestados + min.nroEncuestados;

      minimo(det1,det2,c1,c2,min);
    end;

    // escribirmos el registro maestro actualizado en el archivo master
    seek(master, filepos(master) -1);
    write(master, datoMaster);
  end;

  close(master);
  close(det1);
  close(det2);
end.