with ada.text_io;
with ada.integer_text_io;

package body my_text_io is
   procedure put(Item : in String) is
   begin
      ada.text_io.put(item);
   end put;
   procedure put_line(Item : in String) is
   begin
      ada.text_io.put_line(item);
   end put_line;
   procedure put(item : in integer; width : in Integer :=0; base : in Integer := 10) is
   begin
      ada.integer_text_io.put(item=>item,width=>width,base=>base);
   end put;
   procedure get(Item : out Integer) is
   begin
      ada.integer_text_io.get(item);
   end get;
   procedure new_line is
   begin
      ada.text_io.new_line;
   end new_line;
end my_text_io;
