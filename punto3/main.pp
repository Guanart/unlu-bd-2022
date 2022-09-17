program db;

uses sysutils, strutils;

const
	META_COUNT_SIZE =  2;
	META_NAME_SIZE  = 32;
	META_SIZE_SIZE  =  4;

type
	Meta = record
		name: String[META_NAME_SIZE];
		size: String[META_SIZE_SIZE];
	end;

	Metadata = array of Meta;

var
  TXT_FILE: 	TextFile;
	
  S_FILENAME: String;
  S_AUX: String;
  I_OPT: Integer;

	(* Variables de UNLuDB *)
  META_SIZE_STR: String[META_COUNT_SIZE];
  META_SIZE: Integer;
  META_CURR: Integer;
  META_DATA: Metadata;
	
	I, j,auxint: Integer;//Mis Variables
	linea, dato, aux, datoaux: String;
	TXT_AUX: TextFile;

begin
	I_OPT := 0;
	setLength(META_DATA, 0);

	while (I_OPT <> 7) do
		begin
			WriteLn('');
			WriteLn('---');
			WriteLn('');
			WriteLn('> 1. Nueva DB');
			WriteLn('> 2. Abrir DB');
			WriteLn('> 3. Ingresar datos');
			WriteLn('> 4. Borrar datos');
			WriteLn('> 5. Modificar datos');
			WriteLn('> 6. Abrir datos');
			WriteLn('> 7. Salir');
			Write('> ');
			ReadLn(S_AUX);
			WriteLn('');
			I_OPT := StrToInt(S_AUX);

			if (I_OPT = 1) then
				begin
					Write('> DB: ');
					ReadLn(S_FILENAME);
					WriteLn('');

					Write('> Cantidad de campos [01-99]: ');
					ReadLn(META_SIZE_STR);
					WriteLn('');
					META_SIZE_STR := Trim(META_SIZE_STR);
					META_SIZE := StrToInt(META_SIZE_STR);
					setLength(META_DATA, META_SIZE);

					META_CURR := 0;
					while META_CURR < META_SIZE do
						begin
							Write('> Nombre: ');
							ReadLn(S_AUX);
							META_DATA[META_CURR].name := S_AUX;
							Write('> Longitud: ');
							ReadLn(S_AUX);
							META_DATA[META_CURR].size := S_AUX;
							WriteLn('');
							META_CURR := META_CURR + 1;
						end;

					Assign(TXT_FILE, S_FILENAME);
					Rewrite(TXT_FILE);
					WriteLn(TXT_FILE, PadRight(META_SIZE_STR, META_COUNT_SIZE));
					
					META_CURR := 0;
					while META_CURR < META_SIZE do
						begin
							Write(TXT_FILE, PadRight(META_DATA[META_CURR].name, META_NAME_SIZE));
							WriteLn(TXT_FILE, PadRight(META_DATA[META_CURR].size, META_SIZE_SIZE));
							META_CURR := META_CURR + 1;
						end;
					Close(TXT_FILE);
				end;

			if (I_OPT = 2) then
				begin
					Write('> DB: ');
					ReadLn(S_FILENAME);
					WriteLn('');
					
					Assign(TXT_FILE, S_FILENAME);
					Reset(TXT_FILE);
					
					ReadLn(TXT_FILE, META_SIZE_STR);
					META_SIZE_STR := Trim(META_SIZE_STR);
					META_SIZE := StrToInt(META_SIZE_STR);
					setLength(META_DATA, META_SIZE);
					
					META_CURR := 0;
					while META_CURR < META_SIZE do
						begin
							ReadLn(TXT_FILE, S_AUX);
							META_DATA[META_CURR].name := copy(S_AUX, 1, META_NAME_SIZE);
							META_DATA[META_CURR].size := copy(S_AUX, 1 + META_NAME_SIZE, META_SIZE_SIZE);
							META_CURR := META_CURR + 1;
						end;
					Close(TXT_FILE);
					
					Write('Campos: ');
					WriteLn(META_SIZE);
					WriteLn('');		
					
					META_CURR := 0;	
					while META_CURR < META_SIZE do
						begin
							Write('#');
							WriteLn(META_CURR);
							WriteLn(META_DATA[META_CURR].name);
							WriteLn(META_DATA[META_CURR].size);
							META_CURR := META_CURR + 1;
						end;
				end;
			
			if (I_OPT = 3) then						
			begin

				Write('> DB: ');
				ReadLn(S_FILENAME);
				WriteLn('');
					
				Assign(TXT_FILE, S_FILENAME);
				Reset(TXT_FILE); 
				ReadLn(TXT_FILE, META_SIZE_STR);
				META_SIZE_STR := Trim(META_SIZE_STR);
				META_SIZE := StrToInt(META_SIZE_STR);
				Dato:= '';

				for I:=1 to META_SIZE do
					begin
						readLn(TXT_FILE, aux);
						linea:='';
						Datoaux:='';
						for j:= 1 to META_NAME_SIZE do
						begin
							linea:= linea + aux[j];
							 
						end;
						for j:=META_NAME_SIZE  to META_NAME_SIZE + META_SIZE_SIZE do
						begin
							Datoaux:= Datoaux + aux[J];
						
						end;

						WriteLn('Ingresar ' + trim(linea));
						ReadLn(linea);
						Dato:= Dato + PadRight(linea,StrToInt(trim(Datoaux)));

					end;
				close(TXT_FILE);
				Assign(TXT_FILE, S_FILENAME);
				append(TXT_FILE);
				Writeln(TXT_FILE,Dato);
				writeln('');

				close(TXT_FILE);
			end;

			if (I_OPT = 4) then 
			begin

				Write('> DB: ');
				ReadLn(S_FILENAME);
				WriteLn('');
					
				Assign(TXT_FILE, S_FILENAME);
				Reset(TXT_FILE); 
				Assign(TXT_AUX, 'TXT_AUX.txt');				
				Rewrite(TXT_AUX); 
				ReadLn(TXT_FILE, META_SIZE_STR);
				writeln(TXT_AUX, META_SIZE_STR);
				META_SIZE_STR := Trim(META_SIZE_STR);
				META_SIZE := StrToInt(META_SIZE_STR);

				for I:=1 to META_SIZE do begin
				readln(TXT_FILE,dato);
				writeln(TXT_AUX, dato);
				end;

				Writeln('> Escriba posicion a borrar ');
				ReadLn(aux);
				auxint:= META_SIZE + StrToInt(aux);
				WriteLn('');

				j:=META_SIZE + 1;
				while not (Eof(TXT_FILE)) do
				begin
					WriteLn('1');
					ReadLn(TXT_FILE,dato);

					if not(auxint = j) then begin	
					writeln(TXT_AUX, dato);	
					Writeln('3');
					end;	
					
					j:= j + 1;
				end;				
				close(TXT_FILE);
				close(TXT_AUX);
