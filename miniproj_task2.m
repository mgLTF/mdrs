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

%% b
figure(1);
%data
hold on;
grid on;

bar(nVoip, PLd_results');
title('Packet loss of Data (%)');


er = errorbar(nVoip, PLd_results', PLd_terms);
er.LineStyle = 'none';
hold off;

%voip
figure(2);
hold on;
grid on;

bar(nVoip, PLv_results');
title('Packet loss of VoIP (%)');

er = errorbar(nVoip, PLv_results', PLv_terms );
er.LineStyle = 'none';

hold off;

%% c

figure(3);
%data
hold on;
grid on;

bar(nVoip, APDd_results');
title('Average Packet Delay of Data (ms)');

er = errorbar(nVoip, APDd_results', APDd_terms );
er.LineStyle = 'none';
hold off;

figure(4);
%voip
hold on;
grid on;

bar(nVoip, APDv_results');
title('Average Packet Delay of VoIP (ms)');

er = errorbar(nVoip, APDv_results', APDv_terms );
er.LineStyle = 'none';

hold off;

%% d

figure(5);
%data
hold on;
grid on;

bar(nVoip, MPDd_results');
title('Maximum Packet Delay of Data (ms)');

er = errorbar(nVoip, MPDd_results', MPDd_terms );
er.LineStyle = 'none';
hold off;

figure(6);
%voip
hold on;
grid on;

bar(nVoip, MPDv_results');
title('Maximum Packet Delay of VoIP (ms)');

er = errorbar(nVoip, MPDv_results', MPDv_terms );
er.LineStyle = 'none';

hold off;



%% e

figure(7);
%data
hold on;
grid on;

bar(nVoip, TT_results');

er = errorbar(nVoip, TT_results', TT_terms );
er.LineStyle = 'none';
hold off;
