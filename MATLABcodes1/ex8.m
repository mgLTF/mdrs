


%% ex 8a

nFlows= size(T,1);
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);

k=1;
for i=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L, T(i, 1), T(i, 2), k);
    sP{i}= shortestPath;
    nSP(i)= totalCost;
    fprintf('Flow %d (%d -> %d): length = %d, Path = %s\n', i, T(i, 1), T(i, 2), totalCost, num2str(shortestPath{1}));
end


%% ex 8b
sol= ones(1,nFlows);
nNodes= size(Nodes,1);
Loads= calculateLinkLoads(nNodes,Links,T,sP,sol)

maxLoad= max(max(Loads(:,3:4)));
fprintf('Worst Link Load = %.1f\n', maxLoad);

for l = 1 : length(Loads)
    fprintf('{%d - %d}: %.2f %.2f\n', Loads(l, 1), Loads(l, 2), Loads(l, 3), Loads(l, 4));
end


%% ex 8c

[shortestPath, totalCost] = kShortestPath(L, T(1, 1), T(1, 2), 4);

for i = 1 : length(totalCost)
    fprintf('Path %d:  %s  (length= %d)\n',i , num2str(shortestPath{i}), totalCost(i));
end

%% 8d 

%load('InputData.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

% Computing up to k=inf shortest paths for all flows from 1 to nFlows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end


%Optimization algorithm based on random strategy:
timeLimit = 5;
[bestSol,bestObjective,noCycles,avObjective] = RandomAlgorithm(nNodes,Links,T,sP,nSP,timeLimit);

%Output of routing solution:
fprintf('\nRouting paths of the solution:\n')
for f= 1:nFlows
    selectedPath= bestSol(f);
    fprintf('Flow %d - Path %d:  %s\n',f,selectedPath,num2str(sP{f}{selectedPath}));
end
%Output of link loads of the routing solution:
fprintf('Worst link load of the best solution = %.2f\n',bestObjective);
fprintf('Link loads of the best solution:\n')
for i= 1:nLinks
    fprintf('{%d-%d}:\t%.2f\t%.2f\n',bestLoads(i,1),bestLoads(i,2),bestLoads(i,3),bestLoads(i,4))
end

fprintf('No. of generated solutions = %d\n',noCycles);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);

%% 8 e