BEGIN_PROVIDER  [ integer, det_i ]
  
  BEGIN_DOC
  ! Current running alpha determinant
  END_DOC
  det_i=det_alpha_order(1)
  
END_PROVIDER

BEGIN_PROVIDER  [ integer, det_j ]
  
  BEGIN_DOC
  ! Current running beta determinant
  END_DOC
  det_j=det_beta_order(1)
  
END_PROVIDER

subroutine det_update(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m(LDS) ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,n)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,n) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  if (d == 0.d0) then
    return
  endif
  select case (n)
      case default
      call det_update_general(n,LDS,m,l,S,S_inv,d)
    BEGIN_TEMPLATE
      case ($n)
        call det_update$n(n,LDS,m,l,S,S_inv,d)
    SUBST [n]
    1;;
    2;;
    3;;
    4;;
    5;;
    6;;
    7;;
    8;;
    9;;
    10;;
    11;;
    12;;
    13;;
    14;;
    15;;
    16;;
    17;;
    18;;
    19;;
    20;;
    21;;
    22;;
    23;;
    24;;
    25;;
    26;;
    27;;
    28;;
    29;;
    30;;
    31;;
    32;;
    33;;
    34;;
    35;;
    36;;
    37;;
    38;;
    39;;
    40;;
    41;;
    42;;
    43;;
    44;;
    45;;
    46;;
    47;;
    48;;
    49;;
    50;;
    51;;
    52;;
    53;;
    54;;
    55;;
    56;;
    57;;
    58;;
    59;;
    60;;
    61;;
    62;;
    63;;
    64;;
    65;;
    66;;
    67;;
    68;;
    69;;
    70;;
    71;;
    72;;
    73;;
    74;;
    75;;
    76;;
    77;;
    78;;
    79;;
    80;;
    81;;
    82;;
    83;;
    84;;
    85;;
    86;;
    87;;
    88;;
    89;;
    90;;
    91;;
    92;;
    93;;
    94;;
    95;;
    96;;
    97;;
    98;;
    99;;
    100;;
    101;;
    102;;
    103;;
    104;;
    105;;
    106;;
    107;;
    108;;
    109;;
    110;;
    111;;
    112;;
    113;;
    114;;
    115;;
    116;;
    117;;
    118;;
    119;;
    120;;
    121;;
    122;;
    123;;
    124;;
    125;;
    126;;
    127;;
    128;;
    129;;
    130;;
    131;;
    132;;
    133;;
    134;;
    135;;
    136;;
    137;;
    138;;
    139;;
    140;;
    141;;
    142;;
    143;;
    144;;
    145;;
    146;;
    147;;
    148;;
    149;;
    150;;
    END_TEMPLATE
  end select
end

subroutine det_update2(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m(2)   ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,2)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,2) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  S(1,l) = m(1)
  S(2,l) = m(2)
  S_inv(1,1) = S(1,1)
  S_inv(1,2) = S(2,1)
  S_inv(2,1) = S(1,2)
  S_inv(2,2) = S(2,2)
  call invert2(S_inv,LDS,n,d)
  
end

subroutine det_update1(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m(1)   ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,1)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,1) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  S(1,l) = m(1)
  S_inv(1,1) = S(1,1)
  call invert1(S_inv,LDS,n,d)
  
end

subroutine det_update3(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m(3)   ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,3)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,3) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  integer                        :: i
  do i=1,3
    S(i,l) = m(i)
  enddo
  do i=1,3
    S_inv(1,i) = S(i,1)
    S_inv(2,i) = S(i,2)
    S_inv(3,i) = S(i,3)
  enddo
  
  call invert3(S_inv,LDS,n,d)
  
end

subroutine det_update4(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m(4)   ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,4)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,4) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  double precision               :: u(4), z(4), w(4), lambda, d_inv
  !DIR$ ATTRIBUTES ALIGN : $IRP_ALIGN :: z, w, u
  integer                        :: i,j
  u(1) = m(1) - S(1,l)
  u(2) = m(2) - S(2,l)
  u(3) = m(3) - S(3,l)
  u(4) = m(4) - S(4,l)
  z(1) = S_inv(1,1)*u(1) + S_inv(2,1)*u(2) + S_inv(3,1)*u(3) + S_inv(4,1)*u(4)
  z(2) = S_inv(1,2)*u(1) + S_inv(2,2)*u(2) + S_inv(3,2)*u(3) + S_inv(4,2)*u(4)
  z(3) = S_inv(1,3)*u(1) + S_inv(2,3)*u(2) + S_inv(3,3)*u(3) + S_inv(4,3)*u(4)
  z(4) = S_inv(1,4)*u(1) + S_inv(2,4)*u(2) + S_inv(3,4)*u(3) + S_inv(4,4)*u(4)
  
  d_inv = 1.d0/d
  d = d+z(l)
  lambda = d_inv*d
  if (dabs(lambda) < 1.d-3) then
    d = 0.d0
    return
  endif
  
  !DIR$ VECTOR ALIGNED
  do i=1,4
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo

  do i=1,4
   !DIR$ VECTOR ALIGNED
   do j=1,4
    S_inv(j,i) = S_inv(j,i)*lambda -z(i)*w(j)
   enddo
  enddo
  
end

BEGIN_TEMPLATE
! Version for mod(n,4) = 0
subroutine det_update$n(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m($n)  ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,$n)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,$n) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  double precision               :: u($n), z($n), w($n), lambda, d_inv
  !DIR$ ATTRIBUTES ALIGN : $IRP_ALIGN :: z, w, u
  !DIR$ ASSUME_ALIGNED S : $IRP_ALIGN
  !DIR$ ASSUME_ALIGNED S_inv : $IRP_ALIGN
  !DIR$ ASSUME (mod(LDS,$IRP_ALIGN/8) == 0)
  !DIR$ ASSUME (LDS >= $n)
  integer                        :: i,j
  double precision :: zj, zj1, zj2, zj3
  
  !DIR$ NOPREFETCH
  !DIR$ SIMD NOVECREMAINDER
  do i=1,$n
    u(i) = m(i) - S(i,l)
  enddo
  
  zj = 0.d0
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj) NOVECREMAINDER
  do i=1,$n-1,4
    zj = zj + S_inv(i,l)*u(i) + S_inv(i+1,l)*u(i+1)  &
            + S_inv(i+2,l)*u(i+2) + S_inv(i+3,l)*u(i+3) 
  enddo

  d_inv = 1.d0/d
  d = d+zj
  lambda = d*d_inv
  if (dabs(lambda) < 1.d-3) then
    d = 0.d0
    return
  endif
  
  !DIR$ VECTOR ALIGNED
  do j=1,$n,4
   zj  = 0.d0
   zj1 = 0.d0
   zj2 = 0.d0
   zj3 = 0.d0
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD REDUCTION(+:zj,zj1,zj2,zj3) NOVECREMAINDER
   do i=1,$n
    zj  = zj  + S_inv(i,j  )*u(i)
    zj1 = zj1 + S_inv(i,j+1)*u(i)
    zj2 = zj2 + S_inv(i,j+2)*u(i)
    zj3 = zj3 + S_inv(i,j+3)*u(i)
   enddo
   z(j  ) = zj  
   z(j+1) = zj1 
   z(j+2) = zj2 
   z(j+3) = zj3
  enddo

  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(d_inv) NOVECREMAINDER
  do i=1,$n
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo
  
  do i=1,$n,4
   zj  = z(i  )
   zj1 = z(i+1)
   zj2 = z(i+2)
   zj3 = z(i+3)
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1,zj2,zj3) NOVECREMAINDER
   do j=1,$n
    S_inv(j,i  ) = S_inv(j,i  )*lambda - w(j)*zj
    S_inv(j,i+1) = S_inv(j,i+1)*lambda - w(j)*zj1
    S_inv(j,i+2) = S_inv(j,i+2)*lambda - w(j)*zj2
    S_inv(j,i+3) = S_inv(j,i+3)*lambda - w(j)*zj3
   enddo
  enddo

end

SUBST [ n ]
8 ;;
12 ;;
16 ;;
20 ;;
24 ;;
28 ;;
32 ;;
36 ;;
40 ;;
44 ;;
48 ;;
52 ;;
56 ;;
60 ;;
64 ;;
68 ;;
72 ;;
76 ;;
80 ;;
84 ;;
88 ;;
92 ;;
96 ;;
100 ;;
104 ;;
108 ;;
112 ;;
116 ;;
120 ;;
124 ;;
128 ;;
132 ;;
136 ;;
140 ;;
144 ;;
148 ;;

