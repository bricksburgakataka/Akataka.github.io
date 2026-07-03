%% 
n = 0:9;
k = [1, 2, 4, 6];

figure(1);
for i = 1:4
    subplot(2, 2, i);
    w = 2*pi*k(i)/5;
    x = sin(w * n);
    stem(n, x, 'filled', 'LineWidth', 1.5);
    title(['k = ', num2str(k(i)), ', \omega = ', num2str(w, '%.2f')]);
    xlabel('n');
    ylabel(['x_', num2str(k(i)), '[n]']);
    ylim([-1.2, 1.2]);  
    grid on;
end
sgtitle('Problem 1: sin(\omega_k n) for k = 1,2,4,6');