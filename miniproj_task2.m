%% mini-proj1


%% 7.d

fprintf("7.d)\n")

P = 100000;
alfa= 0.1;
pps = 1500;
C = 10;
f = 1000000;
nVoip = [10 20 30 40];
N = 20;
b = 1e-5;

PLd_results = zeros(1, length(nVoip));
PLd_terms = zeros(1, length(nVoip));
PLv_results = zeros(1, length(nVoip));
PLv_terms = zeros(1, length(nVoip));

APDd_results = zeros(1, length(nVoip));
APDd_terms = zeros(1, length(nVoip));
APDv_results = zeros(1, length(nVoip));
APDv_terms = zeros(1, length(nVoip));

MPDd_results = zeros(1, length(nVoip));
MPDd_terms = zeros(1, length(nVoip));
MPDv_results = zeros(1, length(nVoip));
MPDv_terms = zeros(1, length(nVoip));

TT_results = zeros(1, length(nVoip));
TT_terms = zeros(1, length(nVoip));

PLd = zeros(1, N);
PLv = zeros(1, N);
APDd = zeros(1, N);
APDv = zeros(1, N);
MPDd = zeros(1, N);
MPDv = zeros(1, N);
TT = zeros(1, N);

term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);

for i = 1:length(nVoip)
    for it = 1:N
            [PLd(it), PLv(it), APDd(it), APDv(it), MPDd(it), MPDv(it), TT(it)] = Sim3A(pps, C, f, P, nVoip(i), b);
    end

    PLd_results(i) = mean(PLd);
    PLd_terms(i) = term(PLd);
    PLv_results(i) = mean(PLv);
    PLv_terms(i) = term(PLv);
    %
    APDd_results(i) = mean(APDd);
    APDd_terms(i) = term(APDd);
    APDv_results(i) = mean(APDv);
    APDv_terms(i) = term(APDv);
    %
    MPDd_results(i) = mean(MPDd);
    MPDd_terms(i) = term(MPDd);
    MPDv_results(i) = mean(MPDv);
    MPDv_terms(i) = term(MPDv);
    %
    TT_results(i) = mean(TT);
    TT_terms(i) = term(TT);
    

end

%%
% fprintf('PacketLoss of data(%%)\t= %.2e +- %.2e\n', mean(PLd), term(PLd));
% 
% fprintf('PacketLoss of VoIP(%%)\t= %.2e +- %.2e\n', mean(PLv), term(PLv));
% 
% fprintf('Av. Packet Delay of data (ms)\t= %.2e +- %.2e\n', mean(APDd), term(APDd));
% 
% fprintf('Av. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', mean(APDv), term(APDv));
% 
% fprintf('Max. Packet Delay of data (ms)\t= %.2e +- %.2e\n', mean(MPDd), term(MPDd));
% 
% fprintf('Max. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', mean(MPDv), term(MPDv));
% 
 fprintf('Throughput (Mbps)\t= %.2e +- %.2e\n', mean(TT), term(TT));

%% dimensions
figureWidth = 280; % Desired width in pixels
figureHeight = 420; % Desired height in pixels
 
 %% b
f1a = figure(1);
%data
hold on;
grid on;

bar(nVoip, PLd_results');
title('Packet loss of Data (%)');
ylabel('Packet Loss (%)');
xlabel('Number of VoIP Flows');
xticks(10:10:40);

er = errorbar(nVoip, PLd_results', PLd_terms);
er.LineStyle = 'none';

set(f1a, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f1a, fullfile('figures', '1a.png'));


hold off;

%voip
f1b = figure(2);
hold on;
grid on;

bar(nVoip, PLv_results');
title('Packet loss of VoIP (%)');
ylabel('Packet Loss (%)');
xlabel('Number of VoIP Flows');
xticks(10:10:40);

er = errorbar(nVoip, PLv_results', PLv_terms );
er.LineStyle = 'none';

set(f1b, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f1b, fullfile('figures', '1b.png'));

hold off;



%% c

f2a = figure(3);
%data
hold on;
grid on;

bar(nVoip, APDd_results');
title('Average Packet Delay of Data');
xlabel('Number of VoIP Flows');
xticks(10:10:40);
ylabel('Packet delay (ms)');

er = errorbar(nVoip, APDd_results', APDd_terms );
er.LineStyle = 'none';

set(f2a, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f2a, fullfile('figures', '2a.png'));

hold off;

f2b = figure(4);
%voip
hold on;
grid on;

bar(nVoip, APDv_results');
title('Average Packet Delay of VoIP');
xlabel('Number of VoIP Flows');
xticks(10:10:40);
ylabel('Packet delay (ms)');
ylim([0 7]);

er = errorbar(nVoip, APDv_results', APDv_terms );
er.LineStyle = 'none';

set(f2b, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f2b, fullfile('figures', '2b.png'));

hold off;

%% d

f3a = figure(5);
%data
hold on;
grid on;

bar(nVoip, MPDd_results');
title('Maximum Packet Delay of Data (ms)');
xlabel('Number of VoIP Flows');
xticks(10:10:40);
ylabel('Packet delay (ms)');


er = errorbar(nVoip, MPDd_results', MPDd_terms );
er.LineStyle = 'none';

set(f3a, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f3a, fullfile('figures', '3a.png'));

hold off;

f3b = figure(6);
%voip
hold on;
grid on;

bar(nVoip, MPDv_results');
title('Maximum Packet Delay of VoIP (ms)');
ylabel('Packet Delay (ms)');
xlabel('Number of VoIP Flows');
xticks(10:10:40);
ylabel('Packet delay (ms)');

er = errorbar(nVoip, MPDv_results', MPDv_terms );
er.LineStyle = 'none';

set(f3b, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f3b, fullfile('figures', '3b.png'));

hold off;



%% e

f4 = figure(7);
%data
hold on;
grid on;

bar(nVoip, TT_results');
title('Total throughput')
xlabel('Number of VoIP Flows');
xticks(10:10:40);
ylabel('Throughput (Mbps)')
ylim([0 10]);

er = errorbar(nVoip, TT_results', TT_terms );
er.LineStyle = 'none';

set(f4, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(f4, fullfile('figures', '4.png'));

hold off;
