`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    wire First_D, First_B, out;
    
    Half_Subtractor HSUB1 (
        .In_A(In_A), 
        .In_B(In_B), 
        .Difference(First_D), 
        .Borrow_out(First_B)
    );
    
    Half_Subtractor HSUB2 (
        .In_A(First_D), 
        .In_B(Borrow_in), 
        .Difference(Difference), 
        .Borrow_out(out)
    );
    
    or(Borrow_out, out, First_B);
    
endmodule
