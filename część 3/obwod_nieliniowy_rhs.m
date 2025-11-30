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

    % 1. obliczam napięcie na cewce L1 (z oczka pierwotnego)
    % równanie: e = uR1 + uC + uL1  =>  uL1 = e - R1*i1 - uC
    uL1_val = e - R1*i1 - uC;

    % 2. wyznaczam aktualne M z charakterystyki
    M = M_fun(uL1_val);

    % 3. wyznacznik układu
    D = L1*L2 - M^2;

    % 4. rozwiązanie układu równań na pochodne prądów
    % L1*di1 + M*di2  = e - R1*i1 - uC
    % M*di1  + L2*di2 = -R2*i2
    
    di1 = ( L2*(e - R1*i1 - uC) - M*(-R2*i2) ) / D;
    di2 = ( L1*(-R2*i2) - M*(e - R1*i1 - uC) ) / D;
    
    % 5. pochodna napięcia na kondensatorze
    duC = i1 / C;

    dydt = [di1; di2; duC];
end