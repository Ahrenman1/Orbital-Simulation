function Keplers = kep(a,t,tau,e)

%t is in seconds

u = (6.67*10^-11)*(7.34767*10^22);
n = sqrt(u/a^3);

T = (2*pi)/n;
M = n*(t-tau);

E = M;
delE = (e*sin(E))/(1-e*cos(E));

while delE > 0.01 || delE < -0.01
    
    E = E + delE;
    delE = (M - E + e*sin(E))/(1 - e*cos(E));
    
end

pheta = 2*(atan((sqrt((1+e)/(1-e)))*(tan(E/2))));

radius = (a*(1-e^2))/(1+e*cos(pheta));

xp = radius*cos(pheta);
yp = radius*sin(pheta);

gamma = atan((e*sin(pheta))/(1+e*cos(pheta)));

p = a*(1-e^2);

vxp = -1*(sqrt(u/p))*sin(pheta);
vyp = (sqrt(u/p))*(e+cos(pheta));

vel = sqrt(vxp^2 + vyp^2);

Keplers = [xp yp vel];

end
    