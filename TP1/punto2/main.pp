program main;

Uses sysutils, archivo;

var arch: TArchivo;
    input: String;
    r: TRegistro;
    codigo: Integer;

    function inputRegistro(): Boolean;
    begin
        WriteLn('Ingrese codigo cliente: ');
        readln(r.cliente);
        if r.cliente <= 0 then begin
            WriteLn('Ingrese un numero de cliente mayor a 0');  
            inputRegistro := False;
            Exit;
        end;
        WriteLn('Ingrese nombre cliente: ');
        readln(r.nombre);
        WriteLn('Ingrese apellido cliente: ');
        readln(r.apellido);
        r.siguiente := -1;
        r.estado := True;
        inputRegistro := True;
    end;

    procedure inputCodigo();
    begin
        WriteLn('Ingrese codigo del cliente: ');
        readln(codigo);
    end;


begin

repeat begin
    WriteLn('Escriba 1 para crear un nuevo archivo (data.dat)');
    WriteLn('Escriba 2 para leer un archivo existente (data.dat)');
    WriteLn('Escriba 3 para buscar un registro de cliente');
    WriteLn('Escriba 4 para dar de alta un cliente');
    WriteLn('Escriba 5 para borrar un registro de cliente');
    WriteLn('Escriba 6 para modificar un registro de cliente');
    WriteLn('Escriba 0 para salir');
    readLn(input);
    
    if (input = '1') then begin
        arch.crearArchivo();
    end
    else if (input = '2') then begin
        arch.leer();
    end
    else if (input = '3') then begin
        inputCodigo();
        arch.buscar(codigo);
    end
    else if (input = '4') then begin
        if inputRegistro() then arch.alta(r);
    end
    else if (input = '5') then begin
        inputCodigo();
        arch.eliminar(codigo);
    end
    else if (input = '6') then begin
        if inputRegistro() then arch.modificar(r);
    end;
    
    WriteLn('-----------------------------------------------------------------');
end
until (input = '0');

end.