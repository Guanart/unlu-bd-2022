unit archivo;

interface

Uses sysutils;

type

    TRegistro = Record
        cliente: Integer;
        apellido: String[16];
        nombre: String[16];
        siguiente: Integer;     // -1 -> null
        estado: Boolean;
    end;

    TArchivo = Object
        private
            datos: file of TRegistro;
            Function hash(k: Integer): Integer;
        public
            Procedure crearArchivo();
            Procedure leer();
            Function buscar(codigo: Integer): Integer;
            Procedure alta(registro: TRegistro);
            Procedure eliminar(codigo: Integer);
            Procedure modificar(registro: TRegistro);
    end;

const SIZE = 1009;


implementation


Function TArchivo.hash(k: Integer): Integer;
begin
    hash := k mod SIZE;
end;


Procedure TArchivo.crearArchivo();
var rAux: TRegistro;
    i: Integer;
begin
    assign(datos, 'Prueba.dat');
    rewrite(datos);
    rAux.cliente := 0;
    rAux.nombre := '.';
    rAux.apellido := '.';
    rAux.siguiente := -1;
    rAux.estado := False;

    for i := 0 to SIZE do begin
        seek(datos, i);
        write(datos, rAux);
    end;

    close(datos);
end;

Procedure printRegistro(registro: TRegistro);
begin
    WriteLn('Cliente: ' + IntToStr(registro.Cliente));
    WriteLn('Nombre: ' + registro.Nombre);
    WriteLn('Apellido: ' + registro.Apellido);
    WriteLn('Siguiente: ' + IntToStr(registro.Siguiente));
    WriteLn();
end;

Procedure TArchivo.leer();
var registro: TRegistro;
begin
    assign(datos,'Prueba.dat');
    reset(datos);

    // Leer tabla hash
    while not eof(datos) do begin
        read(datos, registro);
        if (registro.cliente <> 0) and (registro.estado) then begin
            printRegistro(registro);
        end;
    end;

    close(datos);
end;


Function TArchivo.buscar(codigo: Integer): Integer;
var registro: TRegistro;
    pos: Integer;
begin
    pos := self.hash(codigo);
    assign(datos, 'Prueba.dat');
    reset(datos);

    // Se mueve a la posicion y verifica si ya existe una clave
    seek(datos, pos);
    read(datos, registro);

    while (registro.siguiente <> -1) and (registro.cliente <> codigo) do begin
        pos := registro.siguiente;
        seek(datos, registro.siguiente);
        read(datos, registro);
    end;

    if (codigo = registro.cliente) and (registro.estado) then begin
        printRegistro(registro);
        buscar := pos;
    end
    else begin
        WriteLn('No se ha encontrado el cliente');
        buscar := -2;
    end;

    close(datos);
end;


Procedure TArchivo.eliminar(codigo: Integer);
var pos: Integer;
    rAux: TRegistro;
begin
    pos := buscar(codigo);
    assign(datos, 'Prueba.dat');
    reset(datos);

    if (pos <> -2) then begin
        seek(datos, pos);
        read(datos, rAux);
        rAux.estado := False;
        seek(datos, pos);
        write(datos, rAux);
        WriteLn('El cliente ' + IntToStr(codigo) + ' se ha dado de baja');
    end;

    close(datos);
end;


Procedure TArchivo.modificar(registro: TRegistro);
var pos: Integer;
begin
    pos := buscar(registro.cliente);
    assign(datos, 'Prueba.dat');
    reset(datos);

    if (pos <> -2) then begin
        seek(datos, pos);
        write(datos, registro);
    end;

    close(datos);
end;


Procedure TArchivo.alta(registro: TRegistro);
var pos: Integer;
    rAux: TRegistro;
begin
    pos := hash(registro.cliente);
    assign(datos, 'Prueba.dat');
    reset(datos);

    // Se mueve a la posicion y verifica si ya existe una clave
    seek(datos, pos);
    read(datos, rAux);

    // Cliente ya existente
    if (registro.cliente = rAux.cliente) then begin
        if (rAux.estado) then begin        
            WriteLn('El cliente ya existe');
            Exit;
        end
        else begin
            WriteLn('Se ha encontrado un registro con el codigo del cliente. Se ha dado de alta');
            rAux.estado := True;
            seek(datos, pos);
            write(datos, rAux);
        end;
    end
    // Colision
    else if (registro.cliente <> rAux.cliente) and (rAux.cliente <> 0) then begin
        while (rAux.siguiente <> -1) and (registro.cliente <> rAux.cliente) do begin
            seek(datos, rAux.siguiente);
            read(datos, rAux);
        end;

        if (registro.cliente = rAux.cliente) then begin
            if (rAux.estado) then begin        
                WriteLn('El cliente ya existe');
                Exit;
            end
            else begin
                WriteLn('Se ha encontrado un registro con el codigo del cliente. Se ha dado de alta nuevamente');
                rAux.estado := True;
                seek(datos, filePos(datos)-1);
                write(datos, rAux);
                close(datos);
                Exit;
            end;
        end;

        pos := fileSize(datos);

        // Modifico la referencia al siguiente registro
        rAux.siguiente := pos;
        seek(datos, filePos(datos)-1);
        write(datos, rAux);

        // Agrego el registro al final
        seek(datos, pos);
        write(datos, registro);
    end 
    // Posicion vacia
    else begin
        seek(datos, pos);
        write(datos, registro);
    end;
    
    close(datos);
    WriteLn('El cliente se ha agregado correctamente');
end;

  
end.