END_TEMPLATE

BEGIN_TEMPLATE
! Version for mod(n,4) = 1
subroutine det_update$n(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m($n)  ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,$n)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,$n) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  double precision               :: u($n), z($n), w($n), lambda, d_inv
  !DIR$ ATTRIBUTES ALIGN : $IRP_ALIGN :: z, w, u
  !DIR$ ASSUME_ALIGNED S : $IRP_ALIGN
  !DIR$ ASSUME_ALIGNED S_inv : $IRP_ALIGN
  !DIR$ ASSUME (mod(LDS,$IRP_ALIGN/8) == 0)
  !DIR$ ASSUME (LDS >= $n)
  integer                        :: i,j
  double precision :: zj, zj1, zj2, zj3
  
  do i=1,$n
    u(i) = m(i) - S(i,l)
  enddo

  zj = 0.d0
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj)
  do i=1,$n-1,4
    zj = zj + S_inv(i,l)*u(i) + S_inv(i+1,l)*u(i+1)  &
            + S_inv(i+2,l)*u(i+2) + S_inv(i+3,l)*u(i+3) 
  enddo
  zj = zj + S_inv($n,l)*u($n)
  
  d_inv = 1.d0/d
  d = d+zj
  lambda = d*d_inv
  if (dabs(lambda) < 1.d-6) then
    d = 0.d0
    write(502,"('#BREAKDOWN_OCCURED')")
    return
  end if
  
  !DIR$ VECTOR ALIGNED
  do j=1,$n-1,4
   zj  = 0.d0
   zj1 = 0.d0
   zj2 = 0.d0
   zj3 = 0.d0
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD REDUCTION(+:zj,zj1,zj2,zj3) NOVECREMAINDER
   do i=1,$n-1
    zj  = zj  + S_inv(i,j  )*u(i)
    zj1 = zj1 + S_inv(i,j+1)*u(i)
    zj2 = zj2 + S_inv(i,j+2)*u(i)
    zj3 = zj3 + S_inv(i,j+3)*u(i)
   enddo
   z(j  ) = zj  + S_inv($n,j  )*u($n)
   z(j+1) = zj1 + S_inv($n,j+1)*u($n)
   z(j+2) = zj2 + S_inv($n,j+2)*u($n)
   z(j+3) = zj3 + S_inv($n,j+3)*u($n)
  enddo

  zj  = 0.d0
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj) NOVECREMAINDER
  do i=1,$n-1
   zj = zj + S_inv(i,$n)*u(i)
  enddo
  z($n) = zj + S_inv($n,$n)*u($n)

  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(d_inv) NOVECREMAINDER
  do i=1,$n
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo
  
  do i=1,$n-1,4
   zj  = z(i  )
   zj1 = z(i+1)
   zj2 = z(i+2)
   zj3 = z(i+3)
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1,zj2,zj3) NOVECREMAINDER
   do j=1,$n-1
    S_inv(j,i  ) = S_inv(j,i  )*lambda - w(j)*zj
    S_inv(j,i+1) = S_inv(j,i+1)*lambda - w(j)*zj1
    S_inv(j,i+2) = S_inv(j,i+2)*lambda - w(j)*zj2
    S_inv(j,i+3) = S_inv(j,i+3)*lambda - w(j)*zj3
   enddo
   S_inv($n,i  ) = S_inv($n,i  )*lambda - w($n)*zj 
   S_inv($n,i+1) = S_inv($n,i+1)*lambda - w($n)*zj1
   S_inv($n,i+2) = S_inv($n,i+2)*lambda - w($n)*zj2
   S_inv($n,i+3) = S_inv($n,i+3)*lambda - w($n)*zj3
  enddo

  zj = z($n)
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(lambda,zj) NOVECREMAINDER
  do i=1,$n
   S_inv(i,$n) = S_inv(i,$n)*lambda -w(i)*zj
  enddo


end

SUBST [ n ]
5 ;;
9 ;;
13 ;;
17 ;;
21 ;;
25 ;;
29 ;;
33 ;;
37 ;;
41 ;;
45 ;;
49 ;;
53 ;;
57 ;;
61 ;;
65 ;;
69 ;;
73 ;;
77 ;;
81 ;;
85 ;;
89 ;;
93 ;;
97 ;;
101 ;;
105 ;;
109 ;;
113 ;;
117 ;;
121 ;;
125 ;;
129 ;;
133 ;;
137 ;;
141 ;;
145 ;;
149 ;;

END_TEMPLATE


BEGIN_TEMPLATE
! Version for mod(n,4) = 2
subroutine det_update$n(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m($n)  ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,$n)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,$n) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  double precision               :: u($n), z($n), w($n), lambda, d_inv
  !DIR$ ATTRIBUTES ALIGN : $IRP_ALIGN :: z, w, u
  !DIR$ ASSUME_ALIGNED S : $IRP_ALIGN
  !DIR$ ASSUME_ALIGNED S_inv : $IRP_ALIGN
  !DIR$ ASSUME (mod(LDS,$IRP_ALIGN/8) == 0)
  !DIR$ ASSUME (LDS >= $n)
  integer                        :: i,j
  
  double precision :: zj, zj1, zj2, zj3
  !DIR$ NOPREFETCH
  !DIR$ SIMD  NOVECREMAINDER
  do i=1,$n
    u(i) = m(i) - S(i,l)
  enddo
  
  zj = 0.d0
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj) NOVECREMAINDER
  do i=1,$n-2,4
    zj = zj + S_inv(i,l)*u(i) + S_inv(i+1,l)*u(i+1)  &
            + S_inv(i+2,l)*u(i+2) + S_inv(i+3,l)*u(i+3) 
  enddo
  i=$n-1
  zj = zj + S_inv(i,l)*u(i) + S_inv(i+1,l)*u(i+1) 

  d_inv = 1.d0/d
  d = d+zj
  lambda = d*d_inv
  if (dabs(lambda) < 1.d-3) then
    d = 0.d0
    return
  endif
  
  !DIR$ VECTOR ALIGNED
  do j=1,$n-2,4
   zj  = 0.d0
   zj1 = 0.d0
   zj2 = 0.d0
   zj3 = 0.d0
   !DIR$ VECTOR ALIGNED
   !DIR$ SIMD REDUCTION(+:zj,zj1,zj2,zj3) NOVECREMAINDER
   do i=1,$n-2
    zj  = zj  + S_inv(i,j  )*u(i)
    zj1 = zj1 + S_inv(i,j+1)*u(i)
    zj2 = zj2 + S_inv(i,j+2)*u(i)
    zj3 = zj3 + S_inv(i,j+3)*u(i)
   enddo
   z(j  ) = zj     + S_inv($n-1,j  )*u($n-1)
   z(j  ) = z(j  ) + S_inv($n,j  )*u($n)
   z(j+1) = zj1    + S_inv($n-1,j+1)*u($n-1)
   z(j+1) = z(j+1) + S_inv($n,j+1)*u($n)
   z(j+2) = zj2    + S_inv($n-1,j+2)*u($n-1)
   z(j+2) = z(j+2) + S_inv($n,j+2)*u($n)
   z(j+3) = zj3    + S_inv($n-1,j+3)*u($n-1)
   z(j+3) = z(j+3) + S_inv($n,j+3)*u($n)
  enddo

  j=$n-1
  zj  = 0.d0
  zj1 = 0.d0
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj,zj1) NOVECREMAINDER
  do i=1,$n-2
   zj  = zj  + S_inv(i,j  )*u(i)
   zj1 = zj1 + S_inv(i,j+1)*u(i)
  enddo
  z(j  ) = zj     + S_inv($n-1,j  )*u($n-1)
  z(j  ) = z(j  ) + S_inv($n,j  )*u($n)
  z(j+1) = zj1    + S_inv($n-1,j+1)*u($n-1)
  z(j+1) = z(j+1) + S_inv($n,j+1)*u($n)

  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(d_inv) NOVECREMAINDER
  do i=1,$n
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo
  
  do i=1,$n-2,4
   zj  = z(i)
   zj1 = z(i+1)
   zj2 = z(i+2)
   zj3 = z(i+3)
   !DIR$ VECTOR ALIGNED
   !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1,zj2,zj3)  NOVECREMAINDER
   do j=1,$n-2
    S_inv(j,i  ) = S_inv(j,i  )*lambda -zj *w(j)
    S_inv(j,i+1) = S_inv(j,i+1)*lambda -zj1*w(j)
    S_inv(j,i+2) = S_inv(j,i+2)*lambda -zj2*w(j)
    S_inv(j,i+3) = S_inv(j,i+3)*lambda -zj3*w(j)
   enddo
   S_inv($n-1,i  ) = S_inv($n-1,i  )*lambda -zj *w($n-1)
   S_inv($n  ,i  ) = S_inv($n  ,i  )*lambda -zj *w($n  )
   S_inv($n-1,i+1) = S_inv($n-1,i+1)*lambda -zj1*w($n-1)
   S_inv($n  ,i+1) = S_inv($n  ,i+1)*lambda -zj1*w($n  )
   S_inv($n-1,i+2) = S_inv($n-1,i+2)*lambda -zj2*w($n-1)
   S_inv($n  ,i+2) = S_inv($n  ,i+2)*lambda -zj2*w($n  )
   S_inv($n-1,i+3) = S_inv($n-1,i+3)*lambda -zj3*w($n-1)
   S_inv($n  ,i+3) = S_inv($n  ,i+3)*lambda -zj3*w($n  )
  enddo

  i=$n-1
  zj = z(i)
  zj1= z(i+1)
  !DIR$ VECTOR ALIGNED
  !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1)
  do j=1,$n-2
   S_inv(j,i  ) = S_inv(j,i  )*lambda -zj*w(j)
   S_inv(j,i+1) = S_inv(j,i+1)*lambda -zj1*w(j)
  enddo
  S_inv($n-1,i  ) = S_inv($n-1,i  )*lambda -zj*w($n-1)
  S_inv($n-1,i+1) = S_inv($n-1,i+1)*lambda -zj1*w($n-1)
  S_inv($n  ,i  ) = S_inv($n  ,i  )*lambda -zj*w($n  )
  S_inv($n  ,i+1) = S_inv($n  ,i+1)*lambda -zj1*w($n  )

