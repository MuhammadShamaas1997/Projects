function test_admm()
    clc;
    % Zielfunktion f(x, y) = x^2 + y^2
    f = @(x) x(1)^2 + x(2)^2;
    
    % Nebenbedingung c(x, y) = x*y - 1
    c = @(x) x(1) * x(2) - 1;

    % Anfangswerte
    x0 = [2; 0.5]; % Beispiel f??r Startwert
    y0 = 1; % Beispielwert f??r y
    p0 = 1; % Penalty Startwert

    % Test mit ADMM f??r epsilon = 10^-7
    epsilon1 = 10^-7;
    disp('--- Test mit epsilon = 10^-7 ---');
    tic; % Start der Zeitmessung
    [x_sol1, y_sol1, iter1] = ADMM_F(f, c, x0, y0, p0, epsilon1, 1000);
    admm_time1 = toc; % Ende der Zeitmessung
    disp('L??sung f??r ADMM mit epsilon = 10^-7:');
    disp(['x = ', num2str(x_sol1(1)), ', y = ', num2str(x_sol1(2))]);
    disp(['Anzahl der Iterationen: ', num2str(iter1)]);
    disp(['Laufzeit ADMM: ', num2str(admm_time1), ' Sekunden']);

    % Test mit ADMM f??r epsilon = 10^-8
    epsilon2 = 10^-8;
    disp('--- Test mit epsilon = 10^-8 ---');
    tic; % Start der Zeitmessung
    [x_sol2, y_sol2, iter2] = ADMM_F(f, c, x0, y0, p0, epsilon2, 1000);
    admm_time2 = toc; % Ende der Zeitmessung
    disp('L??sung f??r ADMM mit epsilon = 10^-8:');
    disp(['x = ', num2str(x_sol2(1)), ', y = ', num2str(x_sol2(2))]);
    disp(['Anzahl der Iterationen: ', num2str(iter2)]);
    disp(['Laufzeit ADMM: ', num2str(admm_time2), ' Sekunden']);
    
    % Vergleich mit fmincon (mit Nebenbedingungen)
    disp('--- Vergleich mit fmincon (mit Nebenbedingungen) ---');
    tic; % Start der Zeitmessung
    nonlcon = @(x) deal([], c(x)); % Ungleichungs-Nebenbedingungen
    options_con = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');
    [x_con, fval_con, exitflag_con, output_con] = fmincon(f, x0, [], [], [], [], [], [], nonlcon, options_con);
    fmincon_time = toc; % Ende der Zeitmessung
    disp('L??sung f??r fmincon:');
    disp(['x = ', num2str(x_con(1)), ', y = ', num2str(x_con(2))]);
    disp(['Anzahl der Iterationen: ', num2str(output_con.iterations)]);
    disp(['Laufzeit fmincon: ', num2str(fmincon_time), ' Sekunden']);
end

function [x, y, k] = ADMM_F(f, c, x0, y0, p0, epsilon, max_iter)
    % Initialisierung
    x = x0;
    y = y0;
    p = p0;
    k = 0;
    delta_x = 1e-6;  % Toleranz f??r Abbruchbedingung bzgl. x
    delta_eta = 1e-6; % Abbruchbedingung f??r Machbarkeit ??(x)
    max_inner_iter = 1000;  % Maximale Anzahl innerer Schleifen
    prev_eta = inf;  % Zum Speichern des vorherigen ??-Wertes
    iteration_data = [];  % F??r die Speicherung der Iterationsdaten
    
    % Beginne Iterationen
    while k < max_iter
        omega_val = omega0(x, y, @(x, y) grad_L_rho(x, y, f, c, p));
        eta_val = eta(x, c);
        f_val = f(x);
        step_size = norm(x);  % Schrittgr????e
        optimality = norm(grad_L_rho(x, y, f, c, p));  % Optimalit??t
        
        % Speichere Iterationsdaten
        iteration_data = [iteration_data; k, f_val, step_size, optimality, x(1), x(2)];
        
        if omega_val < epsilon && eta_val < epsilon
            disp('Optimalit??tskriterium erf??llt. Algorithmus beendet.');
            break;
        end
        
        % Zus??tzliche Abbruchbedingung: Wenn ??(x) sich nicht signifikant ??ndert
        if abs(eta_val - prev_eta) < delta_eta
            disp('??nderung von ??(x) ist kleiner als delta_eta. Algorithmus beendet.');
            break;
        end
        
        prev_eta = eta_val;  % Speichere den aktuellen Wert von ??(x)
        
        % Innerer Schleifenabschnitt f??r Updates von x
        j = 0;
        restflag = 0;
        x_j = x;
        x_old = x;  % Speichere den alten Wert von x f??r die Abbruchbedingung
        
        while true
            if j > max_inner_iter
                disp('Maximale Anzahl innerer Schleifen erreicht. Schleife beendet.');
                break;
            end

            if j == 0
                x_j = sufficient_decrease_step(x_j, f, c, p);
            else
                for i = 1:length(x)
                    x_j(i) = blockwise_minimization(x_j, i, f, c, p, y);
                end
            end
            
            % Abbruchbedingung: Wenn sich x nicht mehr signifikant ??ndert
            if norm(x_j - x_old) < delta_x
                break;
            end
            
            x_old = x_j;
            j = j + 1;
        end
        
        % Aktualisierung der Werte f??r x^(k+1) und y^(k+1)
        [x, y] = update_xy(x_j, y, f, c, p);
        
        % Erh??hung des Penalty-Parameters, falls Restflag gesetzt ist
        if restflag == 1
            p = increase_penalty(p);
        end
        
        k = k + 1;
    end
    
    % Zeige die Iterationstabelle an
    display_table(iteration_data);
