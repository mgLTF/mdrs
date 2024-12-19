anycastNodes = [3, 10];
unicastservices = [1, 2];

k=12;
protectedservices = 2;
k_pairs = k;

[sP,nSP,totalCosts_unicast_a, totalCosts_anycast_a,T] = createPathFlowsPairs(D,T,k,unicastservices,anycastNodes, protectedservices, k_pairs);

timeLimit = 60;

[bestSol,tbestSol,bestObjective,totalNCycles, bestNCycles,avObjective] = AlgorithmDPair(nNodes,Links,T,sP,nSP,timeLimit, unicastservices, protectedservices);

fprintf("Total nº Cycles = %d\n", totalNCycles);
fprintf("Running time at which the algorithm obtains its best solution = %.2f s\n", tbestSol);
fprintf("The number of cycles at which the algorithm obtains its best solution. = %d\n", bestNCycles);

best_totalCosts_unicast1_a = zeros(1,nFlows_unicast1);
best_totalCosts_unicast2_a = zeros(1,nFlows_unicast-nFlows_unicast1);

% the worst and average round-trip delay should be only computed over the
% working paths of the flows, so the totalCost should not have the backup
% load
for f = 1:nFlows_unicast
    [shortestPath, totalCost] = kShortestPath(D,T(f,2),T(f,3),k);
    totalCosts_unicast_a(f,:) = totalCost;
end

for f=1:nFlows_unicast1
    best_totalCosts_unicast1_a(f) = totalCosts_unicast_a(f,bestSol(f));
end

for f= nFlows_unicast1+1:nFlows_unicast
    i = f-nFlows_unicast1;
    best_totalCosts_unicast2_a(i) = totalCosts_unicast_a(f, bestSol(f));
end

fprintf("Anycast nodes= %s\n", num2str(anycastNodes))

fprintf("Worst round-trip delay (unicast service s=1) = %.2f ms\n", max(best_totalCosts_unicast1_a*2)*1e3)
fprintf("Average round-trip delay (unicast service s=1) = %.2f ms\n", mean(best_totalCosts_unicast1_a*2)*1e3)

fprintf("Worst round-trip delay (unicast service s=2) = %.2f ms\n", max(best_totalCosts_unicast2_a*2)*1e3)
fprintf("Average round-trip delay (unicast service s=2) = %.2f ms\n", mean(best_totalCosts_unicast2_a*2)*1e3)

fprintf("Worst round-trip delay (anycast service) = %.2f ms\n", max(totalCosts_anycast_a*2)*1e3)
fprintf("Average round-trip delay (anycast service) = %.2f ms\n", mean(totalCosts_anycast_a*2)*1e3)

fprintf("Worst link load of the network = %.2f Gbps\n", bestObjective);