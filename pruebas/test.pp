program test;
uses Sysutils;

var Z: Integer;

begin


Try  
  Z := 3 div 0;  
Except  
  On EDivException do Z := 0;  
end;

end.