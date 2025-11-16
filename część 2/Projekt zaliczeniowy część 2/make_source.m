function e_fun = make_source(case_id)

switch case_id
    case 1
        T = 3;
        E = 120;
        e_fun = @(t) (mod(t,T) < T/2) * E;

    case 2
        e_fun = @(t) 240 * sin(t);

    case 3
        f = 5;
        e_fun = @(t) 210 * sin(2*pi*f*t);

    case 4
        f = 50;
        e_fun = @(t) 120 * sin(2*pi*f*t);

    otherwise
        error('Nieznane wymuszenie');
end
end
