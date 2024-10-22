

x = linspace(0,1);
p = 0.6
n = 4
fx1 = x + (1-x)/3
fx2 = x + (1-x)/4
fx3 = x + (1-x)/5

plot(x, fx1*100, 'b--')
hold on
plot(x, fx2*100, 'k--')

plot(x, fx3*100, 'k--')
grid on
ylim([0 100])






% fx= x.^2;
% gx = 1 -  x.^4;
% 
% plot(x, fx, 'b--');
% hold on
% plot(x, gx, 'k--');
% hold off
% 
% grid on
% ylim([0 1.1])