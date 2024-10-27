
%% 7.d

fprintf("7.d)\n")

P = 10000;
alfa= 0.1;
pps = 1800;
C = 10;
f = 2000;
nVoip = 20;
N = 100;


PLd = zeros(1, N);
PLv = zeros(1, N);
APDd = zeros(1, N);
APDv = zeros(1, N);
MPDd = zeros(1, N);
MPDv = zeros(1, N);
TT = zeros(1, N);

for it = 1:N
        [PLd(it), PLv(it), APDd(it), APDv(it), MPDd(it), MPDv(it), TT(it)] = Sim3(pps, C, f, P, nVoip);
end


term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);


fprintf('PacketLoss of data(%%)\t= %.2e +- %.2e\n', mean(PLd), term(PLd));

fprintf('PacketLoss of VoIP(%%)\t= %.2e +- %.2e\n', mean(PLv), term(PLv));

fprintf('Av. Packet Delay of data (ms)\t= %.2e +- %.2e\n', mean(APDd), term(APDd));

fprintf('Av. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', mean(APDv), term(APDv));

fprintf('Max. Packet Delay of data (ms)\t= %.2e +- %.2e\n', mean(MPDd), term(MPDd));

fprintf('Max. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', mean(MPDv), term(MPDv));

fprintf('Throughput (Mbps)\t= %.2e +- %.2e\n', mean(TT), term(TT));


