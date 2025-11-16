function [t, Y] = euler_improved_solver(f, tspan, y0, h)

t = tspan(1):h:tspan(2);
N = length(t);
Y = zeros(length(y0), N);
Y(:,1) = y0;

for k = 1:N-1
    k1 = f(t(k),     Y(:,k));
    k2 = f(t(k) + h, Y(:,k) + h*k1);
    Y(:,k+1) = Y(:,k) + (h/2) * (k1 + k2);
end
end
