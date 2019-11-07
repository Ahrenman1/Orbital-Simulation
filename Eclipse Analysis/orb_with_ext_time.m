function orbit = orb_with_ext_time(a,e,in,w,omega,t)


coords = kep(a,t,0,e);
newco = ref(coords(1),coords(2),in,w,omega);
orbit=newco;
end
