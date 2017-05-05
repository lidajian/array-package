package my_text_io with spark_mode is
   IO_State : Integer; -- represents the screen, but never really changed
   procedure put(Item : in String);
   procedure put_line(Item : in String) with Global => (Output => IO_State),
     Depends => (Io_State => Item);
   procedure put(item : in integer; width : in Integer :=0; base : in Integer := 10);
   procedure get(Item : out Integer) with Global => (In_Out => IO_State),
     Depends => (Item => IO_State, IO_State => IO_State);
   procedure new_line;
end my_text_io;