end

SUBST [ n ]
6 ;;
10 ;;
14 ;;
18 ;;
22 ;;
26 ;;
30 ;;
34 ;;
38 ;;
42 ;;
46 ;;
50 ;;
54 ;;
58 ;;
62 ;;
66 ;;
70 ;;
74 ;;
78 ;;
82 ;;
86 ;;
90 ;;
94 ;;
98 ;;
102 ;;
106 ;;
110 ;;
114 ;;
118 ;;
122 ;;
126 ;;
130 ;;
134 ;;
138 ;;
142 ;;
146 ;;
150 ;;

END_TEMPLATE

BEGIN_TEMPLATE
! Version for mod(n,4) = 3
subroutine det_update$n(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS  ! Dimension of the vector
  real, intent(in)               :: m($n)  ! New vector
  integer, intent(in)            :: l      ! New position in S
  
  real,intent(inout)             :: S(LDS,$n)     ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,$n) ! Inverse Slater matrix
  double precision,intent(inout) :: d            ! Det(S)
  
  double precision               :: u($n), z($n), w($n), lambda, d_inv
  !DIR$ ATTRIBUTES ALIGN : $IRP_ALIGN :: z, w, u
  !DIR$ ASSUME_ALIGNED S : $IRP_ALIGN
  !DIR$ ASSUME_ALIGNED S_inv : $IRP_ALIGN
  !DIR$ ASSUME (mod(LDS,$IRP_ALIGN/8) == 0)
  !DIR$ ASSUME (LDS >= $n)
  integer                        :: i,j

  double precision :: zj, zj1, zj2, zj3

  !DIR$ SIMD 
  do i=1,$n
    u(i) = m(i) - S(i,l)
  enddo
  
  zj = 0.d0 
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj) NOVECREMAINDER
  do i=1,$n-3,4
    zj = zj + S_inv(i,l)*u(i) + S_inv(i+1,l)*u(i+1)  &
            + S_inv(i+2,l)*u(i+2) + S_inv(i+3,l)*u(i+3) 
  enddo
  i=$n-2
  zj = zj + S_inv(i,l)*u(i) + S_inv(i+1,l)*u(i+1) + S_inv(i+2,l)*u(i+2)


  d_inv = 1.d0/d
  d = d+zj
  lambda = d*d_inv
  if (dabs(lambda) < 1.d-3) then
    d = 0.d0
    return
  endif
  
  !DIR$ VECTOR ALIGNED
  do j=1,$n-3,4
   zj  = 0.d0
   zj1 = 0.d0
   zj2 = 0.d0
   zj3 = 0.d0
   !DIR$ VECTOR ALIGNED
   !DIR$ SIMD REDUCTION(+:zj,zj1,zj2,zj3)
   do i=1,$n-3
    zj  = zj  + S_inv(i,j  )*u(i)
    zj1 = zj1 + S_inv(i,j+1)*u(i)
    zj2 = zj2 + S_inv(i,j+2)*u(i)
    zj3 = zj3 + S_inv(i,j+3)*u(i)
   enddo
   z(j  ) = zj     + S_inv($n-2,j  )*u($n-2)
   z(j  ) = z(j  ) + S_inv($n-1,j  )*u($n-1)
   z(j  ) = z(j  ) + S_inv($n,j  )*u($n)
   z(j+1) = zj1    + S_inv($n-2,j+1)*u($n-2)
   z(j+1) = z(j+1) + S_inv($n-1,j+1)*u($n-1)
   z(j+1) = z(j+1) + S_inv($n,j+1)*u($n)
   z(j+2) = zj2    + S_inv($n-2,j+2)*u($n-2)
   z(j+2) = z(j+2) + S_inv($n-1,j+2)*u($n-1)
   z(j+2) = z(j+2) + S_inv($n,j+2)*u($n)
   z(j+3) = zj3    + S_inv($n-2,j+3)*u($n-2)
   z(j+3) = z(j+3) + S_inv($n-1,j+3)*u($n-1)
   z(j+3) = z(j+3) + S_inv($n,j+3)*u($n)
  enddo

  j=$n-2
  zj  = 0.d0
  zj1 = 0.d0
  zj2 = 0.d0
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zj,zj1,zj2)
  do i=1,$n-3
   zj  = zj  + S_inv(i,j  )*u(i)
   zj1 = zj1 + S_inv(i,j+1)*u(i)
   zj2 = zj2 + S_inv(i,j+2)*u(i)
  enddo
  z(j  ) = zj     + S_inv($n-2,j  )*u($n-2)
  z(j  ) = z(j  ) + S_inv($n-1,j  )*u($n-1)
  z(j  ) = z(j  ) + S_inv($n,j  )*u($n)
  z(j+1) = zj1    + S_inv($n-2,j+1)*u($n-2)
  z(j+1) = z(j+1) + S_inv($n-1,j+1)*u($n-1)
  z(j+1) = z(j+1) + S_inv($n,j+1)*u($n)
  z(j+2) = zj2    + S_inv($n-2,j+2)*u($n-2)
  z(j+2) = z(j+2) + S_inv($n-1,j+2)*u($n-1)
  z(j+2) = z(j+2) + S_inv($n,j+2)*u($n)

  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(d_inv)
  do i=1,$n
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo
  
  do i=1,$n-3,4
   zj  = z(i)
   zj1 = z(i+1)
   zj2 = z(i+2)
   zj3 = z(i+3)
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1,zj2,zj3)
   do j=1,$n-3
    S_inv(j,i  ) = S_inv(j,i  )*lambda - w(j)*zj 
    S_inv(j,i+1) = S_inv(j,i+1)*lambda - w(j)*zj1
    S_inv(j,i+2) = S_inv(j,i+2)*lambda - w(j)*zj2
    S_inv(j,i+3) = S_inv(j,i+3)*lambda - w(j)*zj3
   enddo
   S_inv($n-2,i  ) = S_inv($n-2,i  )*lambda -zj *w($n-2)
   S_inv($n-1,i  ) = S_inv($n-1,i  )*lambda -zj *w($n-1)
   S_inv($n  ,i  ) = S_inv($n  ,i  )*lambda -zj *w($n  )
   S_inv($n-2,i+1) = S_inv($n-2,i+1)*lambda -zj1*w($n-2)
   S_inv($n-1,i+1) = S_inv($n-1,i+1)*lambda -zj1*w($n-1)
   S_inv($n  ,i+1) = S_inv($n  ,i+1)*lambda -zj1*w($n  )
   S_inv($n-2,i+2) = S_inv($n-2,i+2)*lambda -zj2*w($n-2)
   S_inv($n-1,i+2) = S_inv($n-1,i+2)*lambda -zj2*w($n-1)
   S_inv($n  ,i+2) = S_inv($n  ,i+2)*lambda -zj2*w($n  )
   S_inv($n-2,i+3) = S_inv($n-2,i+3)*lambda -zj3*w($n-2)
   S_inv($n-1,i+3) = S_inv($n-1,i+3)*lambda -zj3*w($n-1)
   S_inv($n  ,i+3) = S_inv($n  ,i+3)*lambda -zj3*w($n  )
  enddo

  i=$n-2
  zj  = z(i)
  zj1 = z(i+1)
  zj2 = z(i+2)
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1,zj2)
  do j=1,$n
   S_inv(j,i  ) = S_inv(j,i  )*lambda - w(j)*zj
   S_inv(j,i+1) = S_inv(j,i+1)*lambda - w(j)*zj1
   S_inv(j,i+2) = S_inv(j,i+2)*lambda - w(j)*zj2
  enddo


