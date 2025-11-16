function M_fun = make_M_fun(method)

    % Dane z tabeli
    x = [20 50 100 150 200 250 280 300];
    y = [0.46 0.64 0.78 0.68 0.44 0.23 0.18 0.18];

    switch method

        case 'interp'
            M_fun = @(u) interp1(x,y,u,'linear','extrap');

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
