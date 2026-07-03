function y = filt2d(b,a,d,x)
%d = n/2;n is the order of the 1D filter
%a b is the coefficients of the 1Dfilter
 %size fo x y z is N*N
 [m,n] = size(x);

 for i = 1:1:n
     z(:,i) = filter(b,a,[x(:,i);zeros(d,1)]);
 end
 z = z(d+1:end,:);
 for j = 1:1:m
     y(j,:) = filter(b,a,[z(j,:) zeros(1,d)]);
 end
 y = y(:,d+1:end);
     
end

 