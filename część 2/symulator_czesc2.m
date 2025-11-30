clear; clc; close all;

% parametry obwodu
params.R1 = 0.1;
params.R2 = 10;
params.C  = 0.5;
params.L1 = 3;
params.L2 = 5;
params.M  = 0.8;   % nieużywane, zostawione dla porównania

% czas
tspan = [0 30];
h = 0.01;

% warunki początkowe
y0 = [0;0;0];

% ulepszony euler
solver = @euler_improved_solver;

% lista metod przybliżania M(uL1)
metody_M      = {'interp','spline','approx3','approx5'};
nazwy_metod_M = {'interpolacja wielomianowa', ...
                 'splajn 3 stopnia', ...
                 'aproks. wielom. st. 3', ...
                 'aproks. wielom. st. 5'};

% wymuszenia
% 2 -> e(t) = 240 sin(t)
% 4 -> e(t) = 120 sin(2*pi*50 t)
wymuszenia_id   = [2 4];
wymuszenia_opis = {'e(t) = 240 sin(t)', ...
                   'e(t) = 120 sin(2\pi50 t)'};

% symulacje
for w = 1:numel(wymuszenia_id)

    case_id = wymuszenia_id(w);
    e_fun   = make_source(case_id);

    wyniki = struct([]);

    for m = 1:length(metody_M)

        M_fun = make_M_fun(metody_M{m});

        f = @(t,y) obwod_nieliniowy_rhs(t, y, params, e_fun, M_fun);

        [t, Y] = solver(f, tspan, y0, h);

        wyniki(m).i1  = Y(1,:);
        wyniki(m).i2  = Y(2,:);
        wyniki(m).uC  = Y(3,:);
        wyniki(m).uR2 = params.R2 * Y(2,:);
    end

    % wykres i1(t)
    figure('Name', sprintf('i1(t) - wymuszenie %d', w)); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).i1, 'LineWidth', 1.1);
    end
    grid on;
    xlabel('t [s]');
    ylabel('i_1(t) [A]');
    title(['Przebieg i_1(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M, 'Location', 'best');

    % wykres i2(t)
    figure('Name', sprintf('i2(t) - wymuszenie %d', w)); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).i2, 'LineWidth', 1.1);
    end
    grid on;
    xlabel('t [s]');
    ylabel('i_2(t) [A]');
    title(['Przebieg i_2(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M, 'Location', 'best');

    % wykres uR2(t)
    figure('Name', sprintf('uR2(t) - wymuszenie %d', w)); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).uR2, 'LineWidth', 1.1);
    end
    grid on;
    xlabel('t [s]');
    ylabel('u_{R2}(t) [V]');
    title(['Przebieg u_{R2}(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M, 'Location', 'best');

    % wykres uC(t)
    figure('Name', sprintf('uC(t) - wymuszenie %d', w)); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).uC, 'LineWidth', 1.1);
    end
    grid on;
    xlabel('t [s]');
    ylabel('u_C(t) [V]');
    title(['Przebieg u_C(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M, 'Location', 'best');

end

disp('Symulacja części 2 zakończona.');
disp('Wykresy możesz zapisać ręcznie z poziomu okien Figure (File -> Save As).');
