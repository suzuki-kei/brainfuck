#
# MEMORY LAYOUT
#     N = number
#     I = input value
#     T = temporary
#

N   >
I   ,
I   [
I       [
I           # I = I sub LF
I           ----------
I           [
I               # I = I add LF
I               ++++++++++
I               # I = I sub 48
I               >
T               ++++++[-<-------->]
T               # T = N mul 10
T               <<
N               [->>++++++++++<<]
N               # T = T add I
N               >
I               [->+<]
I               # N = T
I               >
T               [-<<+>>]
T               <
I           ]
I           ,
I       ]
I   ]

