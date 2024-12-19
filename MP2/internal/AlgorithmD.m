function [bestSol,tbestSol,bestObjective,totalNCycles, bestNCycles,avObjective] = AlgorithmD(nNodes,Links,T,sP,nSP,timeLimit, unicastServices)
    t= tic;
    nFlows= size(T,1);
    nFlows_unicast = nnz(ismember(T(:,1),unicastServices));
    
    bestObjective= inf;
    totalNCycles= 0;
    aux= 0;
    while toc(t) < timeLimit
        % Greedy random algorithm
        sol= zeros(1,nFlows);
        sol= BuildSolution(sol, nNodes,Links,T,sP,nSP,nFlows, nFlows_unicast);
        sol= HillClimbing(sol, nNodes,Links,T,sP,nSP, nFlows_unicast);
        %
        Loads= calculateLinkLoads(nNodes,Links,T(:,2:end),sP,sol);
        load= max(max(Loads(:,3:4)));
        totalNCycles= totalNCycles+1;
        aux= aux+load;
        if load<bestObjective
            bestNCycles = totalNCycles;
            bestSol= sol;
            bestObjective= load;
            tbestSol= toc(t);
        end
    end
    avObjective= aux/totalNCycles;
end

function sol = BuildSolution(sol, nNodes,Links,T,sP,nSP,nFlows, nFlows_unicast)
    
    sol(nFlows_unicast+1:nFlows) = 1;
    Flow_order = randperm(nFlows_unicast);
    %Flow_order = randperm(nFlows);
    for f=Flow_order
        best = inf;
        for i=1:nSP(f)
            sol(f) = i;
            Loads= calculateLinkLoads(nNodes,Links,T(:,2:end),sP,sol);
            load= max(max(Loads(:,3:4)));
            if load < best
                best= load;
                i_best= i;
            end
        end
        sol(f)= i_best;
    end
end
