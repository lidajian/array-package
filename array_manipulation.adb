
pragma spark_mode(on);

with my_text_io;
use my_text_io;

package body array_manipulation is

    procedure print_array(A: In Array_T; Last: In Index) is
    begin
        for K in A'first..Last loop
            put(item => A(K), width => 0, base => 10);
            put(" ");
        end loop;
        put_line("");
    end print_array;

    procedure max(A: In Array_T; Last: In Index; MAX_VAL: Out Integer; MAX_IND: Out Index) is
    begin
        MAX_IND := Index'first;
        MAX_VAL := A(MAX_IND);
        for K in A'first+1..Last loop
            pragma Loop_Invariant
            (
                MAX_VAL = A(MAX_IND)
                and
                (for all II in A'first..K - 1 => A(II) <= MAX_VAL)
            );
            if A(K) > MAX_VAL then
                MAX_VAL := A(K);
                MAX_IND := K;
            end if;
        end loop;
    end max;

    procedure min(A: In Array_T; Last: In Index; MIN_VAL: Out Integer; MIN_IND: Out Index) is
    begin
        MIN_IND := Index'first;
        MIN_VAL := A(MIN_IND);
        for K in A'first+1..Last loop
            pragma Loop_Invariant
            (
                MIN_VAL = A(MIN_IND)
                and
                (for all II in A'first..K - 1 => A(II) >= MIN_VAL)
            );
            if A(K) < MIN_VAL then
                MIN_VAL := A(K);
                MIN_IND := K;
            end if;
        end loop;
    end min;

    procedure max2(A: In Array_T; Last: In Index; MAX_VAL: In Integer; MAX_IND: In Index;
        SEC_MAX_VAL: Out Integer; SEC_MAX_IND: Out Index) is
    begin
        if MAX_IND = Index'first then
            SEC_MAX_IND := Index'first + 1;
            SEC_MAX_VAL := A(SEC_MAX_IND);
        else
            SEC_MAX_IND := Index'first;
            SEC_MAX_VAL := A(SEC_MAX_IND);
        end if;
        for K in A'first+1..Last loop
            pragma Loop_Invariant
            (
                SEC_MAX_VAL = A(SEC_MAX_IND)
                and
                SEC_MAX_VAL <= MAX_VAL
                and
                SEC_MAX_IND /= MAX_IND
                and
                (for all II in A'first..K - 1 => (if (II /= MAX_IND) then A(II) <= SEC_MAX_VAL))
            );
            if K /= MAX_IND and A(K) > SEC_MAX_VAL then
                SEC_MAX_VAL := A(K);
                SEC_MAX_IND := K;
            end if;
        end loop;
    end max2;

    procedure min2(A: In Array_T; Last: In Index; MIN_VAL: In Integer; MIN_IND: In Index;
        SEC_MIN_VAL: Out Integer; SEC_MIN_IND: Out Index) is
    begin
        if MIN_IND = Index'first then
            SEC_MIN_IND := Index'first + 1;
            SEC_MIN_VAL := A(SEC_MIN_IND);
        else
            SEC_MIN_IND := Index'first;
            SEC_MIN_VAL := A(SEC_MIN_IND);
        end if;
        for K in A'first+1..Last loop
            pragma Loop_Invariant
            (
                SEC_MIN_VAL = A(SEC_MIN_IND)
                and
                SEC_MIN_VAL >= MIN_VAL
                and
                SEC_MIN_IND /= MIN_IND
                and
                (for all II in A'first..K - 1 => (if (II /= MIN_IND) then A(II) >= SEC_MIN_VAL))
            );
            if K /= MIN_IND and A(K) < SEC_MIN_VAL then
                SEC_MIN_VAL := A(K);
                SEC_MIN_IND := K;
            end if;
        end loop;
    end min2;

    function ghost_odd(A: Array_T; I: Index) return Integer is
    begin
        if I = A'first then
            return A(I) mod 2;
        else
            return (A(I) mod 2) + ghost_odd(A, I - 1);
        end if;
    end ghost_odd;

    procedure count_odd_even(A: In Array_T; I: In Index; C_ODD: Out Integer; C_EVEN: Out Integer) is
    begin
        C_ODD := 0;
        C_EVEN := 0;
        for K in A'first..I loop
            pragma Loop_Invariant
            (
                C_ODD <= K - 1 and C_ODD >= 0 and C_EVEN <= K - 1 and C_EVEN >= 0 and C_ODD + C_EVEN = K - 1
            );
            if (A(K) mod 2 = 0) then
                C_EVEN := C_EVEN + 1;
            else
                C_ODD := C_ODD + 1;
            end if;
        end loop;
    end count_odd_even;

    function sum(A: Array_T; I: Index) return Integer is
        RET : Integer := 0;
    begin
        for K in A'first..I loop
            pragma Loop_Invariant
            (
                RET >= (K - 1) * Element'first and RET <= (K - 1) * Element'last
            );
            RET := RET + A(K);
        end loop;
        return RET;
    end sum;

    procedure swap(A: In Out Array_T; I: In Index; J: In Index) 
    is
        Temp : Element;
    begin
        Temp := A(I);
        A(I) := A(J);
        A(J) := Temp;
    end swap;

    procedure partition(A: In Out Array_T; P: In Index; R: In Index; Q: Out Index)
    is
        I: Index_Ext;
    begin
        I := P - 1;
        for J in P..R-1 loop
            pragma Loop_Invariant(P - 1 <= I and I < J and J < R);
            pragma Loop_Invariant(for all K in P..I => A(K) <= A(R));
            pragma Loop_Invariant(for all K in I+1..J-1 => A(K) >= A(R));
            if A(J) <= A(R) then
                I := I + 1;
                swap(A, I, J);
            end if;
        end loop;
        swap(A, I + 1, R);
        Q := 1 + I;
    end partition;

    procedure qSort_in(A: In Out Array_T; Start_I: In Index; End_I: In Index; Q: In Index; Is_Left: In Boolean)
    is
        Q_Val : Index;
    begin
        if Start_I >= End_I then
            return;
        end if;
        partition(A, Start_I, End_I, Q_Val);
        if (Q_Val < End_I) then
            qsort_in(A, Q_Val + 1, End_I, Q_Val, false);
        end if;
        if (Q_Val > Start_I) then
            qsort_in(A, Start_I, Q_Val - 1, Q_Val, true);
        end if;
    end qSort_in;

    procedure qSort(A: In Out Array_T; Start_I: In Index; End_I: In Index) is

        Q_Val : Index;
    begin
        if Start_I >= End_I then
            return;
        end if;
        partition(A, Start_I, End_I, Q_Val);
        if Q_Val < End_I then
            qsort_in(A, Q_Val + 1, End_I, Q_Val, false);
        end if;
        if Q_Val > Start_I then
            qsort_in(A, Start_I, Q_Val - 1, Q_Val, true);
        end if;
    end qSort;

    procedure iSort_in(A: In Out Array_T; Start_I: In Index; End_I: In Index) 
    is
        J: Index_Ext;
    begin
        J := End_I;
        while J > Start_I and then A(J-1) > A(J) loop
            swap(A, J, J-1);
            pragma Loop_Invariant(J-1 in Start_I..End_I-1);
            pragma Loop_Invariant(if J > Start_I + 1 then A(J - 2) <= A(J));
            pragma Loop_Invariant(if J > Start_I + 2 then (for all K in Start_I..J-3 => A(K) <= A(K+1)));
            pragma Loop_Invariant(if j > Start_I + 1 and J < End_I then (for all K in J..End_I => A(J-2) <= A(K)));
            pragma Loop_Invariant(for all K in J-1..End_I-1 => A(K) <= A(K+1));
            J := J-1;
        end loop;
    end iSort_in;

    procedure iSort(A: In Out Array_T; Start_I: In Index; End_I: In Index) is
    begin
        for K in Start_I+1..End_I loop
            pragma Loop_Invariant(for all KK in Start_I+1..K-1 => A(KK) >= A(KK-1));
            iSort_in(A, Start_I, K);
        end loop;
    end iSort;
end array_manipulation;