end

% Ausgabe der Iterationen in einer Tabelle
function display_table(iteration_data)
    % ??berschriften f??r die Tabelle
    disp('Iteration  Func-count    f(x)         Step-size     Optimality');
    disp('---------------------------------------------------------------');
    for i = 1:size(iteration_data, 1)
        fprintf('%9d %11d %13.6f %14.6f %13.6f\n', iteration_data(i, 1), i * 3, iteration_data(i, 2), iteration_data(i, 3), iteration_data(i, 4));
        fprintf('x = %.6f, y = %.6f\n', iteration_data(i, 5), iteration_data(i, 6));
    end
end

function x_j = sufficient_decrease_step(x, f, c, p)
    % Verwende fminunc, um einen Schritt mit gen??gendem Abfall zu machen
    options = optimoptions('fminunc', 'Display', 'none');  % Ausgabe unterdr??ckt
    x_j = fminunc(@(x) f(x) + penalty_term(c(x), p), x, options);
end

function x_i = blockwise_minimization(x, i, f, c, p, y)
    % Blockweise Minimierung mit fmincon
    options = optimoptions('fmincon', 'Display', 'none');  % Ausgabe unterdr??ckt
    x_i = fmincon(@(xi) block_lagrangian(x, xi, i, f, c, p, y), x(i), [], [], [], [], [], [], [], options);
end

function [x_new, y_new] = update_xy(x, y, f, c, p)
    % Aktualisiert x^(k+1) und y^(k+1)
    x_new = x - p * grad_c(x);
    y_new = y;
end

function p_new = increase_penalty(p)
    % Erh??ht den Penalty-Parameter ??
    p_new = p * 1.1;
end

function L = block_lagrangian(x, xi, i, f, c, p, y)
    % Berechnet die Lagrange-Funktion f??r den i-ten Block
    x_new = x;
    x_new(i) = xi;
    L = f(x_new) + p * (norm(c(x_new))^2);
end

function val = omega0(x, y, grad_L_rho)
    % Berechne den dualen Machbarkeitsfehler ?????(x, y)
    grad_L_rho_val = grad_L_rho(x, y);
    x_proj = proj_x(x - grad_L_rho_val);
    val = norm(x_proj - x);
end

function grad = grad_L_rho(x, y, f, c, p)
    % Berechnet den Gradienten der augmentierten Lagrange-Funktion
    grad_f = [2 * x(1); 2 * x(2)];
    grad_c = [x(2); x(1)];
    grad = grad_f + p * c(x) * grad_c;
end

function x_proj = proj_x(x)
    % Platzhalter f??r die Projektion, abh??ngig von der Problemdefinition
    x_proj = x; % Hier einfach Identit??t
end

function val = eta(x, c)
    % Berechne die Machbarkeitsbedingung ??(x)
    val = norm(c(x));
end

function val = penalty_term(c_val, p)
    % Bestrafung f??r die Verletzung der Nebenbedingung
    val = p * c_val^2;
end

function grad_c_val = grad_c(x)
    % Berechnet den Gradienten der Nebenbedingung c(x) = x1 * x2 - 1
    grad_c_val = [x(2); x(1)];
end
