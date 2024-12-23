function [sP,nSP,totalCosts_unicast, totalCosts_anycast,T] = createPathFlows(costMatrix,T,k,unicastservices,anycastNodes)
%CREATEPATHFLOWS Computes the shortest paths and their costs for unicast and anycast services.
%   [sP, nSP, totalCosts_unicast, totalCosts_anycast, T] = createPathFlows(D, T, k, unicastservices, anycastNodes)
%   computes the shortest paths for all traffic flows in the network, 
%   considering both unicast and anycast services. The function returns the
%   paths, the number of shortest paths, and the total costs for unicast 
%   and anycast services.
%
%   Inputs:
%       costMatrix - Matrix used to determine the shortest path between 
%           nodes (NxN matrix). This can represent weights, delays, or any 
%           other metric.
%       T - Matrix of traffic flows (nFlowsx5 matrix), with:
%           - Column 1: Service type (e.g. 1 for unicast service 1, 2 for unicast service 2, 3 for anycast service).
%           - Column 2: Source node of the traffic flow.
%           - Column 3: Destination node of the traffic flow (0 for anycast flows).
%           - Column 4: Throughput from source to destination (in Gbps).
%           - Column 5: Throughput from destination to source (in Gbps).
%       k - Number of shortest paths to compute (1 for the shortest path).
%       unicastservices - Vector of unicast service types (e.g., [1, 2]).
%       anycastNodes - Vector of nodes that can serve as anycast destinations (e.g., [3, 10]).
%
%   Outputs:
%       sP - Cell array of shortest paths for each traffic flow.
%       nSP - Vector of the number of shortest paths for each traffic flow.
%       totalCosts_unicast - Vector of total costs (based on D metric) for unicast flows.
%       totalCosts_anycast - Vector of total costs (based on D metric) for anycast flows.
%       T - Updated traffic flow matrix with destination nodes for anycast flows.
%
%   Example:
%       anycastNodes = [3, 10];
%       unicastservices = [1, 2];
%       [sP, nSP, totalCosts_unicast, totalCosts_anycast, T] = createPathFlows(D, T, 1, unicastservices, anycastNodes);
%
%   This function uses the kShortestPath function to compute the shortest paths and their costs.
    nFlows= size(T,1);
    nFlows_unicast = nnz(ismember(T(:,1),unicastservices));
    n_anycastNodes = length(anycastNodes);
    totalCosts_unicast = zeros(nFlows_unicast, 1);
    totalCosts_anycast = zeros(nFlows - nFlows_unicast, 1);
    
    % Possible anycast paths
    possible_shortestPath = cell(n_anycastNodes,1);
    possible_totalCost = zeros(n_anycastNodes,1);
    
    k= 1;
    sP= cell(1,nFlows);
    nSP= zeros(1,nFlows);

    for f = 1:nFlows
        if ismember(T(f,1), unicastservices)
            % Flow is unicast
            [shortestPath, totalCost] = kShortestPath(costMatrix,T(f,2),T(f,3),k);
            sP{f}= shortestPath;
            nSP(f)= length(totalCost);
            totalCosts_unicast(f) = totalCost;
        else 
            % Flow is anycast
            if ismember(T(f,2), anycastNodes)
                sP{f} = {T(f,2)};
                nSP(f) = 1;
                T(f,3) = T(f,2);
                % totalCost is already initialize to zero
            else
                for node = 1:n_anycastNodes
                    [possible_shortestPath(node), possible_totalCost(node)] = kShortestPath(costMatrix,T(f,2),anycastNodes(node),k);
                end
                [M, I] = min(possible_totalCost);
                sP{f} = possible_shortestPath(I);
                nSP(f) = length(possible_totalCost(I));
                % index of array must begin in 1
                totalCosts_anycast(f - nFlows_unicast) = possible_totalCost(I);
                T(f,3) = anycastNodes(I);
            end
        end
    end
end