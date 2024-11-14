% Performance parameters
% data packets

% Input parameters
lambda = 1500;                             % pps   (packets/sec)
C = 10;                                     % Mbps  (link bandwidth)
f = 1e4;                                    % Queue size (Bytes)
P = 1e5;                                    % number of packets (stopping criterium)
n_VoIP = [10 20 30 40];                  % number of VoIP flows

% Performance parameters
nrun = 20;                                  % number of runs
nsim = length(n_VoIP);
PLdata_3b = zeros(nrun, nsim);
APDdata_3b = zeros(nrun, nsim);
MPDdata_3b = zeros(nrun, nsim);
TT_3b = zeros(nrun, nsim);
% VoIP packets
PLVoIP_3b = zeros(nrun, nsim);
APDVoIP_3b = zeros(nrun, nsim);
MPDVoIP_3b = zeros(nrun, nsim);

p = 90;

for i=1:nsim
    for j=1:nrun
        [PLdata_3b(j,i) , APDdata_3b(j,i) , MPDdata_3b(j,i) , TT_3b(j,i), PLVoIP_3b(j,i), APDVoIP_3b(j,i), MPDVoIP_3b(j,i)] = Sim4A(lambda, C, f, P, n_VoIP(i), p);
    end
end

%%
% data packets
PLdata_mean_3b = zeros(1, nsim);
PLdata_moe_3b = zeros(1, nsim);
APDdata_mean_3b = zeros(1, nsim);
APDdata_moe_3b = zeros(1, nsim);
MPDdata_mean_3b = zeros(1, nsim);
MPDdata_moe_3b = zeros(1, nsim);
TT_mean_3b = zeros(1, nsim);
TT_moe_3b = zeros(1, nsim);
% VoIP packets
PLVoIP_mean_3b = zeros(1, nsim);
PLVoIP_moe_3b = zeros(1, nsim);
APDVoIP_mean_3b = zeros(1, nsim);
APDVoIP_moe_3b = zeros(1, nsim);
MPDVoIP_mean_3b = zeros(1, nsim);
MPDVoIP_moe_3b = zeros(1, nsim);

alfa = 0.1;
term = @(x) norminv(1-alfa/2)*sqrt(var(x)/nrun);
for i = 1:nsim
    PLdata_mean_3b(i) = mean(PLdata_3b(:, i));
    PLdata_moe_3b(i) = term(PLdata_3b(:, i));
    APDdata_mean_3b(i) = mean(APDdata_3b(:, i));
    APDdata_moe_3b(i) = term(APDdata_3b(:, i));

    PLVoIP_mean_3b(i) = mean(PLVoIP_3b(:, i));
    PLVoIP_moe_3b(i) = term(PLVoIP_3b(:, i));
    APDVoIP_mean_3b(i) = mean(APDVoIP_3b(:, i));
    APDVoIP_moe_3b(i) = term(APDVoIP_3b(:, i));
end

%%
% Plot results with error bars
fdata_3b = figure;
tiledlayout(1, 2);
nexttile;

b = bar(n_VoIP, [PLdata_mean_3b; PLVoIP_mean_3b]);
hold on;

% Calculate the number of groups and number of bars in each group
ngroups = 2;
nbars = 4;
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:ngroups
    x(:,i) = b(i).XEndPoints;
end

er = errorbar(x', [PLdata_mean_3b; PLVoIP_mean_3b], [PLdata_moe_3b; PLVoIP_moe_3b],'k','linestyle','none');

er(1).LineStyle = 'none';
er(2).LineStyle = 'none';
title('Average Packet Loss');
xlabel('Number of VoIP flows');
ylabel('Packet Loss (%)');

grid on;

%set(fdata_3b, 'Position', [100, 100, figureWidth, figureHeight]);
%saveas(fdata_3b, fullfile('figures', 't3_d_a.png'));


hold off;

nexttile;
%f3_c_b = figure;

b = bar(n_VoIP, [APDdata_mean_3b; APDVoIP_mean_3b]);
hold on;

% Calculate the number of groups and number of bars in each group
ngroups = 2;
nbars = 4;
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:ngroups
    x(:,i) = b(i).XEndPoints;
end

er = errorbar(x', [APDdata_mean_3b; APDVoIP_mean_3b], [APDdata_moe_3b; APDVoIP_moe_3b],'k','linestyle','none');
er(1).LineStyle = 'none';
er(2).LineStyle = 'none';
title('Average Packet Delay');
xlabel('Number of VoIP flows');
ylabel('Packet Delay (ms)');
grid on;

hold off;

%set(f3_c_b, 'Position', [100, 100, figureWidth*2, figureHeight]);
%saveas(f3_c_b, fullfile('figures', 't3_d_b.png'));

lgd = legend({'Data', 'VoIP'}, ...
          'Orientation', 'horizontal');
lgd.Layout.Tile = 'south';

set(fdata_3b, 'Position', [100, 100, figureWidth*2, figureHeight]);
saveas(fdata_3b, fullfile('figures', 't3_d_a.png'));



%%

% VoIP performance plot
fVoIP_3b = figure;
subplot(1, 3, 1);
bar(n_VoIP, PLVoIP_mean_3b);
hold on;
errorbar(n_VoIP, PLVoIP_mean_3b, PLVoIP_moe_3b, '.');
title('Average Packet Loss');
xlabel('Number of VoIP flows');
ylabel('Packet Loss (%)');
hold off;

subplot(1, 3, 2);
bar(n_VoIP, APDVoIP_mean_3b);
hold on;
errorbar(n_VoIP, APDVoIP_mean_3b, APDVoIP_moe_3b, '.');
title('Average Packet Delay');
xlabel('Number of VoIP flows');
ylabel('Packet Delay (ms)');
hold off;

subplot(1, 3, 3);
bar(n_VoIP, MPDVoIP_mean_3b);
hold on;
errorbar(n_VoIP, MPDVoIP_mean_3b, MPDVoIP_moe_3b, '.');
title('Maximum Packet Delay');
xlabel('Number of VoIP flows');
ylabel('Packet Delay (ms)');
hold off;