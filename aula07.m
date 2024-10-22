
%% 7.d

fprintf("7.d)")

P = 10000;
alfa= 0.1;
pps = 1800;
C = 10;
f = 10000;
nVoip = 20;

PLd = zeros(1, N);
PLv = zeros(1, N);
APD = zeros(1, N);
%APDv = zeros(1, N);
MPD = zeros(1, N);
%MPDv = zeros(1, N);
TT = zeros(1, N);

for it = 1:N
        [PLd(it), PLv(it), APD(it), MPD(it), TT(it)] = Sim3(rate, C, f, P, nVoip);
end


term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);


fprintf('PacketLoss of data(%%)\t= %.2e +- %.2e\n', mean(PLd), term(PLd));

fprintf('PacketLoss of VoIP(%%)\t= %.2e +- %.2e\n', mean(PLv), term(PLv));


