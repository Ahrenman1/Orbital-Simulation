function orbit = orb_with_ext_time_dunc(a,e,in,w,omega,t)
%a=apoaisi
%e is eccentricity
%in is inclination
%w argument of periapsis
%omega is long of ascening node
%t is time

coords = kep(a,t,0,e);
newco = ref(coords(1),coords(2),in,w,omega);
orbit=newco;
end
