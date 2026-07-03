function a = dtfs(x,n_init)
%    x表示信号一个周期内的之
%    n_init 表示信号初始时刻
 N = length(x);
 ak = (1/N)*fft(x);
 k = 0:N-1;
 ts = exp(-j*k*2*pi/N*n_init);
 a = ak.*ts;
end
