clear; clc; close all;

%% parametry obwodu
params.R1 = 0.1;
params.R2 = 10;
params.C  = 0.5;
params.L1 = 3;
params.L2 = 5;
params.M  = 0.8;   % nieużywane, zostawione dla porównania

%% czas
tspan = [0 30];
h = 0.001;

%% warunki początkowe
y0 = [0;0;0];

%% ulepszony euler
solver = @euler_improved_solver;

%% lista metod przybliżania M(uL1)
metody_M      = {'interp','spline','approx3','approx5'};
nazwy_metod_M = {'interpolacja wielomianowa', ...
                 'splajn 3 stopnia', ...
                 'aproks. wielom. st. 3', ...
                 'aproks. wielom. st. 5'};

%% wymuszenia
wymuszenia_id   = [2 4];
wymuszenia_opis = {'e(t) = 240 sin(t)', ...
                   'e(t) = 120 sin(2π50 t)'};

%% symulacje
for w = 1:2
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

    %% wykres i1(t)
    figure('Name','i1'); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).i1, 'LineWidth',1.1);
    end
    grid on;
    xlabel('t [s]'); ylabel('i_1(t) [A]');
    title(['Przebieg i_1(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M,'Location','best');
    saveas(gcf, sprintf('Cz2_i1_%d.png', w));

    %% wykres i2(t)
    figure('Name','i2'); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).i2, 'LineWidth',1.1);
    end
    grid on;
    xlabel('t [s]'); ylabel('i_2(t) [A]');
    title(['Przebieg i_2(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M,'Location','best');
    saveas(gcf, sprintf('Cz2_i2_%d.png', w));

    %% wykres uR2(t)
    figure('Name','uR2'); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).uR2, 'LineWidth',1.1);
    end
    grid on;
    xlabel('t [s]'); ylabel('u_{R2}(t) [V]');
    title(['Przebieg u_{R2}(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M,'Location','best');
    saveas(gcf, sprintf('Cz2_uR2_%d.png', w));

    %% wykres uC(t)
    figure('Name','uC'); hold on;
    for m = 1:length(metody_M)
        plot(t, wyniki(m).uC, 'LineWidth',1.1);
    end
    grid on;
    xlabel('t [s]'); ylabel('u_C(t) [V]');
    title(['Przebieg u_C(t) dla ' wymuszenia_opis{w}]);
    legend(nazwy_metod_M,'Location','best');
    saveas(gcf, sprintf('Cz2_uC_%d.png', w));

end

disp("Symulacja części 2 zakończona.");
disp("Pliki zapisano: Cz2_i1_*.png, Cz2_i2_*.png, Cz2_uR2_*.png, Cz2_uC_*.png");
