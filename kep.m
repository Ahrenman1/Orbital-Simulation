function Keplers = kep(a,t,tau,e)

%% defines key variables for the orbit
u = (6.67*10^-11)*(7.34767*10^22);
n = sqrt(u/a^3);
T = (2*pi)/n;

M = n*(t-tau);

%% uses the iteration method to get the value of E with little change from the last iteration
E = M;
delE = (e*sin(E))/(1-e*cos(E));

while delE > 0.01 || delE < -0.01
    
    E = E + delE;
    delE = (M - E + e*sin(E))/(1 - e*cos(E));
    
end

%% finds the angle and radius of the satellite relative to the perigree on the 2D plane
pheta = 2*(atan((sqrt((1+e)/(1-e)))*(tan(E/2))));
radius = (a*(1-e^2))/(1+e*cos(pheta));

%% finds the x and y coordinate of the satellite at time t
xp = radius*cos(pheta);
yp = radius*sin(pheta);

gamma = atan((e*sin(pheta))/(1+e*cos(pheta)));

p = a*(1-e^2);

%% finds the velocity (x,y and total) at the time t
vxp = -1*(sqrt(u/p))*sin(pheta);
vyp = (sqrt(u/p))*(e+cos(pheta));

vel = sqrt(vxp^2 + vyp^2);

%% returns the x and y components of displacement, and the velocity
Keplers = [xp yp vel];

end
    