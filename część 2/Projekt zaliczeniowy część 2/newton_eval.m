function p = newton_eval(x, a, xval)
    x = x(:);
    n = length(a);
    p = a(n);
    for k = n-1:-1:1
        p = p .* (xval - x(k)) + a(k);
    end
end
