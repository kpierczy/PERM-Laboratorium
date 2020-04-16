cascades = 1;

d = 10;
fc = 0.1;
d = 1;
k = exp(-1/d);
%k = exp(-2*pi*fc);
% a0 = (1-k)^4;
a0 = 0.8;
b1 = 0.6;
% b1 = 4*k;
% b2 = -6*k^2;
% b3 = 4*k^3;
% b4 = -k^4;

time = 100;

x = [ones(1, time)];
y = zeros(1,time);

for j=1:cascades
    for i=1:time
       if i == 1
           y(i) = a0*x(i);
%        elseif i == 2
%            y(i) = a0*x(i) + b1*y(i-1);
%        elseif i == 3
%            y(i) = a0*x(i) + b1*y(i-1) + b2*y(i-2);
%        elseif i == 4
%            y(i) = a0*x(i) + b1*y(i-1) + b2*y(i-2) + b3*y(i-3);
%        else
%            y(i) = a0*x(i) + b1*y(i-1) + b2*y(i-2) + b3*y(i-3) + b4*y(i-4);
%        end   
       else
           y(i) = a0*x(i) + b1*y(i-1);
       end
    end
    x = y;
end

plot(y)