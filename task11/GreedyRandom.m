function [sol, load, best_energy] = GreedyRandom(nFlows, nNodes, Links, T, sP, nSP, L,  alfa)
    %nFlows = size(T,1);
    % random order of flows 
    randFlows = randperm(nFlows);
    sol = zeros(1, nFlows);

    % iterate through each flow
    for flow = randFlows
        path_index = 0;
        best_load = inf;
        best_energy = inf;

        % test every path "possible" in a certain load
        for path = 1 : nSP(flow)
            % try the path for that flow
            sol(flow) = path;
            % calculate loads
            Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);
            load = max(max(Loads(:, 3:4)));
            % calculate energy
            energy= calculateEnergy(nNodes, Links, T, sP, sol, L, alfa);
            % check if the current load is better then bestLoad
            if energy < best_energy
                % change index of path and load
                path_index = path;
                best_load = load;
                best_energy = energy;   
            end
        end
        sol(flow) = path_index;
    end
    load = best_load;
end