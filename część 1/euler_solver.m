function [t, Y] = euler_solver(f, tspan, y0, h)

t = tspan(1):h:tspan(2);
N = length(t);
Y = zeros(length(y0), N);
Y(:,1) = y0;

for k = 1:N-1
    Y(:,k+1) = Y(:,k) + h * f(t(k), Y(:,k));
end
end
