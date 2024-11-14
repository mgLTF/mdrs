
nVoip = [10 20 30 40];

lambda_data = 1500; %pps
lambda_voip = 50; % time between packet arrivals is uniformly distributed
                 % between 16 milliseconds and 24 milliseconds

avg_size_data = 620; % bytes
avg_size_voip = 120; % bytes

throughput_per_voip_flow = avg_size_voip*8 * lambda_voip; %bits per second

throughput_voip = zeros(1, length(nVoip));

throughput_voip(1) = throughput_per_voip_flow * 10 / 1e6; % 10 voip flows
throughput_voip(2) = throughput_per_voip_flow * 20 / 1e6; % 20 voip flows
throughput_voip(3) = throughput_per_voip_flow * 30 / 1e6; % 30 voip flows
throughput_voip(4) = throughput_per_voip_flow * 40 / 1e6; % 40 voip flows

throughput_data =  avg_size_data * 8 * lambda_data / 1e6; %bits per second

ber = 1e-5;
P_no_error_data = (1-ber)^(avg_size_data*8);
P_no_error_voip = (1-ber)^(avg_size_voip*8);


tt = zeros(1, length(nVoip));

tt(1) = throughput_voip(1) * P_no_error_voip + throughput_data * P_no_error_data;
tt(2) = throughput_voip(2) * P_no_error_voip + throughput_data * P_no_error_data;
tt(3) = throughput_voip(3) * P_no_error_voip + throughput_data * P_no_error_data;
tt(4) = throughput_voip(4) * P_no_error_voip + throughput_data * P_no_error_data;

ftt = figure;

hold on;
 
bar(nVoip, tt');
title('Total throughput')
xlabel('Number of VoIP Flows');
xticks(10:10:40);
ylabel('Throughput (Mbps)');
ylim([0 10]);
grid on;


set(ftt, 'Position', [100, 100, figureWidth, figureHeight]);
saveas(ftt, fullfile('figures', 'ftt.png'));


hold off;