#
# prepare characters
#
# MEMORY LAYOUT
#     0 = 0
#     0 = 0
#     a = 97
#     0 = 0
#     b = 98
#     0 = 0
#     :
#     z = 122
#     0 = 0
#
0  >
0  >
a  >++++++++[-<++++++++++++>]<+>>
b  >+++++++[-<++++++++++++++>]>
c  >+++++++++[-<+++++++++++>]>
d  >++++++++++[-<++++++++++>]>
e  >++++++++++[-<++++++++++>]<+>>
f  >++++++++++[-<++++++++++>]<++>>
g  >++++++++[-<+++++++++++++>]<->>
h  >++++++++[-<+++++++++++++>]>
i  >+++++++[-<+++++++++++++++>]>
j  >+++++++[-<+++++++++++++++>]<+>>
k  >+++++++++[-<++++++++++++>]<->>
l  >+++++++++[-<++++++++++++>]>
m  >+++++++++[-<++++++++++++>]<+>>
n  >++++++++++[-<+++++++++++>]>
o  >++++++++++[-<+++++++++++>]<+>>
p  >++++++++[-<++++++++++++++>]>
q  >++++++++[-<++++++++++++++>]<+>>
r  >++++++++[-<++++++++++++++>]<++>>
s  >+++++++++[-<+++++++++++++>]<-->>
t  >+++++++++[-<+++++++++++++>]<->>
u  >+++++++++[-<+++++++++++++>]>
v  >+++++++++[-<+++++++++++++>]<+>>
w  >++++++++++[-<++++++++++++>]<->>
x  >++++++++++[-<++++++++++++>]>
y  >+++++++++++[-<+++++++++++>]>
z  >+++++++++++[-<+++++++++++>]<+>
0

#
# input N
#
# MEMORY LAYOUT
#     0 = 0
#     0 = 0
#     a = 97
#     0 = 0
#     b = 98
#     0 = 0
#     :
#     z = 122
#     N = print Nth character
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
I   <
N

#
# move the value of Nn to N1
#
# MEMORY LAYOUT
#     Z  = 0
#     N1 = 0
#     :
#     Cp = the character before Cn
#     Np = the N before Nn
#     Cn = the character to focus in current loop
#     Nn = the N to focus in current loop
#
Nn  <
Cn  [
Cn      >
Nn       [-<<+>>]
Nn       <<<
Cp  ]
Z

#
# print Nth character
#
# MEMORY LAYOUT
#     Z  = 0
#     N1 = Nth
#     C1 = first character
#     N2 = N1 sub 1
#     C2 = second character
#     N3 = N2 sub 1
#     C3 = third character
#     :
#     Nn = 0
#     Cn = the Nth character
#
Z   >
N1  [
N1      -
N1      [
N1          -
N1          [->>+<<]
N1          >>
Nn      ]
Nn      >
Cn      .
Cn      <
Nn  ]

# print LF
Nn  ++++++++++.[-]

