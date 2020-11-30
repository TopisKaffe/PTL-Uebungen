program ueb8;
uses crt;

type TByteArray = array [1..1024] of byte;

  {$L formatarray.o}
  procedure formatarray(var dest:TByteArray;value:byte;len:word);  external name 'formatarray';


  procedure ArrayAusgabe(b:TByteArray);
  var i: integer;
  begin
    for i:=1 to 15 do
        write(b[i],' ');
        writeln;
  end;

var

  b : TByteArray;
  p : byte;

begin

  FormatArray(b,255,1024);
  ArrayAusgabe(b);
  FormatArray(b,128,9);
  ArrayAusgabe(b);
  FormatArray(b,0,0);
  ArrayAusgabe(b);
  FormatArray(b,42,1);
  ArrayAusgabe(b);
  p:=Ord(ReadKey);

end.