//				DeleteFile(TXT_FILE);
//				Rename(TXT_AUX,TXT_FILE);
			
			end;

			if (I_OPT = 5) then 
			begin
				Write('> DB: ');
				ReadLn(S_FILENAME);
				WriteLn('');
					
				Assign(TXT_FILE, S_FILENAME);
				Reset(TXT_FILE); 
				Assign(TXT_AUX, 'TXT_AUX.txt');				
				Rewrite(TXT_AUX); 
				ReadLn(TXT_FILE, META_SIZE_STR);
				writeln(TXT_AUX, META_SIZE_STR);
				META_SIZE_STR := Trim(META_SIZE_STR);
				META_SIZE := StrToInt(META_SIZE_STR);

				for I:=1 to META_SIZE do begin
				readln(TXT_FILE,dato);
				writeln(TXT_AUX, dato);
				end;

				Writeln('> Escriba posicion a borrar ');
				ReadLn(aux);
				auxint:= META_SIZE + StrToInt(aux);
				WriteLn('');

				j:=META_SIZE + 1;
				while not (Eof(TXT_FILE)) do
				begin
					WriteLn('1');
					ReadLn(TXT_FILE,dato);

					if not(auxint = j) then begin	
						writeln(TXT_AUX, dato);	
						Writeln('3');
					end

					else
					begin

					end;	

					
					j:= j + 1;
				end;				
				close(TXT_FILE);
				close(TXT_AUX);
//				DeleteFile(TXT_FILE);
//				Rename(TXT_AUX,S_FILENAME);
			
			end;
			if (I_OPT = 6) then 
			begin
				Write('> DB: ');
				ReadLn(S_FILENAME);
				WriteLn('');
					
				Assign(TXT_FILE, S_FILENAME);
				Reset(TXT_FILE); 
				Assign(TXT_AUX, 'TXT_AUX.txt');				
				Rewrite(TXT_AUX); 
				ReadLn(TXT_FILE, META_SIZE_STR);
				writeln(TXT_AUX, META_SIZE_STR);
				META_SIZE_STR := Trim(META_SIZE_STR);
				META_SIZE := StrToInt(META_SIZE_STR);

				for I:=1 to META_SIZE do begin
					readln(TXT_FILE,dato);
				end;

				while not (eof(TXT_FILE)) do begin
					readln(TXT_FILE,dato);
				    Writeln(dato)
				end;
				close(TXT_FILE);
			end;

	
		end;
		
  //TextColor(NormVideo);		
end.