end

SUBST [ n ]
7 ;;
11 ;;
15 ;;
19 ;;
23 ;;
27 ;;
31 ;;
35 ;;
39 ;;
43 ;;
47 ;;
51 ;;
55 ;;
59 ;;
63 ;;
67 ;;
71 ;;
75 ;;
79 ;;
83 ;;
87 ;;
91 ;;
95 ;;
99 ;;
103 ;;
107 ;;
111 ;;
115 ;;
119 ;;
123 ;;
127 ;;
131 ;;
135 ;;
139 ;;
143 ;;
147 ;;

END_TEMPLATE



subroutine det_update_general(n,LDS,m,l,S,S_inv,d)
  implicit none
  
  integer, intent(in)            :: n,LDS      ! Dimension of the vector
  real, intent(in)               :: m(LDS)     ! New vector
  integer, intent(in)            :: l          ! New position in S
  
  real,intent(inout)             :: S(LDS,n)       ! Slater matrix
  double precision,intent(inout) :: S_inv(LDS,n)   ! Inverse Slater matrix
  double precision,intent(inout) :: d              ! Det(S)
  
  double precision               :: lambda, d_inv
  double precision               :: u(3840), z(3840), w(3840)
  !DIR$ ATTRIBUTES ALIGN : $IRP_ALIGN :: z, w, u
  !DIR$ ASSUME_ALIGNED S : $IRP_ALIGN
  !DIR$ ASSUME_ALIGNED S_inv : $IRP_ALIGN
  !DIR$ ASSUME (LDS >= n)
  !DIR$ ASSUME (LDS <= 3840)
  !DIR$ ASSUME (MOD(LDS,$IRP_ALIGN/8) == 0)
  !DIR$ ASSUME (n>150)

  integer          :: i,j,n4
  double precision :: zl

  !DIR$ NOPREFETCH
  do i=1,n
    u(i) = m(i) - S(i,l)
  enddo
  
  zl = 0.d0
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  !DIR$ SIMD REDUCTION(+:zl)
  do i=1,n
   zl = zl + S_inv(i,l)*u(i)
  enddo

  d_inv = 1.d0/d 
  d = d+zl
  lambda = d*d_inv
  
  if ( dabs(lambda) < 1.d-3 ) then
    d = 0.d0
  endif

  double precision :: zj, zj1, zj2, zj3

  n4 = iand(n,not(3))
  !DIR$ VECTOR ALIGNED
  !DIR$ NOPREFETCH
  do j=1,n4,4
   zj  = 0.d0
   zj1 = 0.d0
   zj2 = 0.d0
   zj3 = 0.d0
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD REDUCTION(+:zj,zj1,zj2,zj3)
   do i=1,n
    zj  = zj  + S_inv(i,j  )*u(i)
    zj1 = zj1 + S_inv(i,j+1)*u(i)
    zj2 = zj2 + S_inv(i,j+2)*u(i)
    zj3 = zj3 + S_inv(i,j+3)*u(i)
   enddo
   z(j  ) = zj
   z(j+1) = zj1
   z(j+2) = zj2
   z(j+3) = zj3
  enddo

  do j=n4+1,n
   zj = 0.d0
   !DIR$ VECTOR ALIGNED
   !DIR$ NOPREFETCH
   !DIR$ SIMD REDUCTION(+:zj)
   do i=1,n
    zj = zj + S_inv(i,j)*u(i)
   enddo
   z(j  ) = zj
  enddo

  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(d_inv)
  do i=1,n
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo
  
  !DIR$ NOPREFETCH
  !DIR$ SIMD FIRSTPRIVATE(d_inv)
  do i=1,n
    w(i) = S_inv(i,l)*d_inv
    S(i,l) = m(i)
  enddo

  do i=1,n4,4
    zj  = z(i)
    zj1 = z(i+1)
    zj2 = z(i+2)
    zj3 = z(i+3)
    !DIR$ VECTOR ALIGNED
    !DIR$ NOPREFETCH
    !DIR$ SIMD FIRSTPRIVATE(lambda,zj,zj1,zj2,zj3)
    do j=1,n
     S_inv(j,i  ) = S_inv(j,i  )*lambda -zj *w(j)
     S_inv(j,i+1) = S_inv(j,i+1)*lambda -zj1*w(j)
     S_inv(j,i+2) = S_inv(j,i+2)*lambda -zj2*w(j)
     S_inv(j,i+3) = S_inv(j,i+3)*lambda -zj3*w(j)
    enddo
  enddo

  do i=n4+1,n
    zj = z(i)
    !DIR$ VECTOR ALIGNED
    !DIR$ NOPREFETCH
    !DIR$ SIMD FIRSTPRIVATE(lambda,zj)
    do j=1,n
      S_inv(j,i) = S_inv(j,i)*lambda -zj*w(j)
    enddo
  enddo

end



subroutine bitstring_to_list( string, list, n_elements, Nint)
  implicit none
  BEGIN_DOC
  ! Gives the inidices(+1) of the bits set to 1 in the bit string
  END_DOC
  integer, intent(in)            :: Nint
  integer*8, intent(in)          :: string(Nint)
  integer, intent(out)           :: list(Nint*64)
  integer, intent(out)           :: n_elements

  integer                        :: i, ishift
  integer*8                      :: l

  n_elements = 0
  ishift = 2
  do i=1,Nint
    l = string(i)
    do while (l /= 0_8)
      n_elements = n_elements+1
      list(n_elements) = ishift+popcnt(l-1_8) - popcnt(l)
      l = iand(l,l-1_8)
    enddo
    ishift = ishift + 64
  enddo
end

 BEGIN_PROVIDER [ integer, mo_list_alpha_curr, (elec_alpha_num) ]
&BEGIN_PROVIDER [ integer, mo_list_alpha_prev, (elec_alpha_num) ]
 implicit none
 BEGIN_DOC
 ! List of MOs in the current alpha determinant
 END_DOC
 integer                        :: l
 if (det_i /= det_alpha_order(1)) then
   mo_list_alpha_prev = mo_list_alpha_curr
 else
   mo_list_alpha_prev = 0
 endif
 !DIR$ FORCEINLINE
 call bitstring_to_list ( psi_det_alpha(1,det_i), mo_list_alpha_curr, l, N_int )
 if (l /= elec_alpha_num) then
   stop 'error in number of alpha electrons'
 endif

END_PROVIDER

 BEGIN_PROVIDER [ integer, mo_list_beta_curr, (elec_beta_num) ]
&BEGIN_PROVIDER [ integer, mo_list_beta_prev, (elec_beta_num) ]
 implicit none
 BEGIN_DOC
 ! List of MOs in the current beta determinant
 END_DOC
 integer                        :: l
 if (elec_beta_num == 0) then
   return
 endif
 if (det_j /= det_beta_order(1)) then
   mo_list_beta_prev = mo_list_beta_curr
 else
   mo_list_beta_prev = 0
 endif

 !DIR$ FORCEINLINE
 call bitstring_to_list ( psi_det_beta(1,det_j), mo_list_beta_curr, l, N_int )
 if (l /= elec_beta_num) then
   stop 'error in number of beta electrons'
 endif
