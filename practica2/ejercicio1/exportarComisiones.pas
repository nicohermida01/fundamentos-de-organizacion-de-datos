program exportarComisiones;
type 
  comision = record
    empCod: integer;
    nombre: string;
    monto: real;
  end;

  fileComisiones = file of comision;
var
  comisionesExport: Text;
  comisionesMaster: fileComisiones;
  c: comision;
begin
  assign(comisionesExport, 'comisiones_maestro.txt');
  rewrite(comisionesExport);
  assign(comisionesMaster, 'comisiones_maestro');
  reset(comisionesMaster);

  while (not eof(comisionesMaster)) do begin
    read(comisionesMaster, c);
    writeln(comisionesExport, c.empCod,' ',c.monto:0:2,' ',c.nombre);
  end;

  writeln('Comisiones Maestro exportado correctamente!');

  close(comisionesMaster);
  close(comisionesExport);
end.