

%% 6.a)
fprintf('6.a)\n');
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 1000000;           %Bytes
N = 100;             %times to simulate
b = 1e-6;


PL = zeros(1, N);
APD = zeros(1, N);
MPD = zeros(1, N);
TT = zeros(1, N);
for it = 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Sim2(rate, C, f, P, b);
end

alfa= 0.1;
term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);

%lambda = 1800 pps, C = 10 Mbps and f = 1.000.000 Bytes
fprintf("Packet Loss (%%) = %.2e +- %.2e\n", mean(PL), term(PL));

fprintf("Av. Packet Delay (ms) = %.2e +- %.2e\n", mean(APD), term(APD));

fprintf("Max. Packet Delay (ms) = %.2e +- %.2e\n", mean(MPD), term(MPD));

fprintf("Throughput (Mbps) = %.2e +- %.2e\n", mean(TT), term(TT));

%% 6.c
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 10000;          %Bytes
N = 100;            %times to simulate
b = 1e-6;

PL = zeros(1, N);
APD = zeros(1, N);
MPD = zeros(1, N);
TT = zeros(1, N);
for it = 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Sim2(rate, C, f, P, b);
end

alfa= 0.1;
term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);

%lambda = 1800 pps, C = 10 Mbps and f = 1.000.000 Bytes
fprintf("Packet Loss (%%) = %.2e +- %.2e\n", mean(PL), term(PL));

fprintf("Av. Packet Delay (ms) = %.2e +- %.2e\n", mean(APD), term(APD));

fprintf("Max. Packet Delay (ms) = %.2e +- %.2e\n", mean(MPD), term(MPD));

fprintf("Throughput (Mbps) = %.2e +- %.2e\n", mean(TT), term(TT));


%% 6.d
printf("6.d)")
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 2000;          %Bytes
N = 100;            %times to simulate
b = 1e-6;

PL = zeros(1, N);
APD = zeros(1, N);
MPD = zeros(1, N);
TT = zeros(1, N);
for it = 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Sim2(rate, C, f, P, b);
end

alfa= 0.1;
term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);

%lambda = 1800 pps, C = 10 Mbps and f = 1.000.000 Bytes
fprintf("Packet Loss (%%) = %.2e +- %.2e\n", mean(PL), term(PL));

fprintf("Av. Packet Delay (ms) = %.2e +- %.2e\n", mean(APD), term(APD));

fprintf("Max. Packet Delay (ms) = %.2e +- %.2e\n", mean(MPD), term(MPD));

fprintf("Throughput (Mbps) = %.2e +- %.2e\n", mean(TT), term(TT));
