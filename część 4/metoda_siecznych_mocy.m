function [f_root, F_root, iter, nP] = metoda_siecznych_mocy( ...
    P_fun, P_target, f0, f1, tolF, maxIter)

% P_fun    – uchwyt do P(f)
% P_target – zadana moc
% f0, f1   – dwa pierwsze przybliżenia (u nas: f_left, f_right)
% tolF     – tolerancja
% maxIter  – maks. iteracji

nP = 0;

% wartości F w dwóch pierwszych punktach
P0 = P_fun(f0);  nP = nP + 1;   F0 = P0 - P_target;
P1 = P_fun(f1);  nP = nP + 1;   F1 = P1 - P_target;

for k = 1:maxIter
    % krok metody siecznych
    df = f1 - f0;
    dF = F1 - F0;

    if abs(dF) < eps
        break;  % unikamy dzielenia przez zero
    end

    f2 = f1 - F1 * df / dF;

    P2 = P_fun(f2);  nP = nP + 1;
    F2 = P2 - P_target;

    if abs(F2) < tolF
        f_root = f2;
        F_root = F2;
        iter   = k;
        return;
    end

    % przesuwamy punkty
    f0 = f1; F0 = F1;
    f1 = f2; F1 = F2;
end

f_root = f1;
F_root = F1;
iter   = maxIter;
end
