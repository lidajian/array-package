pragma spark_mode(on);

with my_text_io;
use my_text_io;
with array_manipulation;
use array_manipulation;

procedure driver is
    procedure increment(I: In Out Index)
    with Pre => (I < Index'last),
         Post => (I = I'old + 1 and I <= Index'last) is
    begin
        I := I + 1;
    end increment;

    procedure print_val_ind(S1: In String; V1: In Integer; S2: In String; V2: In Integer) is
    begin
        put(S1);
        put(item => V1, width => 0, base => 10);
        put(S2);
        put(item => V2, width => 0, base => 10);
        put_line(".");
    end print_val_ind;

    A: Array_T := (others => 0);
    Temp: Integer;
    In_Last: Integer;
    Last: Index;
    Max_Val: Integer;
    Max_Ind: Index;
    Sec_Max_Val: Integer;
    Sec_Max_Ind: Index;
    Min_Val: Integer;
    Min_Ind: Index;
    Sec_Min_Val: Integer;
    Sec_Min_Ind: Index;
    Count_Odd: Integer;
    Count_Even: Integer;
begin
    put_line("Please enter number of integers: ");
    get(item => In_Last);
    if In_Last > Index'last or In_Last < Index'first then
        put_line("Illegal Length!");
        return;
    end if;
    pragma Assert(In_Last <= Index'last);
    put_line("Please enter the integers one by one: ");
    Last := Index'first;
    while Last < In_Last loop
        pragma Loop_Invariant(Last < Index'last);
        pragma Loop_Variant(Increases => Last);
        get(item => Temp);
        if (Temp < Element'first or Temp > Element'last) then
            put_line("Number out of range.");
            return;
        end if;
        pragma Assert(Temp >= Element'first and Temp <= Element'last);
        A(Last) := Temp;
        increment(Last);
    end loop;
    get(item => Temp);
    if (Temp < Element'first or Temp > Element'last) then
        put_line("Number out of range.");
        return;
    end if;
    pragma Assert(Temp >= Element'first and Temp <= Element'last and Last <= Index'last);
    A(Last) := Temp;
    put_line("The array you entered is: ");
    print_array(A, Last);
    max(A, Last, Max_Val, Max_Ind);
    min(A, Last, Min_Val, Min_Ind);
    print_val_ind("The maximum value is ", Max_Val, ", index is ", Max_Ind);
    if Last > Index'first then
        pragma Assert(Last > Index'first);
        max2(A, Last, Max_Val, Max_Ind, Sec_Max_Val, Sec_Max_Ind);
        print_val_ind("The second maximum value is ", Sec_Max_Val, ", index is ", Sec_Max_Ind);
    else
        put_line("The second maximum value does not exist.");
    end if;

    print_val_ind("The minimum value is ", Min_Val, ", index is ", Min_Ind);
    if Last > Index'first then
        pragma Assert(Last > Index'first);
        min2(A, Last, Min_Val, Min_Ind, Sec_Min_Val, Sec_Min_Ind);
        print_val_ind("The second minimum value is ", Sec_Min_Val, ", index is ", Sec_Min_Ind);
    else
        put_line("The second minimum value does not exist.");
    end if;

    count_odd_even(A, Last, Count_Odd, Count_Even);
    put("The number of odd integer is ");
    put(item => Count_Odd, width => 0, base => 10);
    put_line(".");
    put("The number of even integer is ");
    put(item => Count_Even, width => 0, base => 10);
    put_line(".");

    put("The average value of the array is ");
    put(item => (sum(A, Last) / Last), width => 0, base => 10);
    put_line(".");

    if A'first /= Last then
        qsort(A, A'first, Last);
    end if;
    put_line("The array after quick sort is: ");
    print_array(A, Last);

end driver;