END_PROVIDER

 BEGIN_PROVIDER [ double precision, det_alpha_value_curr ]
&BEGIN_PROVIDER [ real, slater_matrix_alpha, (elec_alpha_num_8,elec_alpha_num) ]
&BEGIN_PROVIDER [ double precision, slater_matrix_alpha_inv_det, (elec_alpha_num_8,elec_alpha_num) ]
  
  implicit none
  
  BEGIN_DOC
  ! det_alpha_value_curr : Value of the current alpha determinant
  !
  ! slater_matrix_alpha : Slater matrix for the current alpha determinant.
  !  1st index runs over electrons and
  !  2nd index runs over MOs.
  !  Built with 1st determinant
  !
  ! slater_matrix_alpha_inv_det: Inverse of the alpha Slater matrix * determinant
  END_DOC
  
  double precision               :: ddet
  integer                        :: i,j,k,imo,l
  integer                        :: to_do(elec_alpha_num), n_to_do_old, n_to_do
  integer, save                  :: ifirst
  integer, save                  :: cycle_id=0

  !! Some usefull formats for output
  10001 format ('#START_PACKET')
  10008 format ('#CYCLE_ID: ', I4)
  10000 format ('#SLATER_MATRIX_DIM: ', I3)
  10002 format ('#NUPDATES: ', I2)
  10003 format ('#SLATER_MATRIX: (i (outer), j (inner)), slater_matrix_alpha(i,j), ddet * slater_matrix_alpha_inv_det(i,j) / ddet')
  10004 format ('(',I0.2,',',I0.2,')',2(2X,E23.15))
  10005 format ('#COL_UPDATE_INDEX: ', I2)
  10006 format ('#COL_UPDATE_COMP_(',I0.2,'): ', E23.15)
  10007 format ('#END_PACKET',/)

  open (unit = 501, file = "dataset.dat") !! slightly cleaner output
  open (unit = 502, file = "dataset.fulltrace.dat")

  if (ifirst == 0) then !! If this is the first time we enter this subroutine
    ifirst = 1
    !DIR$ VECTOR ALIGNED
    slater_matrix_alpha = 0.
    !DIR$ VECTOR ALIGNED
    slater_matrix_alpha_inv_det = 0.d0
  endif
  
  PROVIDE mo_value
  if (det_i /= det_alpha_order(1) ) then
    ! write(*,*) "det_i: ", det_i
!  if (det_i == -1 ) then

    !! determin number of updates, the updates and 
    n_to_do = 0
    do k=1,elec_alpha_num
      imo = mo_list_alpha_curr(k)
      if ( imo /= mo_list_alpha_prev(k) ) then
          n_to_do += 1
          to_do(n_to_do) = k
      endif
    enddo

    !! Write number of alpha electrons, number of updates to do, slater and slater_inv to file unit 10000
    write(501,10001)
    write(501,10008) cycle_id
    write(501,10000) elec_alpha_num
    write(501,10002) n_to_do
    write(501,10003)
    do i=1,elec_alpha_num
      do j=1,elec_alpha_num
        write(501,10004) i, j, slater_matrix_alpha(i,j), slater_matrix_alpha_inv_det(i,j) / det_alpha_value_curr
      end do
    end do

    !! write all the updates to file unit 10000
    do l=1,n_to_do
      k = to_do(l)
      imo = mo_list_alpha_curr(k)
      write(501,10005) k
      do i=1,elec_alpha_num
        write(501,10006) i, mo_value(i, imo)
      end do
    end do
 
!  print n_to_do (number of updates to do)
!  to_do (array of the columns that need to be swapped)
!  mo_list_alpha_curr (list of orbitals to build the current determinant)
!  mo_list_alpha_prev (list of the previous determinant)
!
!  slater_matrix_alpha (slater matrix that needs to be inverted. This is the initial matrix)
!  slater_matrix_alpha_inv_det = inverse of the slater matrix divided by the determinant (ddet: l. 1216)
!
!
!
!       1 2 3  4
!       --------
!       2 4 6  8
!       2 4 10 8
!    
!     mo_list(:)       (2,4,10,8)
!     mo_list_prev(:)  (2,4,6,8)
!     n_todo           1
!     to_do            (3)
!
!
!       1 2 3  4
!       --------
!       2 4 6  8
!       2 5 10 8
!    
!     mo_list(:)       (2,5,10,8)
!     mo_list_prev(:)  (2,4,6,8)
!     n_todo           2
!     to_do            (2,3)


    ddet = 0.d0
    
    if (n_to_do < shiftl(elec_alpha_num,1)) then

      write(502,10001)
      write(502,10008) cycle_id
      write(502,10000) elec_alpha_num
      write(502,10002) n_to_do

      do while ( n_to_do > 0 )
        ddet = det_alpha_value_curr
        n_to_do_old = n_to_do
        n_to_do = 0
        do l=1,n_to_do_old
          k = to_do(l)
          imo = mo_list_alpha_curr(k)
          
          write(502,10003)
          do i=1,elec_alpha_num
            do j=1,elec_alpha_num
              write(502,10004) i, j, slater_matrix_alpha(i,j), slater_matrix_alpha_inv_det(i,j) / ddet
            end do
          end do
          write(502,10005) k
          do i=1,elec_alpha_num
            write(502,10006) i, mo_value(i,imo)
          end do
    
          call det_update(elec_alpha_num, elec_alpha_num_8,            &
              mo_value(1,imo),                                         &
              k,                                                       &
              slater_matrix_alpha,                                     &
              slater_matrix_alpha_inv_det,                             &
              ddet)
          if (ddet /= 0.d0) then
            det_alpha_value_curr = ddet
          else
            n_to_do += 1
            to_do(n_to_do) = k
            ddet = det_alpha_value_curr
          endif
        enddo
        if (n_to_do == n_to_do_old) then
          ddet = 0.d0
          exit
        endif
      enddo
    endif

  write(501,10007)
  write(502,10007)
  cycle_id = cycle_id + 1
  
  else

    ddet = 0.d0

  endif

    
  ! Avoid NaN
  if (ddet /= 0.d0) then
    continue
  else
    do j=1,mo_closed_num
      !DIR$ VECTOR ALIGNED
      !DIR$ LOOP COUNT(100)
      do i=1,elec_alpha_num
        slater_matrix_alpha(i,j) = mo_value(i,j)
        slater_matrix_alpha_inv_det(j,i) = mo_value(i,j)
      enddo
    enddo
    do k=mo_closed_num+1,elec_alpha_num
      !DIR$ VECTOR ALIGNED
      !DIR$ LOOP COUNT(100)
      do i=1,elec_alpha_num
        slater_matrix_alpha(i,k) = mo_value(i,mo_list_alpha_curr(k))
        slater_matrix_alpha_inv_det(k,i) = mo_value(i,mo_list_alpha_curr(k))
      enddo
    enddo
    call invert(slater_matrix_alpha_inv_det,elec_alpha_num_8,elec_alpha_num,ddet)
    
  endif
  ASSERT (ddet /= 0.d0)
  
  det_alpha_value_curr = ddet 
END_PROVIDER

 BEGIN_PROVIDER [ double precision, det_beta_value_curr ]
&BEGIN_PROVIDER [ real, slater_matrix_beta, (elec_beta_num_8,elec_beta_num) ]
&BEGIN_PROVIDER [ double precision, slater_matrix_beta_inv_det, (elec_beta_num_8,elec_beta_num) ]
  BEGIN_DOC
  !  det_beta_value_curr : Value of the current beta determinant
  !
  !  slater_matrix_beta : Slater matrix for the current beta determinant.
  !  1st index runs over electrons and
  !  2nd index runs over MOs.
  !  Built with 1st determinant
  !
  !  slater_matrix_beta_inv_det : Inverse of the beta Slater matrix x determinant
  END_DOC
  
  double precision               :: ddet
  integer                        :: i,j,k,imo,l
  integer                        :: to_do(elec_alpha_num-mo_closed_num), n_to_do_old, n_to_do
  
  integer, save                  :: ifirst
  if (elec_beta_num == 0) then
    det_beta_value_curr = 0.d0
    return
  endif
  
  if (ifirst == 0) then
    ifirst = 1
    slater_matrix_beta = 0.
    slater_matrix_beta_inv_det = 0.d0
  endif
  PROVIDE mo_value
  
  if (det_j /= det_beta_order(1)) then
