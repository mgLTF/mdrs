
%% 5.a)
fprintf('5.a)\n');
rate = 1800;        %pps
P = 10000;          %stoping criteria
C = 10;             %10Mbps
f = 2000;           %Bytes
N = 100;             %times to simulate

PL = zeros(1, N);
APD = zeros(1, N);
MPD = zeros(1, N);
TT = zeros(1, N);
for it = 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(rate, C, f, P);
end

alfa= 0.1;
term = @(x) norminv(1-alfa/2)*sqrt(var(x)/N);

%lambda = 1800 pps, C = 10 Mbps and f = 1.000.000 Bytes
fprintf("Packet Loss (%%) = %.2e +- %.2e\n", mean(PL), term(PL));

fprintf("Av. Packet Delay (ms) = %.2e +- %.2e\n", mean(APD), term(APD));

fprintf("Max. Packet Delay (ms) = %.2e +- %.2e\n", mean(MPD), term(MPD));

fprintf("Throughput (Mbps) = %.2e +- %.2e\n", mean(TT), term(TT));

%% 5.e)
fprintf('\n5.e)\n');
f = 1000000;            %Bytes
rate = 1800;            %pps
capacity = 10*10^6;
x = 64:1518;

S = (x .* 8) ./ (capacity)
S2 = (x .* 8) ./ (capacity);

for i = 1:length(x)
    if i == 1
        S(i) = S(i) * 0.19;
        S2(i) = S2(i)^2 * 0.19;
    elseif i == 110-64+1
        S(i) = S(i) * 0.23;
        S2(i) = S2(i)^2 * 0.23;
    elseif i == 1518-64+1
        S(i) = S(i) * 0.17;
        S2(i) = S2(i)^2 * 0.17;
    else
        S(i) = S(i) * prob_left;
        S2(i) = S2(i)^2 * prob_left;
    end
end

ES = sum(S);
ES2 = sum(S2);

throughput =  rate * avg_bytes * 8 / 10^6;
wsystem = rate * ES2 / (2*(1 - rate * ES)) + ES;
loss = ( (avg_bytes * (8 / 10^6)) / ((f * (8 / 10^6)) + capacity) ) * 100;

fprintf("Packet Loss (%%)\t= %.4f\n", loss);
fprintf("Av. Packet Delay(ms)\t= %.4f\n", wsystem * 1000);
fprintf("Throughput (Mbps)\t= %.4f \n\n", throughput);

