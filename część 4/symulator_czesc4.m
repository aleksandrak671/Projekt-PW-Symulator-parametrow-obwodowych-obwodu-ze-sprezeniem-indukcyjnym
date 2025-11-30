% Część 4 projektu – wyznaczanie częstotliwości f dla której P(f)=406 W
clear; clc; close all;

% parametry obwodu
params.R1 = 0.1; params.R2 = 10; params.C = 0.5;
params.L1 = 3;   params.L2 = 5;  params.M = 0.8;

% ustawienia symulacji
tspan = [0 30];
h     = 0.001; 
y0    = [0;0;0];
P_target = 406;  

% funkcja celu P(f)
P_fun = @(f) moc_obwodu_f(f, params, tspan, y0, h);

% parametry solverów
tolF    = 1e-3;
maxIter = 40;

%% 1. metoda Bisekcji
% definiuje przedział poszukiwań
f_left  = 0.5; 
f_right = 1.0; 

[fbis, Fbis, it_bis, nP_bis] = metoda_bisekcji_mocy( ...
    P_fun, P_target, f_left, f_right, tolF, maxIter);

%% 2. metoda Siecznych
[fsiec, Fsiec, it_siec, nP_siec] = metoda_siecznych_mocy( ...
    P_fun, P_target, f_left, f_right, tolF, maxIter);

%% 3. metoda Quasi-Newtona z doborem df
% pnkt startowy biore z wyniku bisekcji
f0 = fbis;

fprintf('\n--- Analiza doboru kroku df ---\n');
df_test = 0.05; 
f_test = fbis;

for k = 1:10
    % pochodna dla kroku df
    val1 = (P_fun(f_test + df_test) - P_fun(f_test)) / df_test;
    
    % pochodna dla kroku df/2
    df_half = df_test / 2;
    val2 = (P_fun(f_test + df_half) - P_fun(f_test)) / df_half;
    
    % błąd względny
    err_proc = abs((val2 - val1)/val1) * 100;
    
    fprintf('df = %.5f, df/2 = %.5f, Zmiana pochodnej: %.4f%%\n', ...
            df_test, df_half, err_proc);
            
    if err_proc < 1.0
        df = df_test;
        fprintf('Warunek (<1%%) spełniony. Przyjęto df = %.5f\n', df);
        break;
    else
        df_test = df_half;
    end
end
fprintf('-------------------------------\n');

% właściwe obliczenia Quasi-Newtona
[fqn, Fqn, it_qn, nP_qn] = metoda_quasi_newton_mocy( ...
    P_fun, P_target, f0, df, tolF, maxIter);

%% wypisanie wyników
fprintf('\nWyniki końcowe:\n');
fprintf('Bisekcji:     f = %.6f Hz, iter = %d, wywołań P = %d\n', fbis, it_bis, nP_bis);
fprintf('Siecznych:    f = %.6f Hz, iter = %d, wywołań P = %d\n', fsiec, it_siec, nP_siec);
fprintf('Quasi-Newton: f = %.6f Hz, iter = %d, wywołań P = %d\n', fqn, it_qn, nP_qn);


%% funkcje lokalne

function P = moc_obwodu_f(f, params, tspan, y0, h)

    solver = @euler_improved_solver;

    e_fun = @(t) 100 * sin(2*pi*f*t);

    rhs = @(t,y) obwod_liniowy_rhs(t, y, params, e_fun);

    [t, Y] = solver(rhs, tspan, y0, h);

    i1 = Y(1,:);
    i2 = Y(2,:);

    % chwilowa moc
    p = params.R1 * i1.^2 + params.R2 * i2.^2;

    % całkowanie metodą Simpsona
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
    f_root = f_mid;
    F_root = F_mid;
    iter   = maxIter;
end

function [f_root, F_root, iter, nP] = metoda_siecznych_mocy( ...
        P_fun, P_target, f0, f1, tolF, maxIter)

    nP = 0;
    P0 = P_fun(f0); nP = nP + 1;
    P1 = P_fun(f1); nP = nP + 1;

    F0 = P0 - P_target;
    F1 = P1 - P_target;

    for k = 1:maxIter
        if abs(F1 - F0) < eps
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

        % pochodna F'(f)
        P_fd = P_fun(f + df); nP = nP + 1;
        F_fd = P_fd - P_target;

        dFdf = (F_fd - F_f) / df;

        if dFdf == 0
            break;
        end

        f = f - F_f / dFdf;
    end
    f_root = f;
    F_root = F_f;
    iter   = k;
end