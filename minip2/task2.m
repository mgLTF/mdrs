clear all
close all
clc

% Initial variables
load('InputDataProject2.mat');
nNodes = size(Nodes,1);

anycastNodes = [3 10];
unicastServices = [1 2];

v= 2e5;
D = L/v;
k = 6;
[sP,nSP,totalCosts_unicast, totalCosts_anycast,T] = createPathFlows(D, T, k, unicastServices, anycastNodes);


timeLimit = 30;

[bestSol,tbestSol,bestObjective,totalNCycles, bestNCycles,avObjective] = AlgorithmD(nNodes,Links,T,sP,nSP,timeLimit);


fprintf("Total nº Cycles = %d\n", totalNCycles);
fprintf("Running time at which the algorithm obtains its best solution = %d s\n", tbestSol);
fprintf("The number of cycles at which the algorithm obtains its best solution. = %d\n", bestNCycles);


nFlows_unicast = nnz(ismember(T(:,1),unicastServices));
nServices = length(unicastServices);
worstDelay = zeros(nServices, 1);
averageDelay = zeros(nServices, 1);
for f=1:nFlows_unicast
    
    averageDelay(T(f, 1)) = averageDelay(T(f, 1)) + totalCosts_unicast(f, bestSol(f));

    if totalCosts_unicast(f, bestSol(f)) > worstDelay(T(f, 1))
        worstDelay(T(f, 1)) = totalCosts_unicast(f, bestSol(f));
    end

end
%%
% Convert to milisseconds
averageDelay = averageDelay * (10^3);
worstDelay = worstDelay * (10^3);

nFlows_s1 = 12; nFlows_s2 = 8; %TODO

fprintf("Worst round-trip delay (service 1) = %.2f ms\n", worstDelay(1));
fprintf("Average round trip delay (service 1) = %.2f ms\n", averageDelay(1)/nFlows_s1);

fprintf("Worst round-trip delay (service 2) = %.2f ms\n", worstDelay(2));
fprintf("Average round trip delay (service 2) = %.2f ms\n", averageDelay(2)/nFlows_s1);

fprintf("Worst link load of the network = %d Gbps\n", bestObjective);
