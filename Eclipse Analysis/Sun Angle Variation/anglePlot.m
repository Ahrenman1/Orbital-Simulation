load('Constellation_Angle_Variation_1Year.mat')

timelistDays = a_timelist/(24);

for j = 1:1:6
    subplot(6,1,j);
    axis([0,365,-180,180]);
    title(['Satellite-Sun Angle Variation - Orbit Plane ',num2str(j)]);
    xlabel('Days since 1 January 2029');
    ylabel('\Deltaangle (\circ)');
    yticks([-120:60:180].')
    for k = 1:1:4
        hold on
        plot(timelistDays,squeeze(a(j,k,:)-a(j,k,1)));
    end
end

%{
for i = 1:6
    anglesDelta(i,:) = angles(i,:) - angles(i,1);
    plot([1:365],anglesDelta);
end
title('Variation of Angle between Sun-Moon Vector and Normal Vector of Orbit Planes');
legend( 'i=0\circ, \Omega=0\circ',...
        'i=90\circ, \Omega=0\circ',...
        'i=55\circ, \Omega=60\circ',...
        'i=125\circ, \Omega=120\circ',...
        'i=55\circ, \Omega=240\circ',...
        'i=125\circ, \Omega=300\circ')
xlabel('Days since 1 January 2029');
ylabel('Variation from initial angle (\circ)');
axis([0,365,-120,180]);
yticks([-120:15:180].')
%}