
err = [];
for i = 1 : 0.1 : 10
    i;
    d = f*h/i;
    tmp = h*f*(1/(d*(d+1)));
    err = [err tmp*100];
end

plot(z,err)
    