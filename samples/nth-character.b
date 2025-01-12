#
# memory layout:
#     A B C D S1 0 S2 0 ... Sn 0
#
# usage:
#     A        : input value
#     B        : temporary
#     C        : temporary
#     D        : number
#     S1 .. Sn : input characters
#

# move to S1
A>>>>S1

# S0 to Sn = input characters
,----------[++++++++++>>,----------]Sn

# move to A
Sn<<[<<]<<A

# D = input number
,----------[++++++++++

    # sub 48
    A>B+++++++[-B<A-------A>B]B<A+

    # mul 10
    A>>>D[-D<C++++++++++C>D]D<C[-C>D+D<C]

    # add A to D
    C<<A[-A>>>D+D<<<A]

    # input to A
    A,----------
]

# move to nth character
A>>>D
-[
    -[->>+<<]>>
]>

# print nth character
.