!  if (det_j == -1) then

    n_to_do = 0
    do k=mo_closed_num+1,elec_beta_num
      imo = mo_list_beta_curr(k)
      if ( imo /= mo_list_beta_prev(k) ) then
          n_to_do += 1
          to_do(n_to_do) = k
      endif
    enddo
    
    ddet = 0.d0
    if (n_to_do < shiftl(elec_beta_num,1)) then

      do while ( n_to_do > 0 )
        ddet = det_beta_value_curr
        n_to_do_old = n_to_do
        n_to_do = 0
        do l=1,n_to_do_old
          k = to_do(l)
          imo = mo_list_beta_curr(k)
          call det_update(elec_beta_num, elec_beta_num_8,                &
              mo_value(elec_alpha_num+1,imo),                            &
              k,                                                         &
              slater_matrix_beta,                                        &
              slater_matrix_beta_inv_det,                                &
              ddet)
          if (ddet /= 0.d0) then
            det_beta_value_curr = ddet
          else
            n_to_do += 1
            to_do(n_to_do) = k
            ddet = det_beta_value_curr
          endif
        enddo
        if (n_to_do == n_to_do_old) then
          ddet = 0.d0
          exit
        endif
      enddo

    endif
    
  else
    
    ddet = 0.d0

  endif
  
  ! Avoid NaN
  if (ddet /= 0.d0) then
    continue
  else
    do j=1,mo_closed_num
      !DIR$ VECTOR UNALIGNED
      !DIR$ LOOP COUNT (100)
      do i=1,elec_beta_num
        slater_matrix_beta(i,j) = mo_value(i+elec_alpha_num,j)
        slater_matrix_beta_inv_det(j,i) = mo_value(i+elec_alpha_num,j)
      enddo
    enddo
    do k=mo_closed_num+1,elec_beta_num
      !DIR$ VECTOR UNALIGNED
      !DIR$ LOOP COUNT (100)
      do i=1,elec_beta_num
        slater_matrix_beta(i,k) = mo_value(i+elec_alpha_num,mo_list_beta_curr(k))
        slater_matrix_beta_inv_det(k,i) = mo_value(i+elec_alpha_num,mo_list_beta_curr(k))
      enddo
    enddo
    call invert(slater_matrix_beta_inv_det,elec_beta_num_8,elec_beta_num,ddet)
  endif
  ASSERT (ddet /= 0.d0)
  
  det_beta_value_curr = ddet 
  
END_PROVIDER

 BEGIN_PROVIDER [ integer, det_alpha_num_pseudo ]
&BEGIN_PROVIDER [ integer, det_beta_num_pseudo ]
 implicit none
 BEGIN_DOC
 ! Dimensioning of large arrays made smaller without pseudo
 END_DOC
 if (do_pseudo) then
    det_alpha_num_pseudo = det_alpha_num
    det_beta_num_pseudo = det_beta_num
 else
    det_alpha_num_pseudo = 1
    det_beta_num_pseudo = 1
 endif
END_PROVIDER


 BEGIN_PROVIDER [ double precision , det_alpha_value,  (det_alpha_num_8) ]
&BEGIN_PROVIDER [ double precision , det_alpha_grad_lapl, (4,elec_alpha_num,det_alpha_num) ]
&BEGIN_PROVIDER [ double precision , det_alpha_pseudo, (elec_alpha_num_8,det_alpha_num_pseudo) ]
  
  implicit none
  
  BEGIN_DOC
  ! Values of the alpha determinants
  ! Gradients of the alpha determinants
  ! Laplacians of the alpha determinants
  END_DOC
  
  integer                        :: j,i,k
  integer, save                  :: ifirst = 0
  if (ifirst == 0) then
    ifirst = 1
    det_alpha_value  = 0.d0
    det_alpha_grad_lapl = 0.d0
    det_alpha_pseudo = 0.d0
  endif
  
  
  do j=1,det_alpha_num
    
    det_i = det_alpha_order(j)
    if (j > 1) then
      TOUCH det_i
    endif
    
    det_alpha_value(det_i) = det_alpha_value_curr
    det_alpha_grad_lapl(:,:,det_i) = det_alpha_grad_lapl_curr(:,:)
    if (do_pseudo) then
      det_alpha_pseudo(:,det_i) = det_alpha_pseudo_curr(:) 
    endif
   
  enddo
  
  det_i = det_alpha_order(1)
  SOFT_TOUCH det_i
  
END_PROVIDER

 BEGIN_PROVIDER [ double precision, det_beta_value,  (det_beta_num_8) ]
&BEGIN_PROVIDER [ double precision, det_beta_grad_lapl, (4,elec_alpha_num+1:elec_num,det_beta_num) ]
&BEGIN_PROVIDER [ double precision, det_beta_pseudo, (elec_alpha_num+1:elec_num,det_beta_num_pseudo) ]
  
  
  implicit none
  
  BEGIN_DOC
  ! Values of the beta determinants
  ! Gradients of the beta determinants
  ! Laplacians of the beta determinants
  END_DOC
  
  integer                        :: j,i,k
  integer, save                  :: ifirst = 0
  if (elec_beta_num == 0) then
    det_beta_value = 1.d0
    return
  endif
    
  if (ifirst == 0) then
    ifirst = 1
    det_beta_value  = 0.d0
    det_beta_grad_lapl = 0.d0
    det_beta_pseudo = 0.d0
  endif
  
  do j=1,det_beta_num
    
    det_j = det_beta_order(j)
    if (j > 1) then
      TOUCH det_j
    endif
    
    det_beta_value(det_j)  = det_beta_value_curr
    det_beta_grad_lapl(:,:,det_j) = det_beta_grad_lapl_curr(:,:)
    if (do_pseudo) then
      det_beta_pseudo(:,det_j) = det_beta_pseudo_curr(:) 
    endif

  enddo
  
  det_j = det_beta_order(1)
  SOFT_TOUCH det_j
  
END_PROVIDER


 BEGIN_PROVIDER [ double precision, psidet_value ]
