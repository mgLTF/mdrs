function [sP,nSP,totalCosts_unicast, totalCosts_anycast,T] = createPathFlowsPairs(costMatrix,T,k, unicastservices,anycastNodes, protectedservices, k_pairs)

    nFlows= size(T,1);
    nFlows_unicast = nnz(ismember(T(:,1),unicastservices));
    n_anycastNodes = length(anycastNodes);
    totalCosts_unicast = zeros(nFlows_unicast, k);
    totalCosts_anycast = zeros(nFlows - nFlows_unicast, 1);
    
    % Possible anycast paths
    possible_shortestPath = cell(n_anycastNodes,1);
    possible_totalCost = zeros(n_anycastNodes,1);
    
    %k= 1;
    sP= cell(2,nFlows);
    nSP= zeros(1,nFlows);

    for f = 1:nFlows
        if ismember(T(f,1), unicastservices)
            % Flow is unicast
            if ismember(T(f,1), protectedservices)
                % Must be secured with 1:1
                [firstPaths,secondPaths,totalPairCosts] = kShortestPathPairs(costMatrix,T(f,2),T(f,3),k_pairs);
                sP{1,f}= firstPaths; sP{2,f}= secondPaths;
                nSP(f)= length(totalPairCosts);
                totalCosts_unicast(f,:) = totalPairCosts;
            else
                [shortestPath, totalCost] = kShortestPath(costMatrix,T(f,2),T(f,3),k);
                sP{1,f}= shortestPath;
                nSP(f)= length(totalCost);
                totalCosts_unicast(f,:) = totalCost;
            end
        else 
            % Flow is anycast
            if ismember(T(f,2), anycastNodes)
                sP{1,f} = {T(f,2)};
                nSP(f) = 1;
                T(f,3) = T(f,2);
                % totalCost is already initialize to zero
            else
                for node = 1:n_anycastNodes
                    [possible_shortestPath(node), possible_totalCost(node)] = kShortestPath(costMatrix,T(f,2),anycastNodes(node),1);
                end
                [M, I] = min(possible_totalCost);
                sP{1,f} = possible_shortestPath(I);
                nSP(f) = length(possible_totalCost(I));
                % index of array must begin in 1
                totalCosts_anycast(f - nFlows_unicast) = possible_totalCost(I);
                T(f,3) = anycastNodes(I);
            end
        end
    end
end