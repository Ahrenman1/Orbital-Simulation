function orbit = orb(a,e,in,w,omega,col)
scatter3(0,0,0,1000,'k','filled')
hold on

for i = 0:60:3*60*60
    coords = kep(a,i,0,e);
    newco = ref(coords(1),coords(2),in,w,omega);
    scatter3(newco(1),newco(2),newco(3),col,'filled')
    hold on
end
orbit=newco;
end
