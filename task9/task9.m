clear all
close all
clc

load('InputData2.mat');
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

T

k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k)
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end


%%%%%
t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLoadTime = toc(t);
    end
    contador= contador+1;
    somador= somador+load;
end

fprintf('Random algorithm (6 paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);


%%%%%%%%%%
t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    [sol, load] = GreedyRandom(nFlows, nNodes, Links, T, sP, nSP);

    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLoadTime = toc(t);
    end
    contador= contador + 1;
    somador= somador + load;
end


fprintf('Greedy randomized (6 paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);


%%%%%
t= tic;
timeLimit= 5;
bestLoad= inf;
contador= 0;
somador= 0;
while toc(t) < timeLimit
    % randomized start
    sol = zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    
    Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);
    load = max(max(Loads(:, 3:4)));

    sol = HillClimbing(sol, nNodes, Links, T, sP, nSP, nFlows);

    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLoadTime = toc(t);
    end
    contador= contador + 1;
    somador= somador + load;
end

fprintf('Multi start hill climbing with random (6 paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

%%%%%
timeLimit = 5;
bestLoad=inf;
contador=0;
somador=0;
t=tic;
while toc(t) < timeLimit
    [sol, discard] = GreedyRandom(nFlows, nNodes, Links, T, sP, nSP);
    sol = HillClimbing(sol, nNodes, Links, T, sP, nSP, nFlows);
    Loads= calculateLinkLoads(nNodes, Links, T, sP, sol);
    load = max(max(Loads(:,3:4)));
    
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
        bestLoadTime = toc(t);
    end
    
    contador= contador + 1;
    somador= somador + load;
end

fprintf('Multi start hill climbing with greedy randomized (6 paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

%{
function sol=GreedyRandom()
    sol=zeros(1, nFlows);
    for f=randperm(nFlows)
        sol(f)=1;
        bestLoads=calculateLinkLoads(nNodes, Links, T, sP, sol);
        bestload= max(max(bestLoads(:,3:4)));
        ibest=1;
        for i=2:nSP(f)
            sol(f)=i;
        end
    end
end
%}
function sol= HillClimbing(sol, nNodes, Links, T, sP, nSP, nFlows)
    Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);
    load= max(max(Loads(:,3:4)));
    improved = true;
    while improved
        bestViz= inf;
        for f=1:nFlows
            for p= 1:nSP(f)
                if sol(f)~=p
                    auxsol=sol;
                    auxsol(f)=p;
                    auxLoads= calculateLinkLoads(nNodes, Links, T, sP, auxsol);
                    auxLoad= max(max(auxLoads(:,3:4)));
                    if auxLoad < bestViz
                        bestViz = auxLoad;
                        fbest = f;
                        pbest = p;
                    end
                end
            end
        end
        
        if bestViz < Loads
            load= bestViz;
            sol(fbest)=pbest;
        else
            improved=false;
        end

    end
end