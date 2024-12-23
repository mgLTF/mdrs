function [bestSol,tbestSol,bestObjective,noCycles,avObjective] = AlgorithmD(nNodes,Links,T,sP,nSP,timeLimit)
    t= tic;
    nFlows= size(T,1);
    bestObjective= inf;
    noCycles= 0;
    aux= 0;
    while toc(t) < timeLimit
        % Greedy random algorithm
        sol= zeros(1,nFlows);
        sol= BuildSolution(sol, nNodes,Links,T,sP,nSP,nFlows);
        sol= HillClimbing(sol, nNodes,Links,T,sP,nSP);
        %
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        load= max(max(Loads(:,3:4)));
        noCycles= noCycles+1;
        aux= aux+load;
        if load<bestObjective
            bestSol= sol;
            bestObjective= load;
            tbestSol= toc(t);
        end
    end
    avObjective= aux/noCycles;
end

function sol = BuildSolution(sol, nNodes,Links,T,sP,nSP,nFlows)
    Flow_order = randperm(nFlows);
    for f=Flow_order
        best = inf;
        for i=1:nSP(f)
            sol(f) = i;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load < best
                best= load;
                i_best= i;
            end
        end
        sol(f)= i_best;
    end
end
