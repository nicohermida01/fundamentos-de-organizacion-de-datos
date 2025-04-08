program CargarComisiones;
type 
  comision = record
    empCod: integer;
    nombre: string;
    monto: real;
  end;

  fileComisiones = file of comision;
var
  carga: Text;
  c: comision;
  comisiones: fileComisiones;
begin
  assign(carga, 'comisiones.txt');
  assign(comisiones, 'comisiones');
  reset(carga);
  rewrite(comisiones);

  while(not eof(carga)) do begin
    readln(carga, c.empCod, c.monto, c.nombre);
    write(comisiones, c);
  end;

  writeln('Comisiones cargadas correctamente!');

  close(carga);
  close(comisiones);
end.