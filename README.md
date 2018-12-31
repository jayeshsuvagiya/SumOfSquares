# Sum of squares

#Requirements
Input: The input provided (as command line to your program) will be two numbers:N and k.  The overall goal of your program is to find all k consecutive numbers starting at 1 and up to N, such that the sum of squares is itself a perfect square (square of an integer).

Output: Print, on independent lines, the first number in the sequence for eachsolution.
Example 1:
mix run proj1.exs 3 2
3
indicates that sequences of length 2 with start point between 1 and 3 contain 3,4 as a solution since 32+ 42= 52.
Example 2:
mix run proj1.exs 40 24
1 indicates that sequences of length 24 with start point between 1 and 40 contain 1,2,...,24 as a solution since 12+ 22+...+ 242= 702.

Instructions - 
1. Go to the directory /dos-proj1-sos in a terminal
2. run following command, where 'n' and 'k' are inputs for the problem.
   mix run --no-halt proj1.exs <n> <k>
   Eg -  
   mix run --no-halt proj1.exs 40 24

Output - 
1. First number in the sequence for each solution.
    Eg - 
    $ mix run --no-halt proj1.exs 40 24
    Output - 
    1
    9
    20
    25
    

Result of program for $ mix run --no-halt proj1.exs 1000000 4

No such sequence found.


Running time for $ 

Output - time mix run --no-halt proj1.exs 1000000 4
No such sequence found.

real    0m2.543s
user    0m8.272s
sys     0m0.450s

Thus ratio = (8.272+0.450)/2.543 = 3.43 (Note - ran on 4 core machine(8 core with hyperthreading) with 8 workers)

Largest problem solved - 10000000 4

Size of work unit - 
Each worker is given a single sequence to check for out of total sequences in one call.
As giving multiple sequences at a time will require each worker to do more work and thus take more time in a single call.
Moreover in case of failures the amount of work lost is more in later case. Thus it is better to give a single sequence to check in one call.

Special Instructions - 
To change number of workers follow below steps - 
1. edit line number 56 /lib/sosc/application.ex

