

%% 5.a)
clc
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 1000000;        %Bytes
N = 100;             %times to simulate


PL = zeros(1, N);
APD = zeros(1, N);
MPD = zeros(1, N);
TT = zeros(1, N);
for it = 1:N
    [PL(it), APD(it), MPD(it), TT(it)] = Sim1(rate, C, f, P);
end

alfa = 0.1;

term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);


fprintf('PL = %.2e +- %.2e\n',mean(PL),term(PL));
fprintf('APD = %.2e +- %.2e\n',mean(APD),term(APD));
fprintf('MPD = %.2e +- %.2e\n',mean(MPD),term(MPD));
fprintf('TT = %.2e +- %.2e\n',mean(TT),term(TT));


%% 5c)
clc
aux = [64 110 1518];
aux_probs = [0.19 0.23 0.17];

N = 1518 - 64 + 1;
probs = zeros(N, 1) + ( (1-sum(aux_probs))/(N-3));


for it = 1:length(aux)
    probs(aux(it)-64+1) = aux_probs(it);
end

a = mean( probs.' .* [64:1518])















