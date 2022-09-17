program main;

Uses sysutils, archivo;

var arch: TArchivo;
    input: String;
    r: TRegistro;
    pos: Integer;

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
        inputRegistro := True;
    end;

    procedure inputPosicion();
    begin
        WriteLn('Ingrese posicion fisica del registro a eliminar [0, n): ');
        readln(pos);
    end;


begin

repeat begin
    WriteLn('Escriba 1 para crear un nuevo archivo (data.dat)');
    WriteLn('Escriba 2 para leer un archivo existente (data.dat)');
    WriteLn('Escriba 3 para agregar un registro de cliente');
    WriteLn('Escriba 4 para borrar un registro de cliente (por posicion fisica [0, n])');
    WriteLn('Escriba 5 para modificar un registro de cliente');
    WriteLn('Escriba 0 para salir');
    readLn(input);
    
    if (input = '1') then begin
        arch.crearArchivo();
    end
    else if (input = '2') then begin
        arch.leer();
    end
    else if (input = '3') then begin
        if inputRegistro() then arch.agregar(r);
    end
    else if (input = '4') then begin
        inputPosicion();
        arch.eliminar(pos);
    end
    else if (input = '5') then begin
        inputPosicion();
        if inputRegistro() then arch.modificar(pos, r);
    end;
    
    WriteLn();
end
until (input = '0');

end.