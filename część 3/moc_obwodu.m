function [P_rect, P_simp] = moc_obwodu(t, i1, i2, params)
% Liczy energię wydzieloną w R1 i R2
% P_rect – metoda złożonych prostokątów
% P_simp – metoda złożonych parabol (Simpsona)

    R1 = params.R1;
    R2 = params.R2;

    % chwilowa moc
    g = R1 .* i1.^2 + R2 .* i2.^2;

    % krok czasowy (zakładam stały)
    h = t(2) - t(1);

    % złożone prostokąty (prawostronne)
    P_rect = sum(g(2:end)) * h;

    % złożona parabola (Simpson)
    N = numel(t);

    % Simpson wymaga nieparzystej liczby punktów -> parzystej liczby przedziałów
    if mod(N,2) == 0
        N = N - 1;
    end
    gS = g(1:N);

    P_simp = h/3 * ( ...
        gS(1) + gS(end) + ...
        4*sum(gS(2:2:end-1)) + ...
        2*sum(gS(3:2:end-2)) );
end
