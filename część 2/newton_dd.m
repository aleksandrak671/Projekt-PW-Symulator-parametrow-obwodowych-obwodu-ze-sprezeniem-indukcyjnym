function a = newton_dd(x, y)
    x = x(:);
    y = y(:);
    n = length(x);
    a = y;

    for j = 1:n-1
        for i = n:-1:j+1
            a(i) = (a(i) - a(i-1)) / (x(i) - x(i-j));
        end
    end
end
