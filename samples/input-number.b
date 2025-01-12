#
# memory layout:
#     N T1 I T2
#
# usage:
#     N  : number
#     T1 : temporary
#     I  : input value
#     T2 : temporary
#

# move to I
N>>I

# I = input
I,

[
    # I = I sub 48
    I>T2+++++++[-T2<I-------I>T2]T2<I+

    # N = N mul 10
    I<<N[-N>T1++++++++++T1<N]N>T1[-T1<N+N>T1]

    # N = N add I
    T1>I[-I<<N+N>>I]

    # I = input
    I,
]

