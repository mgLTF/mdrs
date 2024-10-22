% Aula 4

%% 7.b)
fprintf('7.b)\n');
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 2000;        %Bytes
N = 100;            %times to simulate
nVoip = 20;         %nr voip packets        

PLd = zeros(1, N);
PLv = zeros(1, N);
APDd = zeros(1, N);
APDv = zeros(1, N);
MPDd = zeros(1, N);
MPDv = zeros(1, N);
TT = zeros(1, N);

for it = 1:N
        [PLd(it), PLv(it), APDd(it), APDv(it), MPDd(it), MPDv(it), TT(it)] = Simulator3(rate, C, f, P, nVoip);
end

alfa = 0.1;         %90% confidence interval
media = mean(PLd);
term = norminv(1-alfa/2)*sqrt(var(PLd)/N);
fprintf('PacketLoss of data(%%)\t= %.2e +- %.2e\n', media, term);
media = mean(PLv);
term = norminv(1-alfa/2)*sqrt(var(PLv)/N);
fprintf('PacketLoss of VoIP(%%)\t= %.2e +- %.2e\n', media, term);

media = mean(APDd);
term = norminv(1-alfa/2)*sqrt(var(APDd)/N);
fprintf('Av. Packet Delay of data (ms)\t= %.2e +- %.2e\n', media, term);
media = mean(APDv);
term = norminv(1-alfa/2)*sqrt(var(APDv)/N);
fprintf('Av. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', media, term);

media = mean(MPDd);
term = norminv(1-alfa/2)*sqrt(var(MPDd)/N);
fprintf('Max. Packet Delay of data (ms)\t= %.2e +- %.2e\n', media, term);
media = mean(MPDv);
term = norminv(1-alfa/2)*sqrt(var(MPDv)/N);
fprintf('Max. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', media, term);

media = mean(TT);
term = norminv(1-alfa/2)*sqrt(var(TT)/N);
fprintf('Throughput (Mbps)\t= %.2e +- %.2e\n', media, term);

%% 7.e)
fprintf('7.e)\n');
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 2000;        %Bytes
N = 100;            %times to simulate
nVoip = 20;         %nr voip packets        

PLd = zeros(1, N);
PLv = zeros(1, N);
APDd = zeros(1, N);
APDv = zeros(1, N);
MPDd = zeros(1, N);
MPDv = zeros(1, N);
TT = zeros(1, N);

for it = 1:N
        [PLd(it), PLv(it), APDd(it), APDv(it), MPDd(it), MPDv(it), TT(it)] = Simulator4(rate, C, f, P, nVoip);
end

alfa = 0.1;         %90% confidence interval
media = mean(PLd);
term = norminv(1-alfa/2)*sqrt(var(PLd)/N);
fprintf('PacketLoss of data(%%)\t= %.2e +- %.2e\n', media, term);
media = mean(PLv);
term = norminv(1-alfa/2)*sqrt(var(PLv)/N);
fprintf('PacketLoss of VoIP(%%)\t= %.2e +- %.2e\n', media, term);

media = mean(APDd);
term = norminv(1-alfa/2)*sqrt(var(APDd)/N);
fprintf('Av. Packet Delay of data (ms)\t= %.2e +- %.2e\n', media, term);
media = mean(APDv);
term = norminv(1-alfa/2)*sqrt(var(APDv)/N);
fprintf('Av. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', media, term);

media = mean(MPDd);
term = norminv(1-alfa/2)*sqrt(var(MPDd)/N);
fprintf('Max. Packet Delay of data (ms)\t= %.2e +- %.2e\n', media, term);
media = mean(MPDv);
term = norminv(1-alfa/2)*sqrt(var(MPDv)/N);
fprintf('Max. Packet Delay of VoIP (ms)\t= %.2e +- %.2e\n', media, term);

media = mean(TT);
term = norminv(1-alfa/2)*sqrt(var(TT)/N);
fprintf('Throughput (Mbps)\t= %.2e +- %.2e\n', media, term);