&BEGIN_PROVIDER [ double precision, psidet_inv ]
&BEGIN_PROVIDER [ double precision, psidet_grad_lapl, (4,elec_num_8) ]
&BEGIN_PROVIDER [ double precision, pseudo_non_local, (elec_num) ]
  
  implicit none
  BEGIN_DOC
  ! Value of the determinantal part of the wave function
  
  ! Gradient of the determinantal part of the wave function
  
  ! Laplacian of determinantal part of the wave function

  ! Non-local component of the pseudopotentials

  ! Regularized 1/psi = 1/(psi + 1/psi)
  END_DOC
  
  integer, save                  :: ifirst=0
  if (ifirst == 0) then
    ifirst = 1
    psidet_grad_lapl = 0.d0
  endif
  
  double precision :: CDb(det_alpha_num_8)
  double precision :: CDb_i
  double precision :: DaC(det_beta_num_8)
  !DIR$ ATTRIBUTES ALIGN : 32 :: DaC,CDb

  ! C x D_beta
  ! D_alpha^t x C 
  ! D_alpha^t x (C x D_beta) 

  integer :: i,j,k, l
  integer :: i1,i2,i3,i4,det_num4
  integer :: j1,j2,j3,j4
  double precision :: f

  DaC = 0.d0
  CDb = 0.d0

  if (det_num < shiftr(det_alpha_num*det_beta_num,2)) then

    det_num4 = iand(det_num,not(3))
    !DIR$ VECTOR ALIGNED
    do k=1,det_num4,4
      i1 = det_coef_matrix_rows(k  )
      i2 = det_coef_matrix_rows(k+1)
      i3 = det_coef_matrix_rows(k+2)
      i4 = det_coef_matrix_rows(k+3)
      j1 = det_coef_matrix_columns(k  )
      j2 = det_coef_matrix_columns(k+1)
      j3 = det_coef_matrix_columns(k+2)
      j4 = det_coef_matrix_columns(k+3)
      if ( (j1 == j2).and.(j1 == j3).and.(j1 == j4) ) then
        f = det_beta_value (j1)
        CDb(i1) = CDb(i1) + det_coef_matrix_values(k  )*f
        CDb(i2) = CDb(i2) + det_coef_matrix_values(k+1)*f
        CDb(i3) = CDb(i3) + det_coef_matrix_values(k+2)*f
        CDb(i4) = CDb(i4) + det_coef_matrix_values(k+3)*f

        if ( ((i2-i1) == 1).and.((i3-i1) == 2).and.((i4-i1) == 3) ) then
          DaC(j1) = DaC(j1) + det_coef_matrix_values(k)*det_alpha_value(i1) &
          + det_coef_matrix_values(k+1)*det_alpha_value(i1+1) &
          + det_coef_matrix_values(k+2)*det_alpha_value(i1+2) &
          + det_coef_matrix_values(k+3)*det_alpha_value(i1+3)
        else
          DaC(j1) = DaC(j1) + det_coef_matrix_values(k)*det_alpha_value(i1) &
          + det_coef_matrix_values(k+1)*det_alpha_value(i2) &
          + det_coef_matrix_values(k+2)*det_alpha_value(i3) &
          + det_coef_matrix_values(k+3)*det_alpha_value(i4)
        endif
      else
        DaC(j1) = DaC(j1) + det_coef_matrix_values(k  )*det_alpha_value(i1)
        DaC(j2) = DaC(j2) + det_coef_matrix_values(k+1)*det_alpha_value(i2)
        DaC(j3) = DaC(j3) + det_coef_matrix_values(k+2)*det_alpha_value(i3)
        DaC(j4) = DaC(j4) + det_coef_matrix_values(k+3)*det_alpha_value(i4)
        CDb(i1) = CDb(i1) + det_coef_matrix_values(k  )*det_beta_value (j1)
        CDb(i2) = CDb(i2) + det_coef_matrix_values(k+1)*det_beta_value (j2)
        CDb(i3) = CDb(i3) + det_coef_matrix_values(k+2)*det_beta_value (j3)
        CDb(i4) = CDb(i4) + det_coef_matrix_values(k+3)*det_beta_value (j4)
      endif
    enddo

    do k=det_num4+1,det_num
      i = det_coef_matrix_rows(k)
      j = det_coef_matrix_columns(k)
      DaC(j) = DaC(j) + det_coef_matrix_values(k)*det_alpha_value(i)
      CDb(i) = CDb(i) + det_coef_matrix_values(k)*det_beta_value (j)
    enddo

  else

    call dgemv('T',det_alpha_num,det_beta_num,1.d0,det_coef_matrix_dense, &
      size(det_coef_matrix_dense,1), det_alpha_value, 1, 0.d0, DaC, 1)
    call dgemv('N',det_alpha_num,det_beta_num,1.d0,det_coef_matrix_dense, &
      size(det_coef_matrix_dense,1), det_beta_value, 1, 0.d0, CDb, 1)

  endif

  ! Value
  ! -----

  psidet_value = 0.d0
  do j=1,det_beta_num
    psidet_value = psidet_value + det_beta_value(j) * DaC(j)
  enddo

  
  if (psidet_value == 0.d0) then
    call abrt(irp_here,'Determinantal component of the wave function is zero.')
  endif
  psidet_inv = 1.d0/psidet_value

  ! Gradients
  ! ---------

  call dgemv('N',elec_alpha_num*4,det_alpha_num,1.d0,                &
      det_alpha_grad_lapl,                                           &
      size(det_alpha_grad_lapl,1)*size(det_alpha_grad_lapl,2),       &
      CDb, 1, 0.d0, psidet_grad_lapl, 1)
  if (elec_beta_num /= 0) then
    call dgemv('N',elec_beta_num*4,det_beta_num,1.d0,                  &
        det_beta_grad_lapl(1,elec_alpha_num+1,1),                      &
        size(det_beta_grad_lapl,1)*size(det_beta_grad_lapl,2),         &
        DaC, 1, 0.d0, psidet_grad_lapl(1,elec_alpha_num+1), 1)
  endif
  
  if (do_pseudo) then
    call dgemv('N',elec_alpha_num,det_alpha_num,psidet_inv,          &
        det_alpha_pseudo, size(det_alpha_pseudo,1),                  &
        CDb, 1, 0.d0, pseudo_non_local, 1)
    if (elec_beta_num /= 0) then
      call dgemv('N',elec_beta_num,det_beta_num,psidet_inv,            &
          det_beta_pseudo, size(det_beta_pseudo,1),                    &
          DaC, 1, 0.d0, pseudo_non_local(elec_alpha_num+1), 1)
    endif
  endif

END_PROVIDER

BEGIN_PROVIDER  [ double precision, det_alpha_pseudo_curr, (elec_alpha_num) ]
  implicit none
  BEGIN_DOC
! Pseudopotential non-local contribution
  END_DOC
  integer                        :: i,j,l,m,k,n
  integer                        :: imo,kk
  double precision               :: c
  integer, save                  :: ifirst = 0
  if (ifirst == 0) then
    ifirst = 1
    det_alpha_pseudo_curr = 0.d0
  endif
  if (do_pseudo) then
    do i=1,elec_alpha_num
      det_alpha_pseudo_curr(i) = 0.d0
      do n=1,elec_alpha_num
        imo = mo_list_alpha_curr(n)
        c = slater_matrix_alpha_inv_det(i,n)
        det_alpha_pseudo_curr(i) =                                &
              det_alpha_pseudo_curr(i) + c*pseudo_mo_term(imo,i)
      enddo
    enddo
  endif
END_PROVIDER

BEGIN_PROVIDER  [ double precision, det_beta_pseudo_curr, (elec_alpha_num+1:elec_num) ]
  implicit none
  BEGIN_DOC
! Pseudopotential non-local contribution
  END_DOC
  integer                        :: i,j,l,m,k,n
  integer                        :: imo,kk
  double precision               :: c
  integer, save                  :: ifirst = 0
  if (elec_beta_num == 0) then
    return
  endif
  if (ifirst == 0) then
    ifirst = 1
    det_beta_pseudo_curr = 0.d0
  endif
  if (do_pseudo) then
    do i=elec_alpha_num+1,elec_num
      det_beta_pseudo_curr(i) = 0.d0
      do n=1,elec_beta_num
        imo = mo_list_beta_curr(n)
        c = slater_matrix_beta_inv_det(i-elec_alpha_num,n)
        det_beta_pseudo_curr(i) =                                    &
            det_beta_pseudo_curr(i) + c*pseudo_mo_term(imo,i)
      enddo
    enddo
  endif
END_PROVIDER

BEGIN_PROVIDER  [ double precision, det_alpha_grad_lapl_curr, (4,elec_alpha_num) ]
  implicit none
  BEGIN_DOC
  ! Gradient of the current alpha determinant
  END_DOC
  
  integer                        :: i, j, k
  !DIR$ VECTOR ALIGNED
  do i=1,elec_alpha_num
    det_alpha_grad_lapl_curr(1,i) = 0.d0
    det_alpha_grad_lapl_curr(2,i) = 0.d0
    det_alpha_grad_lapl_curr(3,i) = 0.d0
    det_alpha_grad_lapl_curr(4,i) = 0.d0
  enddo
  
  integer :: imo, imo2

