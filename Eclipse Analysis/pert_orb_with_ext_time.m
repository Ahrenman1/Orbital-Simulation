function orbit = pert_orb_with_ext_time(a,e,in,w,omega,t)
rm = 1737100;
u = (6.67*10^-11)*(7.34767*10^22);
n = sqrt(u/a^3);
J2 = 2.039e-4;
T1 = (J2*(rm^2))/(a^2);
T2 = 1-((3/2)*((sind(in))^2));
ncorrected = n*(1+(((3/2)*T1)*T2));
incangle = cosd(in);
ascendingnode = (-3/2)*T1*ncorrected*incangle;

omega = omega + ascendingnode*t*180/pi;

coords = kep(a,t,0,e);
newco = ref(coords(1),coords(2),in,w,omega);
orbit=newco;
end
