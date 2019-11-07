
sa =    [6.609e6    6.609e6     6.609e6     6.609e6     6.609e6     6.609e6 ];
ecc =   [0          0           0           0           0           0       ];
inc =   [0          90          55          125         55          125     ];
peri =  [0          0           0           0           0           0       ];
loAN =  [0          0           60          120         240         300     ];

numOrbPlanes = 6;
Tmax = 365;
angles=zeros(numOrbPlanes,Tmax);

for i = 1:numOrbPlanes
    disp(i);
    angles(i,:) = sunAngleVariationSats(sa(i),ecc(i),inc(i),peri(i),loAN(i));
    anglesDelta(i,:) = angles(i,:) - angles(i,1);
end

plot([1:days],anglesDelta);
title('Variation of Angle between Sun-Moon Vector and Normal of Orbit Planes');
legend( 'i=%s\circ, \Omega=%s\circ',inc(1),loAN(1),...
        'i=90\circ, \Omega=0\circ',...
        'i=55\circ, \Omega=60\circ',...
        'i=125\circ, \Omega=120\circ',...
        'i=55\circ, \Omega=240\circ',...
        'i=125\circ, \Omega=300\circ')
xlabel('Days since 1 January 2029');
ylabel('Variation from initial angle');

