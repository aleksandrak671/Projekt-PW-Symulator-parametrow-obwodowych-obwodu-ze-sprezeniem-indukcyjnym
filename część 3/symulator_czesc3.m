% symulator_czesc3.m
% Część 3 projektu – energia wydzielana w R1 i R2
% (obwód liniowy i nieliniowy, metody: złożone prostokąty i parabola)

clear; clc; close all;

%% parametry obwodu (jak w cz. 1/2)
params.R1 = 0.1;
params.R2 = 10;
params.C  = 0.5;
params.L1 = 3;
params.L2 = 5;
params.M  = 0.8;   % dla obwodu liniowego

%% czas całkowania
tspan = [0 30];

% dwa różne kroki: bardzo mały i duży
h_list = [0.001, 0.2];

% warunki początkowe
y0 = [0;0;0];

% solver ulepszony Eulera
solver = @euler_improved_solver;

%% lista wymuszeń (1..4 jak w części 1 + 5: e(t)=1 V)
wymuszenia_id   = [1 2 3 4 5];
wymuszenia_opis = { ...
    'prostokąt 120 V', ...
    'e(t) = 240 sin(t)', ...
    'e(t) = 210 sin(2\pi 5 t)', ...
    'e(t) = 120 sin(2\pi 50 t)', ...
    'e(t) = 1 V'};

% lin – obwód liniowy (stałe M)
% nl  – obwód nieliniowy (M(uL1))
wyniki_lin  = struct();
wyniki_niel = struct();

% obwód liniowy
for kh = 1:numel(h_list)
    h = h_list(kh);
    fprintf('--- LINIOWY, h = %.4f ---\n', h);

    for w = 1:numel(wymuszenia_id)

        case_id = wymuszenia_id(w);
        e_fun   = make_source(case_id);

        % prawa strona dla obwodu liniowego
        f = @(t,y) obwod_liniowy_rhs(t, y, params, e_fun);

        % rozwiązanie równań różniczkowych
        [t, Y] = solver(f, tspan, y0, h);

        i1 = Y(1,:);
        i2 = Y(2,:);

        [P_rect, P_simp] = moc_obwodu(t, i1, i2, params);

        wyniki_lin(kh,w).h       = h;
        wyniki_lin(kh,w).case_id = case_id;
        wyniki_lin(kh,w).opis    = wymuszenia_opis{w};
        wyniki_lin(kh,w).P_rect  = P_rect;
        wyniki_lin(kh,w).P_simp  = P_simp;

        fprintf('  %s: P_rect = %.4f W,  P_simp = %.4f W\n', ...
            wymuszenia_opis{w}, P_rect, P_simp);
    end
end

% wybieram jedną metodę M(uL1) – np. splajn 3 stopnia
metoda_M = 'spline';

for kh = 1:numel(h_list)
    h = h_list(kh);
    fprintf('--- NIELINIOWY (%s), h = %.4f ---\n', metoda_M, h);

    for w = 1:numel(wymuszenia_id)

        case_id = wymuszenia_id(w);
        e_fun   = make_source(case_id);

        % funkcja M(uL1) z cz. 2
        M_fun = make_M_fun(metoda_M);

        % prawa strona dla obwodu nieliniowego
        f = @(t,y) obwod_nieliniowy_rhs(t, y, params, e_fun, M_fun);

        % rozwiązanie równań różniczkowych
        [t, Y] = solver(f, tspan, y0, h);

        i1 = Y(1,:);
        i2 = Y(2,:);

        % obliczenie energii (prostokąty + parabola)
        [P_rect, P_simp] = moc_obwodu(t, i1, i2, params);

        wyniki_niel(kh,w).h       = h;
        wyniki_niel(kh,w).case_id = case_id;
        wyniki_niel(kh,w).opis    = wymuszenia_opis{w};
        wyniki_niel(kh,w).P_rect  = P_rect;
        wyniki_niel(kh,w).P_simp  = P_simp;

        fprintf('  %s: P_rect = %.4f W,  P_simp = %.4f W\n', ...
            wymuszenia_opis{w}, P_rect, P_simp);
    end
end

disp('Część 3 – obliczanie energii – zakończona.');
disp('Wyniki są w strukturach: wyniki_lin oraz wyniki_niel (dla obu kroków h).');
