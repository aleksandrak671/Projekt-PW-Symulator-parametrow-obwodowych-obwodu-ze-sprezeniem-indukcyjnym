function e_fun = make_source(case_id)
% zwraca funkcję e(t) zgodnie z zadaniem

switch case_id
    case 1  % prostokąt
        E = 120;
        T = 3;
        e_fun = @(t) (mod(t,T) < T/2) * E;

    case 2  % 240 sin(t)
        e_fun = @(t) 240*sin(t);

    case 3  % 210 sin(2π 5 t)
        f = 5;
        e_fun = @(t) 210*sin(2*pi*f*t);

    case 4  % 120 sin(2π 50 t)
        f = 50;
        e_fun = @(t) 120*sin(2*pi*f*t);

    otherwise
        error('Nieznane wymuszenie');
end
end
