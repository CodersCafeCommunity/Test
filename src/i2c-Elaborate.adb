with Interfaces.C;
with Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with GNAT.Expect;
with Ada.Strings.Unbounded;use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

package body i2c is
    Result: Unbounded_String;
    R : Integer;
    Input : File_Type;
    procedure write(Chip_Address:String; Register_Address: String; Data:String ) is
        function System (Cmd : String) return Integer is
            function C_System (S : Interfaces.C.char_array) return Integer;
        pragma Import (C, C_System, "system");
        begin
            return C_System (Interfaces.C.To_C (Cmd));        
        end System;
        pragma Inline (System);
        W0: String:="i2cset -y -a 1 ";
        W : Unbounded_String;
    begin
    W := To_Unbounded_String(W0) & " " & To_Unbounded_String(Chip_Address) & " " & To_Unbounded_String(Register_Address) & " " & To_Unbounded_String(Data);
    R := System (To_String(W));
    end write;
    
    function read(Chip_Address:String; Register_Address: String)  return String is
          function System (Cmd : String) return Integer is
            function C_System (S : Interfaces.C.char_array) return Integer;
        pragma Import (C, C_System, "system");
        begin
            return C_System (Interfaces.C.To_C (Cmd));        
        end System;
        pragma Inline (System);
	    R0: String:= "echo $(i2cget -y -a 1 ";
        R,R1 : Unbounded_String;
        Line : String :=" ";
    begin
    R := To_Unbounded_String(R0) & Chip_Address & " " & Register_Address & " b) >> ~/test/bin/a.txt" ;
    R := System(To_String(R));
    Open (File => Input,
         Mode => In_File,
         Name => "a.txt");
    Line := Get_Line (Input);
    Put_Line(Line);
    return Result;
    end read;

end i2c;