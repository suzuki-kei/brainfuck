#
# memory layout:
#     Z0 Cn I F
#
# usage:
#     Z0 : 0
#     Cn : buffered characters
#     I  : input value
#     F  : if input value is LF then 1 else 0
#

Z0  >
Cn  >
I   ,
I   [>
F       +<
I       ----------
I       [>
F           -<
I           [-<
Cn              +>
I           ]
I       ]<
Cn      ++++++++++>>
F       [-<<
Cn          [-]<
Cn          [.[-]<]
Z0          >
Cn          ++++++++++.[-]>
I       ]
I       ,
I   ]<

# momory layout if last input ends with LF:
#     Z0 Z1
# momory layout if last input not ends with LF:
#     Z0 Cn Z1
Z1  <[.[-]<]
Z0

