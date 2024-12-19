function [bestSol,tbestSol,bestObjective,totalNCycles, bestNCycles,avObjective] = AlgorithmDPair(nNodes,Links,T,sP,nSP,timeLimit, unicastServices, protectedservices)
    t= tic;
    nFlows= size(T,1);
    nFlows_unicast = nnz(ismember(T(:,1),unicastServices));
    
    bestObjective= inf;
    totalNCycles= 0;
    aux= 0;
    while toc(t) < timeLimit
        % Greedy random algorithm
        sol= BuildSolutionPair(nNodes,Links,T,sP,nSP,nFlows, nFlows_unicast);
        sol= HillClimbingPair(sol, nNodes,Links,T,sP,nSP, nFlows_unicast);
        %
        Loads= calculateLinkBand1to1(nNodes,Links,T(:,2:end),sP,sol);
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

function sol = BuildSolutionPair(nNodes,Links,T,sP,nSP,nFlows, nFlows_unicast)
    sol= zeros(1,nFlows);    
    sol(nFlows_unicast+1:nFlows) = 1;
    Flow_order = randperm(nFlows_unicast);
    for f=Flow_order
        best = inf;
        for i=1:nSP(f)
            sol(f) = i;
            Loads= calculateLinkBand1to1(nNodes,Links,T(:,2:end),sP,sol);
            load= max(max(Loads(:,3:4)));
            if load < best
                best= load;
                i_best= i;
            end
        end
        sol(f)= i_best;
    end
end
