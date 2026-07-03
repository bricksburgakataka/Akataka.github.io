n = -2:5;
x1= (n==0);
x2= (n==1);
x3=x1+2*x2;

w1 = x1_pad(3:8) - x1_pad(2:7) - x1_pad(1:6);
w2 = x2_pad(3:8) - x2_pad(2:7) - x2_pad(1:6);
w3 = x3_pad(3:8) - x3_pad(2:7) - x3_pad(1:6);
w12 = w1 + 2*w2;

% 绘图
figure('Name','系统1响应');
subplot(2,2,1);stem(n,w1);title('w1: 响应x1[n]=δ[n]');xlabel('n');ylabel('w1[n]');
subplot(2,2,2);stem(n,w2);title('w2: 响应x2[n]=δ[n-1]');xlabel('n');ylabel('w2[n]');
subplot(2,2,3);stem(n,w3);title('w3: 响应x3[n]=x1+2x2');xlabel('n');ylabel('w3[n]');
subplot(2,2,4);stem(n,w12);title('w1+2w2');xlabel('n');ylabel('w1+2w2');
grid on;
