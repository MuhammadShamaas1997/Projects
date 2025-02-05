function [lb, ub, dim, fobj] = Get_Functions_details_WH(func_name)
    switch func_name
        case 'F_eta'
            % Lower bounds for variables
            lb = [65, 22, 10, 0.8, 0.8, 0.2, 0.8, 2000, 2000, 10000];
            % Upper bounds for variables
            ub = [95, 36, 20, 2.2, 2.2, 1.4, 2.2, 10000, 10000, 10000];
            % Number of decision variables
            dim = 10;
            % Objective function handle
            fobj = @F_eta;
        otherwise
            error('Invalid function name.');
    end
end


% [lb, ub, dim, fobj] = Get_Functions_details_WH('F_eta')