program Ejercicio1P2;
type 
  comision = record
    empCod: integer;
    nombre: string;
    monto: real;
  end;

  fileComisiones = file of comision;
var
  comisiones, comisionesMaster: fileComisiones;
  c, acumulador: comision;
begin
  assign(comisiones, 'comisiones');
  assign(comisionesMaster, 'comisiones_maestro');
  reset(comisiones);
  rewrite(comisionesMaster);

  read(comisiones, c);
  acumulador := c;

  while(not eof(comisiones)) do begin
    read(comisiones, c);
    if (c.empCod = acumulador.empCod) then begin
      acumulador.monto := acumulador.monto + c.monto;
    end
    else begin
      write(comisionesMaster, acumulador);
      acumulador := c;
    end;
  end;

  write(comisionesMaster, acumulador);

  close(comisiones);
  close(comisionesMaster);
end.