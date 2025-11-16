function dydt = obwod_nieliniowy_rhs(t, y, params, e_fun, M_fun)

    i1 = y(1);
    i2 = y(2);
    uC = y(3);

    R1 = params.R1;
    R2 = params.R2;
    C  = params.C;
    L1 = params.L1;
    L2 = params.L2;

    e = e_fun(t);

    uL1 = e - R1*i1 - uC;

    M = M_fun(uL1);

    D = L1*L2 - M^2;

    di1 = ( L2*(e - R1*i1 - uC) + M*(R2*i2 - uC) ) / D;
    di2 = ( L1*(uC - R2*i2)    + M*(uC - e + R1*i1) ) / D;
    duC = (i1 - i2) / C;

    dydt = [di1; di2; duC];
end
