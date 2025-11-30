clear; clc; close all;

% parametry obwodu
params.R1 = 0.1;
params.R2 = 10;
params.C  = 0.5;
params.L1 = 3;
params.L2 = 5;
params.M  = 0.8;

% czas
tspan = [0 30];
h = 0.001;

% warunki początkowe
y0 = [0;0;0];

% lista metod
metody = {@euler_solver, @euler_improved_solver};
nazwy  = {'Euler', 'Euler ulepszony'};

for m = 1:2
    solver = metody{m};

    for s = 1:4
        e_fun = make_source(s);
        f = @(t,y) obwod_liniowy_rhs(t, y, params, e_fun);

        [t, Y] = solver(f, tspan, y0, h);

        i1 = Y(1,:);
        i2 = Y(2,:);
        uC = Y(3,:);
        e_vals = arrayfun(e_fun, t);

        figure;
        subplot(3,1,1); plot(t, i1); title(sprintf('i1(t) - %s - wymuszenie %d', nazwy{m}, s));
        subplot(3,1,2); plot(t, i2); title('i2(t)');
        subplot(3,1,3); plot(t, uC); title('uC(t)');
    end
end
