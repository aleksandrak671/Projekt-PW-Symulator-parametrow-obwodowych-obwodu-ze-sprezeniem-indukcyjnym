function M_fun = make_M_fun(method)

    % dane z tabeli
    x = [20 50 100 150 200 250 280 300];
    y = [0.46 0.64 0.78 0.68 0.44 0.23 0.18 0.18];

    switch method
        case 'interp'
            % obliczam współczynniki wielomianu Newtona
            a = newton_dd(x, y);
            % zwracam funkcję obliczającą wartość wielomianu
            M_fun = @(u) newton_eval(x, a, u);

        case 'spline'
            M_fun = @(u) interp1(x,y,u,'spline','extrap');

        case 'approx3'
            p = polyfit(x,y,3);
            M_fun = @(u) polyval(p,u);

        case 'approx5'
            p = polyfit(x,y,5);
            M_fun = @(u) polyval(p,u);

        otherwise
            error('Nieznana metoda M');
    end
end