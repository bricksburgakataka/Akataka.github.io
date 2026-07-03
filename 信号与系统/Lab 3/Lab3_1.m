b1=[1 5];
a1=[1 2 3];
zs1=roots(b1);
ps1=roots(a1);

b2=[2 5 12];
a2=[1 2 10];
zs2=roots(b2);
ps2=roots(a2);

b3=[2 5 12];
a3=conv([1 2 10],[1 2]);
zs3=roots(b3);
ps3=roots(a3);


b4=[1 2 5];
a4=[1 -3];
zs4=roots(b4);
ps4=roots(a4);



figure(1);
plot(real(zs1), imag(zs1), 'o', real(ps1), imag(ps1), 'x', 'MarkerSize', 10);
grid on; 
title('Pole-Zero Diagram'); xlabel('Real'); ylabel('Imag');
legend('Zeros', 'Poles');


figure(2);
plot(real(zs2), imag(zs2), 'o', real(ps2), imag(ps2), 'x', 'MarkerSize', 10);
grid on; 
title('Pole-Zero Diagram'); xlabel('Real'); ylabel('Imag');
legend('Zeros', 'Poles');

figure(3);
plot(real(zs3), imag(zs3), 'o', real(ps3), imag(ps3), 'x', 'MarkerSize', 10);
grid on; 
title('Pole-Zero Diagram'); xlabel('Real'); ylabel('Imag');
legend('Zeros', 'Poles');


figure(4);
plot(real(zs4), imag(zs4), 'o', real(ps4), imag(ps4), 'x', 'MarkerSize', 10);
grid on; 
title('Pole-Zero Diagram'); xlabel('Real'); ylabel('Imag');
legend('Zeros', 'Poles');
