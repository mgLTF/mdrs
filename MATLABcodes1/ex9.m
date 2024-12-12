
%load("InputData2.m");
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);


k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);

for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

timeLimit = 5;
[bestSol,bestObjective,noCycles,avObjective, bestLoadTime] = RandomAlgorithm(nNodes,Links,T,sP,nSP,timeLimit);


fprintf('Random algorithm (all possible paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestObjective, noCycles, avObjective, bestLoadTime);

%%

%timeLimit = 10;
[bestSol,bestObjective,noCycles,avObjective, bestLoadTime] = greedyRandomAlgorithm(nNodes,Links,T,sP,nSP,timeLimit);


fprintf('Random algorithm (all possible paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestObjective, noCycles, avObjective, bestLoadTime);

