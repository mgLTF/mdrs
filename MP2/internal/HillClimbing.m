function sol = HillClimbing(sol, nNodes,Links,T,sP,nSP)
    nFlows = length(sol);
    improving = true;
    while improving
        % Get current best solution and respective load
        current_sol = sol;
        Loads= calculateLinkLoads(nNodes,Links,T,sP,current_sol);
        load= max(max(Loads(:,3:4)));
        best = load;
        bestmove = [];
        % Improvement loop onto neighboring solutions
        for f=1:nFlows
            for i=1:nSP(f)
                % The current solution is not a neighbor of itself
                if i==current_sol(f)
                    continue
                end
                sol(f) = i;
                Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                load= max(max(Loads(:,3:4)));
                if load < best
                    best= load;
                    i_best= i;
                    bestmove = [f, i_best];
                end
            end
            % recover the starting solution
            sol(f)= current_sol(f);
        end
        if isempty(bestmove)
            improving = false;
        else
            sol(bestmove(1))= bestmove(2);
            bestmove = [];
        end
    end
end