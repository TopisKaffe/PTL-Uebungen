program ueb9;
uses sysutils,dateutils;
{$ASMMODE intel}

const count = 100000000;
type TBuffer = array [1..count] of single;
type TAssem = array[1..8] of single;

procedure fill(var t:TBuffer);
var 
	i:uint64;
begin
	Randomize;
	for i:=1 to count do
		t[i]:=Random;
end;	


function compute(var t:TBuffer):single;
 var cu,i:uint64;
	sum:TAssem;
	summe:double;
 begin
	cu:=count div 8;
	asm
		mov rcx,cu
		mov rdx,t
		vmovups ymm0,[rdx]
		@@schleife:
		vaddps ymm0,ymm0,[rdx]
		add rdx,32
		loop @@schleife
		vmovups sum,ymm0
	end;
	summe:=0;
	for i:=1 to 8 do
		summe:=summe+sum[i];
	compute:=summe/count;	
end;


function computesimpel(var t:TBuffer):single;
 var 
	sum:double;
	i:uint64;

 begin
	sum:=0;
	for i:=0 to count-1 do
		sum:=sum+t[i];
	computesimpel:=sum/count		 
end;	


var
	S : single;
	t : TBuffer;
	z1,z2:TDateTime;
begin
  	fill(t);

	z1:=now;
	s:=computesimpel(t);
	z2:=now;
	writeln('Ergebnis: ',s:0:10);
	writeln('Zeit (ms): ',millisecondsbetween(z1,z2));	


	z1:=now;
	s:=compute(t);
	z2:=now;
	writeln('Ergebnis: ',s:0:10);
	writeln('Zeit (ms): ',millisecondsbetween(z1,z2));	

end.
