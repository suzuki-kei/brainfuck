#
# memory layout:
#     C T1 I T2
#
# usage:
#     C  : character to output
#     T1 : temporary
#     I  : input value
#     T2 : temporary
#

# C = 65
C++++++++[-C>T1++++++++T1<C]C>A+

# I = input
A>>I,

# I = I sub 48
I>T2++++++[-T2<I--------I>T2]T2<I

# print loop
[-I<<C.C>>I]