! -------
! The following code does the same as this:
!
!    do j=1,elec_alpha_num
!      imo  = mo_list_alpha_curr(j)
!      do i=1,elec_alpha_num
!        do k=1,4
!          det_alpha_grad_lapl_curr(k,i) = det_alpha_grad_lapl_curr(k,i) + mo_grad_lapl_alpha(k,i,imo)*slater_matrix_alpha_inv_det(i,j) 
!        enddo
!      enddo
!    enddo
!
! -------

  if (iand(elec_alpha_num,1) == 0) then

    do j=1,elec_alpha_num,2
      imo  = mo_list_alpha_curr(j  )
      imo2 = mo_list_alpha_curr(j+1)
      do i=1,elec_alpha_num,2
        !DIR$ VECTOR ALIGNED
        do k=1,4
          det_alpha_grad_lapl_curr(k,i  ) = det_alpha_grad_lapl_curr(k,i  ) + mo_grad_lapl_alpha(k,i  ,imo )*slater_matrix_alpha_inv_det(i  ,j  ) &
                                                                            + mo_grad_lapl_alpha(k,i  ,imo2)*slater_matrix_alpha_inv_det(i  ,j+1)
          det_alpha_grad_lapl_curr(k,i+1) = det_alpha_grad_lapl_curr(k,i+1) + mo_grad_lapl_alpha(k,i+1,imo )*slater_matrix_alpha_inv_det(i+1,j  ) &
                                                                            + mo_grad_lapl_alpha(k,i+1,imo2)*slater_matrix_alpha_inv_det(i+1,j+1)
        enddo
      enddo
    enddo

  else

    do j=1,elec_alpha_num-1,2
      imo  = mo_list_alpha_curr(j  )
      imo2 = mo_list_alpha_curr(j+1)
      do i=1,elec_alpha_num-1,2
        !DIR$ VECTOR ALIGNED
        do k=1,4
          det_alpha_grad_lapl_curr(k,i  ) = det_alpha_grad_lapl_curr(k,i  ) + mo_grad_lapl_alpha(k,i  ,imo )*slater_matrix_alpha_inv_det(i  ,j  ) &
                                                                            + mo_grad_lapl_alpha(k,i  ,imo2)*slater_matrix_alpha_inv_det(i  ,j+1)
          det_alpha_grad_lapl_curr(k,i+1) = det_alpha_grad_lapl_curr(k,i+1) + mo_grad_lapl_alpha(k,i+1,imo )*slater_matrix_alpha_inv_det(i+1,j  ) &
                                                                            + mo_grad_lapl_alpha(k,i+1,imo2)*slater_matrix_alpha_inv_det(i+1,j+1)
        enddo
      enddo
      i=elec_alpha_num
        !DIR$ VECTOR ALIGNED
      do k=1,4
        det_alpha_grad_lapl_curr(k,i) = det_alpha_grad_lapl_curr(k,i) + mo_grad_lapl_alpha(k,i,imo )*slater_matrix_alpha_inv_det(i,j  ) &
                                                                      + mo_grad_lapl_alpha(k,i,imo2)*slater_matrix_alpha_inv_det(i,j+1)
      enddo
    enddo

    j=elec_alpha_num
    imo  = mo_list_alpha_curr(j)
    do i=1,elec_alpha_num
        !DIR$ VECTOR ALIGNED
      do k=1,4
        det_alpha_grad_lapl_curr(k,i  ) = det_alpha_grad_lapl_curr(k,i  ) + mo_grad_lapl_alpha(k,i  ,imo)*slater_matrix_alpha_inv_det(i  ,j) 
      enddo
    enddo

  endif
    
  
END_PROVIDER


BEGIN_PROVIDER  [ double precision, det_beta_grad_lapl_curr, (4,elec_alpha_num+1:elec_num) ]
  implicit none
  BEGIN_DOC
  ! Gradient and Laplacian of the current beta determinant
  END_DOC
  
  integer                        :: i, j, k, l

  !DIR$ VECTOR ALIGNED
  do i=elec_alpha_num+1,elec_num
    det_beta_grad_lapl_curr(1,i) = 0.d0
    det_beta_grad_lapl_curr(2,i) = 0.d0
    det_beta_grad_lapl_curr(3,i) = 0.d0
    det_beta_grad_lapl_curr(4,i) = 0.d0
  enddo
  
  integer                          :: imo, imo2

! -------
! The following code does the same as this:
!
!  do j=1,elec_beta_num
!    imo = mo_list_beta_curr(j)
!    do i=elec_alpha_num+1,elec_num
!      do k=1,4
!        det_beta_grad_lapl_curr(k,i) = det_beta_grad_lapl_curr(k,i) +&
!            mo_grad_lapl_alpha(k,i,imo)*slater_matrix_beta_inv_det(i-elec_alpha_num,j)
!      enddo
!    enddo
!  enddo
!
! -------- 

  if (iand(elec_beta_num,1) == 0) then

    do j=1,elec_beta_num,2
      imo  = mo_list_beta_curr(j  )
      imo2 = mo_list_beta_curr(j+1)
      !DIR$ LOOP COUNT (16)
      do i=elec_alpha_num+1,elec_num,2
        l = i-elec_alpha_num
        !DIR$ VECTOR ALIGNED
        do k=1,4
          det_beta_grad_lapl_curr(k,i) = det_beta_grad_lapl_curr(k,i) +&
              mo_grad_lapl_beta(k,i,imo )*slater_matrix_beta_inv_det(l,j  ) + &
              mo_grad_lapl_beta(k,i,imo2)*slater_matrix_beta_inv_det(l,j+1) 
          det_beta_grad_lapl_curr(k,i+1) = det_beta_grad_lapl_curr(k,i+1) +&
              mo_grad_lapl_beta(k,i+1,imo )*slater_matrix_beta_inv_det(l+1,j  ) + &
              mo_grad_lapl_beta(k,i+1,imo2)*slater_matrix_beta_inv_det(l+1,j+1) 
        enddo
      enddo
    enddo

  else

    do j=1,elec_beta_num-1,2
      imo  = mo_list_beta_curr(j  )
      imo2 = mo_list_beta_curr(j+1)
      !DIR$ LOOP COUNT (16)
      do i=elec_alpha_num+1,elec_num-1,2
        l = i-elec_alpha_num
        !DIR$ VECTOR ALIGNED
        do k=1,4
          det_beta_grad_lapl_curr(k,i) = det_beta_grad_lapl_curr(k,i) +&
              mo_grad_lapl_beta(k,i,imo )*slater_matrix_beta_inv_det(l,j  ) + &
              mo_grad_lapl_beta(k,i,imo2)*slater_matrix_beta_inv_det(l,j+1) 
          det_beta_grad_lapl_curr(k,i+1) = det_beta_grad_lapl_curr(k,i+1) +&
              mo_grad_lapl_beta(k,i+1,imo )*slater_matrix_beta_inv_det(l+1,j  ) + &
              mo_grad_lapl_beta(k,i+1,imo2)*slater_matrix_beta_inv_det(l+1,j+1) 
        enddo
      enddo
      i = elec_num
      l = elec_num-elec_alpha_num
      !DIR$ VECTOR ALIGNED
      do k=1,4
        det_beta_grad_lapl_curr(k,i) = det_beta_grad_lapl_curr(k,i) +&
            mo_grad_lapl_beta(k,i,imo )*slater_matrix_beta_inv_det(l,j  ) + &
            mo_grad_lapl_beta(k,i,imo2)*slater_matrix_beta_inv_det(l,j+1) 
      enddo
    enddo

    j = elec_beta_num
    imo = mo_list_beta_curr(j)
    do i=elec_alpha_num+1,elec_num
      l = i-elec_alpha_num
      !DIR$ VECTOR ALIGNED
      do k=1,4
        det_beta_grad_lapl_curr(k,i) = det_beta_grad_lapl_curr(k,i) +&
            mo_grad_lapl_beta(k,i,imo)*slater_matrix_beta_inv_det(l,j)
      enddo
    enddo

  endif      

END_PROVIDER


 BEGIN_PROVIDER [ double precision, single_det_value ]
&BEGIN_PROVIDER [ double precision, single_det_grad, (elec_num_8,3) ]
&BEGIN_PROVIDER [ double precision, single_det_lapl, (elec_num) ]
  BEGIN_DOC
  ! Value of a single determinant wave function from the 1st determinant
  END_DOC
  det_i = 1
  det_j = 1
  integer                        :: i
  single_det_value = det_alpha_value_curr * det_beta_value_curr
  do i=1,elec_alpha_num
    single_det_grad(i,1)  = det_alpha_grad_lapl_curr(1,i) * det_beta_value_curr
    single_det_grad(i,2)  = det_alpha_grad_lapl_curr(2,i) * det_beta_value_curr
    single_det_grad(i,3)  = det_alpha_grad_lapl_curr(3,i) * det_beta_value_curr
    single_det_lapl(i)    = det_alpha_grad_lapl_curr(4,i) * det_beta_value_curr
  enddo
  do i=elec_alpha_num+1,elec_num
    single_det_grad(i,1)  = det_alpha_value_curr * det_beta_grad_lapl_curr(1,i)
    single_det_grad(i,2)  = det_alpha_value_curr * det_beta_grad_lapl_curr(2,i)
    single_det_grad(i,3)  = det_alpha_value_curr * det_beta_grad_lapl_curr(3,i)
    single_det_lapl(i)    = det_alpha_value_curr * det_beta_grad_lapl_curr(4,i)
  enddo
END_PROVIDER

