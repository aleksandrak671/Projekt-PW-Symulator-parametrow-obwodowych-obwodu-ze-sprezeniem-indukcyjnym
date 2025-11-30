function dydt = obwod_liniowy_rhs(t, y, params, e_fun)
% prawa strona ODE dla obwodu liniowego (M = const)

i1 = y(1);
i2 = y(2);
uC = y(3);

R1 = params.R1;
R2 = params.R2;
C  = params.C;
L1 = params.L1;
L2 = params.L2;
M  = params.M;

e = e_fun(t);

D = L1*L2 - M^2;

di1 = ( L2*( -R1*i1 - uC + e ) + M*( R2*i2 ) ) / D;
di2 = ( L1*( -R2*i2 )        + M*( R1*i1 + uC - e) ) / D;
duC = (1/C) * i1;

dydt = [di1; di2; duC];
end
