#
# MEMORY LAYOUT
#     Z0 = 0
#     y  = 121
#     e  = 101
#     s  = 115
#     LF = 10
#     Z1 = 0
#     N  = loop counter
#     Z2 = 0
#

# build text for output
Z0  >
y   >+++++++++++[-<+++++++++++>]
e   >++++++++++[-<++++++++++>]<+>
s   >+++++++++[-<+++++++++++++>]<-->
LF  ++++++++++>>

# input single digit
N   ,
N   [
N       # conver to numeric character to integer
N       >++++++[-<-------->]
Z2  ]
Z2  <

# output text N times
N   [
N       -
N       <<[<]
Z0      >[.>]
Z1      >
N   ]

