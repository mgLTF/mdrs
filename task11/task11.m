%% ex11.a)
clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

T

% Computing up to k=inf shortest paths for all flows from 1 to nFlows:
k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end


timeLimit = 15;
bestEnergy=inf;
contador=0;
somador=0;
t=tic;
alfa=1;
while toc(t) < timeLimit
    [sol, load, energy] = GreedyRandom(nFlows, nNodes, Links, T, sP, nSP, L, alfa);
    fprintf("load: %d energy: %f\n", load, energy);
    sol = HillClimbing(sol, nNodes, Links, T, sP, nSP, nFlows, alfa);
    %Loads= calculateLinkLoads(nNodes, Links, T, sP, sol);
    %load = max(max(Loads(:,3:4)));
    
    energy = bestEnergy();
    if energy<bestEnergy
        bestSol= sol;
        bestEnergy= energy;
        besTime = toc(t);
    end
    
    contador= contador + 1;
    somador= somador + load;
end

fprintf('Multi start hill climbing with greedy randomized (6 paths):\n');
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);




function sol= HillClimbing(sol, nNodes, Links, T, sP, nSP, nFlows, energy, L, alfa)
    Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);
    load= max(max(Loads(:,3:4)));   
    bestEnergy=energy;


    improved = true;
    while improved
        bestViz= inf;
        for f=1:nFlows
            for p= 1:nSP(f)
                if sol(f)~=p
                    auxsol=sol;
                    auxsol(f)=p;
                    %auxLoads= calculateLinkLoads(nNodes, Links, T, sP, auxsol);
                    %auxLoad= max(max(auxLoads(:,3:4)));
                    auxEnergy=calculateEnergy(nNodes, Links, T, sP, sol, L, alfa);
                    
                    if auxEnergy < bestEnergy
                        bestEnergy = auxEnergy;
                        fbest = f;
                        pbest = p;
                    end
                end
            end
        end
        
        if bestEnergy < energy
            energy= bestEnergy;
            sol(fbest)=pbest;
        else
            improved=false;
        end

    end
end