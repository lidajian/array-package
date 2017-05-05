pragma spark_mode(on);

package array_manipulation is

    MAX_CAPACITY :constant Integer := 100;
    ELEMENT_MIN :constant Integer := -21474836;
    ELEMENT_MAX :constant Integer := 21474836;

    subtype Element is Integer range ELEMENT_MIN..ELEMENT_MAX;

    subtype Index is Integer range 1..MAX_CAPACITY;
    subtype Index_Ext is Integer range 0..MAX_CAPACITY + 1;

    type Array_T is array(Index) of Element;

    procedure print_array(A: In Array_T; Last: In Index);

    procedure max(A: In Array_T; Last: In Index; MAX_VAL: Out Integer; MAX_IND: Out Index) 
    with Post => 
    (
        MAX_VAL = A(MAX_IND)
        and
        (for all II in A'first..Last => A(II) <= MAX_VAL)
    );

    procedure min(A: In Array_T; Last: In Index; MIN_VAL: Out Integer; MIN_IND: Out Index) 
    with Post => 
    (
        MIN_VAL = A(MIN_IND)
        and
        (for all II in A'first..Last => A(II) >= MIN_VAL)
    );

    procedure max2(A: In Array_T; Last: In Index; MAX_VAL: In Integer; MAX_IND: In Index;
        SEC_MAX_VAL: Out Integer; SEC_MAX_IND: Out Index)
    with Pre => (Last > A'first and (for all II in A'first..Last => A(II) <= MAX_VAL)),
    Post =>
    (
        SEC_MAX_VAL = A(SEC_MAX_IND)
        and
        SEC_MAX_VAL <= MAX_VAL
        and
        SEC_MAX_IND /= MAX_IND
        and
        (for all II in A'first..Last => (if (II /= MAX_IND) then A(II) <= SEC_MAX_VAL))
    );

    procedure min2(A: In Array_T; Last: In Index; MIN_VAL: In Integer; MIN_IND: In Index;
        SEC_MIN_VAL: Out Integer; SEC_MIN_IND: Out Index)
    with Pre => (Last > A'first and (for all II in A'first..Last => A(II) >= MIN_VAL)),
    Post =>
    (
        SEC_MIN_VAL = A(SEC_MIN_IND)
        and
        SEC_MIN_VAL >= MIN_VAL
        and
        SEC_MIN_IND /= MIN_IND
        and
        (for all II in A'first..Last => (if (II /= MIN_IND) then A(II) >= SEC_MIN_VAL))
    );

    function ghost_odd(A: Array_T; I: Index) return Integer 
    with Post => (
    ghost_odd'Result <= I and
    (
    (if I = A'first and A(I) rem 2 = 0 then ghost_odd'Result = 0)
    or
    (if I = A'first and A(I) rem 2 /= 0 then ghost_odd'Result = 1)
    or
    (if I /= A'first and A(I) rem 2 = 0 then ghost_odd'Result = ghost_odd(A, I - 1))
    or
    (if I /= A'first and A(I) rem 2 /= 0 then ghost_odd'Result = ghost_odd(A, I - 1) + 1)
    )
    );

    procedure count_odd_even(A: In Array_T; I: In Index; C_ODD: Out Integer; C_EVEN: Out Integer)
    with Post =>
    (
        C_ODD <= I and C_ODD >= 0 and C_EVEN <= I and C_EVEN >= 0 and C_ODD + C_EVEN = I
    );

    function sum(A: Array_T; I: Index) return Integer 
    with Post => (sum'Result >= I * Element'first and sum'Result <= I * Element'last);

    procedure swap(A: In Out Array_T; I: In Index; J: In Index) 
    with Post => 
    (
        (for all K in A'first..A'last => (if K /= I and K /= J then A(K) = A'old(K)))
        and A(I) = A'old(J) and A'old(I) = A(J)
    );

    -- Implementation of quick sort (Unproved)

    procedure partition(A: In Out Array_T; P: In Index; R: In Index; Q: Out Index)
    with Pre => (P <= R),
    Post => 
    (
        P <= Q and Q <= R
        and (for all K in P..Q => A(K) <= A(Q))
        and (for all K in Q..R => A(K) >= A(Q))
    );

    procedure qSort_in(A: In Out Array_T; Start_I: In Index; End_I: In Index; Q: In Index; Is_Left: In Boolean)
    with Pre => ((for all K in Start_I..End_I => (if Is_Left then A(K) <= A(Q) else A(K) >= A(Q)))),
    Post => 
    (
        (if Is_Left then (for all K in Start_I+1..Q => A(K) >= A(K-1)) else (for all K in Q..End_I-1 => A(K+1) >= A(K)))
        and
        (for all K in A'first..A'last => (if not (K in Start_I..End_I) then A(K) = A'old(K)))
    );

    procedure qSort(A: In Out Array_T; Start_I: In Index; End_I: In Index)
    with Pre => (Start_I < End_I),
         Post => 
    (
        (for all K in Start_I+1..End_I => A(K) >= A(K-1))
    );

    -- Implementation of insertion sort (Proved)

    procedure iSort_in(A: In Out Array_T; Start_I: In Index; End_I: In Index)
    with Pre => (for all K in Start_I+1..End_I-1 => A(K) >= A(K-1)),
    Post => 
    (
        for all K in Start_I..End_I-1 => A(K+1) >= A(K)
    );


    procedure iSort(A: In Out Array_T; Start_I: In Index; End_I: In Index)
    with Pre => (Start_I < End_I),
        Post => 
    (
        for all K in Start_I+1..End_I => A(K) >= A(K-1)
    );

end array_manipulation;
