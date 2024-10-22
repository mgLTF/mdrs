% Aula 2

%% 3.a)
pstates = zeros(1, 5);
states = [10^-6 10^-5 10^-4 10^-3 10^-2];
denominador = 1 + 8/600 + 5/100*8/600 + 2/20*5/100*8/600 + 1/5*2/20*5/100*8/600;

pstates(1) = 1 / denominador; 
pstates(2) = (8/600) / denominador;
pstates(3) = (8/600 * 5/100) / denominador;
pstates(4) = (8/600 * 5/100 * 2/20) / denominador;
pstates(5) = (8/600 * 5/100 * 2/20 * 1/5) / denominador;

fprintf('The probability of link being in state 10^-6 is: %.2e\n', pstates(1));
fprintf('The probability of link being in state 10^-5 is: %.2e\n', pstates(2));
fprintf('The probability of link being in state 10^-4 is: %.2e\n', pstates(3));
fprintf('The probability of link being in state 10^-3 is: %.2e\n', pstates(4));
fprintf('The probability of link being in state 10^-2 is: %.2e\n', pstates(5));

%% 3.b)
fprintf(['Pelas propriedades das cadeias de Markov, a probabilidade de um link estar num' ...
    'determinado estado é igual à percentagem de tempo médio que cada link fica ness estado\n']);


%% 3.c)
ber = sum(pstates .* states)


%% 3.d)

tavg = zeros(1, 5);
tavg(1) = 1 / (8);
tavg(2) = 1 / (600 + 5);
tavg(3) = 1 / (100 + 2);
tavg(4) = 1 / (20 + 1);
tavg(5) = 1 / (5);

tavg  = tavg * 60

%% 3.e)

pnormal = pstates(1) + pstates(2) + pstates(3);
pinter = pstates(4) + pstates(5);

fprintf('pnormal = %.5e\n', pnormal);
fprintf('pinterference = %.2e\n', pinter);

%% 3.f)

ber = pstates .* states
ber_normal = (ber(1) + ber(2) + ber(3))/pnormal
ber_inter = (ber(4) + ber(5))/ pinter

fprintf('ber_normal = %.5e\n', ber_normal);
fprintf('ber_interference = %.2e\n', ber_inter);

%% 3.g)


