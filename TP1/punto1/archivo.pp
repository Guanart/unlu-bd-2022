unit archivo;

interface

Uses sysutils;

type

    TRegistro = Record
        cliente: Integer;
        apellido: String;
        nombre: String;
    end;

    TArchivo = Object
        private
            datos: file of TRegistro;
        public
            Procedure crearArchivo();
            Procedure leer();
            Procedure agregar(registro: TRegistro);
            Procedure eliminar(pos: Integer);
            Procedure modificar(pos: Integer; registro: TRegistro);
    end;


implementation


Procedure TArchivo.crearArchivo();
begin
    assign(datos, 'data.dat');
    rewrite(datos);
    close(datos);
end;


Procedure TArchivo.leer();
var registro: TRegistro;
begin
    assign(datos, 'data.dat');
    reset(datos);
    WriteLn();

    while not eof(datos) do begin
        read(datos, registro);
        if registro.cliente <> 0 then begin
            WriteLn('Cliente: ' + IntToStr(registro.cliente));
            WriteLn('Nombre: ' + registro.nombre);
            WriteLn('Apellido: ' + registro.apellido);
            WriteLn();
        end;
    end;

    close(datos);
end;


Procedure TArchivo.agregar(registro: TRegistro);
var rAux: TRegistro;
begin
    assign(datos, 'data.dat');
    reset(datos);
    // Mover puntero al final con seek()
    // seek(datos, filesize(datos));

    // Mover el puntero al final secuencialmente
    while not eof(datos) do read(datos, rAux);
    write(datos, registro);
    close(datos);
end;


Procedure TArchivo.eliminar(pos: Integer);
var i: Integer;
    fAux: File of TRegistro;
    rAux: TRegistro;
begin
    assign(datos, 'data.dat');
    reset(datos);
    assign(fAux, 'aux.dat');    
    rewrite(fAux);

    // Mover puntero con seek()
    // seek(datos, pos);

    // Mover el puntero secuencialmente
    i := 0;
    while not eof(datos) do begin
        read(datos, rAux);
        if i <> pos then write(fAux, rAux);
        i := i + 1;
    end;

    close(datos);
    close(fAux);
    deleteFile('data.dat');
    renameFile('aux.dat', 'data.dat');
end;


Procedure TArchivo.modificar(pos: Integer; registro: TRegistro);
var i: Integer;
    fAux: File of TRegistro;
    rAux: TRegistro;
begin
    assign(datos, 'data.dat');
    reset(datos);
    assign(fAux, 'aux.dat');    
    rewrite(fAux);

    // Mover puntero con seek()
    // seek(datos, pos);

    // Mover el puntero secuencialmente
    i := 0;
    while not eof(datos) do begin
        read(datos, rAux);
        if i <> pos then write(fAux, rAux)
        else write(fAux, registro);
        i := i + 1;
    end;

    close(datos);
    close(fAux);
    deleteFile('data.dat');
    renameFile('aux.dat', 'data.dat');
end;


end.