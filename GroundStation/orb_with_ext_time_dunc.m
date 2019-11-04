function orbit = orb_with_ext_time_dunc(a,e,in,w,omega,t)
%This code is changed to work for the ground station coverage files.

%a=apoaisi
%e is eccentricity
%in is inclination
%w argument of periapsis
%omega is long of ascening node
%t is time

%setting initial date
t0=datenum(2019,1,1);

%fining the change in time in days
t=datenum(t)-t0;

%converting days to seconds
t=t*24*60*60;

coords = kep(a,t,0,e);
newco = ref(coords(1),coords(2),in,w,omega);
orbit=newco;
end
