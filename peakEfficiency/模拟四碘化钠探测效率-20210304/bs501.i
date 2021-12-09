photon eff
c 11 0 1 -2 imp:p=1  $ Li2CO3
11 1 -2.0 1 -2 imp:p=1  $ Li2CO3
21 2 -3.67 2 -3 imp:p=1 $ NaI
33 0 -100 #11 #21 imp:p=1
99 0 100 imp:p=0

1 rpp -20.002 20.002 -5   5 -3 3
2 rpp -20.001 20.001 -10 10 -8 8
3 rpp -20     20     -200 200 -180 180
100 rpp -9876 9876 -9876 9876 -9876 9876

m1 3000 2 6000 1 8016 3 $ Li2CO3(2)
m2 11000 1 53000 1 $NaI(3.67)
mode p
c cut:n 2j 0 2j $ direct simulate neutrons 
c phys:n j 100 2j $ direct simulate neutrons
sdef par=2 erg=8 x=0 y=0 z=0
f8:p 21
c e8 0.001 0.99999 1.00001 1.99999 2.00001 2.99999 3.00001 3.99999 4.00001
c      4.99999 5.00001 5.99999 6.00001 6.99999 7.00001 7.99999 8.00001
e8 0.01 0.02 817i 8.2
nps 1e5
prdmp j 1e4 j 2