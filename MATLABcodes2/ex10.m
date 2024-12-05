clear all;
close all
clc

load("InputData2.mat");
Nodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);



MTTR= 24; % mean time to repair
CC= 450; % cable cut
MTBF= (CC*365*24)./L; % mean time between failures
A= MTBF./(MTBF + MTTR); %disponibilidade
A(isnan(A))= 1;
Alog= -log(A);

% Computing up to k=6 pairs of link disjoint paths
% for all flows from 1 to nFlows:
k= 6;
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);
% sP{1,f}{i} is the 1st path of the i-th path pair of flow f
% sP{2,f}{i} is the 2nd path of the i-th path pair of flow f
% nSP(f) is the number of path pairs of flow f

averageAvailability = 0;
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end


    bestAvailability = 0;
    
    availability = 1;
    for node_idx = 1 : length(sP{1, f}{1}) - 1 %traverse path
        nodeA = sP{1, f}{1}(node_idx);
        nodeB = sP{1, f}{1}(node_idx + 1);
        
        availability = availability * A(nodeA, nodeB);
    end

      
    
    
    averageAvailability = averageAvailability + availability;
    % 10 a
    fprintf("Flow %d: Availability= %.7f - Path= %s\n", f, availability, num2str(sP{1, f}{1}));
end

% 10 b
fprintf("\nAverage availability= %.7f\n", averageAvailability/nFlows);

%% 10 c

clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

MTTR= 24;
CC= 450;
MTBF= (CC*365*24)./L;
A= MTBF./(MTBF + MTTR);
A(isnan(A))= 1;
Alog= -log(A);

% Computing up to k=6 pairs of link disjoint paths
% for all flows from 1 to nFlows:
k= 6;
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);
% sP{1,f}{i} is the 1st path of the i-th path pair of flow f
% sP{2,f}{i} is the 2nd path of the i-th path pair of flow f
% nSP(f) is the number of path pairs of flow f
av_sum = 0;
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end

    % calculate availabilty
    av = ones(1,2);
    for idx = 1 : 2
        if idx == 2 && isempty(sP{2,f}{1})
            av(idx) = 0;
            break
        end

        for node_idx = 1 : length(sP{idx, f}{1}) - 1
            nodeA = sP{idx, f}{1}(node_idx);
            nodeB = sP{idx, f}{1}(node_idx + 1);
            av(idx) = av(idx) * A(nodeA, nodeB);
        end
    end
    
    av(1) = 1 - ((1-av(1)) * (1-av(2)));
    
    av_sum = av_sum + av(1);

    fprintf('Flow %d: Availability = %.7f -\tPath1 = %s\n', f, av(1), num2str(sP{1, f}{1}));
    fprintf('\t\t\t\t\t\t\t\t\tPath2 = %s\n', num2str(sP{2, f}{1}));
end

fprintf('Average availability= %.7f\n', av_sum/nFlows);

%% 10.e)
clc

% Computing the link loads using the first path pair of each flow
% with 1+1 protection:
sol= ones(1,nFlows);
Loads= calculateLinkBand1plus1(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));
% Determine the total bandwidth required in all links:
TotalBand= sum(sum(Loads(:,3:4)));

fprintf('Worst link load = %.1f Gbps\n', maxLoad);
fprintf('Total bandwidth among all links = %.1f Gbps\n', TotalBand);

for i = 1 : length(Loads)
    fprintf('{%d - %d}:\t%.2f\t%.2f\n', Loads(i), Loads(i+length(Loads)), Loads(i+length(Loads)*2), Loads(i+length(Loads)*3))
    
end

%% 10.d)
clc

% Computing the link loads using the first path pair of each flow
% with 1+1 protection:
sol= ones(1,nFlows);
Loads= calculateLinkBand1to1(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));
% Determine the total bandwidth required in all links:
TotalBand= sum(sum(Loads(:,3:4)));

fprintf('Worst link load = %.1f Gbps\n', maxLoad);
fprintf('Total bandwidth among all links = %.1f Gbps\n', TotalBand);

for i = 1 : length(Loads)
    fprintf('{%d - %d}:\t%.2f\t%.2f\n', Loads(i), Loads(i+length(Loads)), Loads(i+length(Loads)*2), Loads(i+length(Loads)*3))
    
end



