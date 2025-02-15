#
# places two zeros as stopper
#
# MEMORY LAYOUT
#     Z0 = 0
#     Z1 = 0
#
Z0      >
Z1      >

#
# read lines
#
# MEMORY LAYOUT
#     I0 = input value
#     F0 = I0 equals to LF then 1 else 0
#     Z0 = 0
#     I1 = input value
#     F1 = I1 equals to LF then 1 else 0
#     Z1 = 0
#        :
#
I0      ,
I0      [
I0          >
F0          +
F0          <
I0          ----------
I0          # if I is not LF
I0          [
I0              >
F0              -
F0              <
I0              ++++++++++
I0              >
I0|F0       ]
I0|F0       >
F0|Z0       # if I is LF
F0|Z0       [
F0              -
F0              <
I0              ++++++++++
I0              >
F0              >
Z0              >
Z0          ]
Z0          <
I1          ,
I0|I1   ]
I0|I1

#
# move pointer to last non zero cell
#
# MEMORY LAYOUT (if Cn is not equals to LF)
#     C0 C1 ** Cn Z0
#                 ^^
#
# MEMORY LAYOUT (if Cn is equals to LF)
#     C0 C1 ** Cn Z0 Z1
#                    ^^
#
Z0|Z1   <
Cn|Z0   [>]
Z0      <
Cn

#
# output lines in reverse order
#
# MEMORY LAYOUT
#     Z0 Cm0 Cm1 ** Cmn Z1 Cn0 Cn1 ** Cnn Z2
#
Cnn     [
Cnn         # move pointer to line head
Cnn         [<]>
Cn0         # output line
Cn0         [.>]
Z2          # move pointer to previous line end
Z2          <[<]<
Z0|Cmn  ]
Z0

