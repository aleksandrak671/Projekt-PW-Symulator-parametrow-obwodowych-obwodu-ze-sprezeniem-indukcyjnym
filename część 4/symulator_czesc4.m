% Część 4 projektu – wyznaczanie częstotliwości f dla której P(f)=406 W
% obwód liniowy, wymuszenie e(t) = 100 sin(2*pi*f*t)

clear; clc; close all;

% parametry obwodu (takie same jak wcześniej)
params.R1 = 0.1;
params.R2 = 10;
params.C  = 0.5;
params.L1 = 3;
params.L2 = 5;
params.M  = 0.8;     % w części 4 używamy obwodu liniowego

% czas całkowania i warunki początkowe
tspan = [0 30];
h     = 0.001;       % ten sam "mały" krok co w części 3
y0    = [0;0;0];

% moc docelowa
P_target = 406;  

% uchwyt do funkcji P(f) 
P_fun = @(f) moc_obwodu_f(f, params, tspan, y0, h);

% ustawienia metod szukania miejsca zerowego
tolF    = 1e-3;      % tolerancja na |F(f)| = |P(f) - P_target|
maxIter = 40;

f_right = 1.0;     

% metoda bisekcji
[fbis, Fbis, it_bis, nP_bis] = metoda_bisekcji_mocy( ...
    P_fun, P_target, f_left, f_right, tolF, maxIter);

% metoda siecznych (start z tego samego przedziału)
[fsiec, Fsiec, it_siec, nP_siec] = metoda_siecznych_mocy( ...
    P_fun, P_target, f_left, f_right, tolF, maxIter);

% metoda quasi-Newtona – start z wyniku bisekcji
f0  = fbis;      
df  = 0.01;         
[fqn, Fqn, it_qn, nP_qn] = metoda_quasi_newton_mocy( ...
    P_fun, P_target, f0, df, tolF, maxIter);

% wypisanie wyników w formie tabelki do raportu
fprintf('\nWyniki części 4 (P_target = %.1f W, h = %.4f s)\n', P_target, h);
fprintf('-------------------------------------------------------------\n');
fprintf('Metoda           f [Hz]        F(f)        Iteracje   Liczba P\n');
fprintf('-------------------------------------------------------------\n');
fprintf('Bisekcji     %10.6f   % .3e   %4d       %4d\n', ...
        fbis, Fbis, it_bis, nP_bis);
fprintf('Siecznych    %10.6f   % .3e   %4d       %4d\n', ...
        fsiec, Fsiec, it_siec, nP_siec);
fprintf('Quasi-Newton %10.6f   % .3e   %4d       %4d\n', ...
        fqn, Fqn, it_qn, nP_qn);
fprintf('-------------------------------------------------------------\n');

% lokalne funkcje

function P = moc_obwodu_f(f, params, tspan, y0, h)
    % Liczy moc P(f) dla częstotliwości f
    % 1) rozwiązuje układ równań (ulepszony Euler)
    % 2) liczy chwilową moc p(t) = R1*i1^2 + R2*i2^2
    % 3) całkuje p(t) metodą Simpsona (tak jak w części 3)

    solver = @euler_improved_solver;

    % wymuszenie e(t) = 100 sin(2*pi*f*t)
    e_fun = @(t) 100 * sin(2*pi*f*t);

    % układ liniowy z obwod_liniowy_rhs
    rhs = @(t,y) obwod_liniowy_rhs(t, y, params, e_fun);

    [t, Y] = solver(rhs, tspan, y0, h);

    i1 = Y(1,:);
    i2 = Y(2,:);

    p = params.R1 * i1.^2 + params.R2 * i2.^2;   % chwilowa moc R1+R2

    % metoda Simpsona
    N = numel(t);

    if mod(N-1,2) ~= 0
        t = t(1:end-1);
        p = p(1:end-1);
        N = numel(t);
    end

    h_local = t(2) - t(1);
    P = h_local/3 * ( p(1) + p(end) ...
             + 4*sum(p(2:2:N-1)) + 2*sum(p(3:2:N-2)) );
end


function [f_root, F_root, iter, nP] = metoda_bisekcji_mocy( ...
        P_fun, P_target, f_left, f_right, tolF, maxIter)

    % Szukanie f: F(f)=P(f)-P_target = 0 metodą bisekcji

    nP = 0;

    P_left  = P_fun(f_left);   nP = nP + 1;
    P_right = P_fun(f_right);  nP = nP + 1;

    F_left  = P_left  - P_target;
    F_right = P_right - P_target;

    if F_left * F_right > 0
        error('Metoda bisekcji: F(f_left) i F(f_right) mają ten sam znak.');
    end

    for k = 1:maxIter
        f_mid = 0.5 * (f_left + f_right);
        P_mid = P_fun(f_mid); nP = nP + 1;
        F_mid = P_mid - P_target;

        if abs(F_mid) < tolF
            f_root = f_mid;
            F_root = F_mid;
            iter   = k;
            return;
        end

        if F_left * F_mid < 0
            f_right = f_mid;
            F_right = F_mid;
        else
            f_left = f_mid;
            F_left = F_mid;
        end
    end

    % jeśli wyszliśmy z pętli przez maxIter
    f_root = f_mid;
    F_root = F_mid;
    iter   = maxIter;
end


function [f_root, F_root, iter, nP] = metoda_siecznych_mocy( ...
        P_fun, P_target, f0, f1, tolF, maxIter)

    % Metoda siecznych (start z dwóch punktów f0, f1)

    nP = 0;

    P0 = P_fun(f0); nP = nP + 1;
    P1 = P_fun(f1); nP = nP + 1;

    F0 = P0 - P_target;
    F1 = P1 - P_target;

    for k = 1:maxIter
        if F1 == F0
            warning('Metoda siecznych: F1 == F0, zatrzymuję.');
            break;
        end

        f2 = f1 - F1 * (f1 - f0) / (F1 - F0);

        P2 = P_fun(f2); nP = nP + 1;
        F2 = P2 - P_target;

        if abs(F2) < tolF
            f_root = f2;
            F_root = F2;
            iter   = k;
            return;
        end

        f0 = f1; F0 = F1;
        f1 = f2; F1 = F2;
    end

    f_root = f2;
    F_root = F2;
    iter   = k;
end


function [f_root, F_root, iter, nP] = metoda_quasi_newton_mocy( ...
        P_fun, P_target, f0, df, tolF, maxIter)

    % Metoda quasi-Newtona

    nP = 0;
    f  = f0;

    for k = 1:maxIter
        P_f = P_fun(f);     nP = nP + 1;
        F_f = P_f - P_target;

        if abs(F_f) < tolF
            f_root = f;
            F_root = F_f;
            iter   = k;
            return;
        end

        % pochodna F'(f) ≈ [F(f+df)-F(f)]/df
        P_fd = P_fun(f + df); nP = nP + 1;
        F_fd = P_fd - P_target;

        dFdf = (F_fd - F_f) / df;

        if dFdf == 0
            warning('Metoda quasi-Newtona: pochodna ≈ 0, zatrzymuję.');
            break;
        end

        f = f - F_f / dFdf;
    end

    f_root = f;
    F_root = F_f;
    iter   = k;
end
