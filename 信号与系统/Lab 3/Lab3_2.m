
b1 = [1, -1];      
a1 = [1, 3, 2];   

b2 = 1;
a2 = [1 1 0.5];

b3 = [1, 0.5];      
a3 = [1, -1.25, 0.75, -0.125]; 

figure(1);
dpzplot(b1, a1);
grid on;

figure(2);
dpzplot(b2, a2);
grid on;

figure(3);
dpzplot(b3, a3);
grid on;