totalPos = 360;
posMoon=zeros(totalPos,3);
posMoonRot=zeros(totalPos,3);

Rm = 1.7e6;                       % Planetary radius   

rotMatrix = [1 0 0 ; 0 cosd(-23.4) -sind(-23.4) ; 0 sind(-23.4) cosd(-23.4)];

for i = 1:totalPos
    posMoon(i,:) = 1000*planetEphemeris(juliandate(2019,1,i),'Earth','Sun');
    posMoonRot(i,:) = rotMatrix*posMoon(i,:).';
    %plot3(posMoon(:,1),posMoon(:,2),posMoon(:,3));
    plot3(posMoonRot(:,1),posMoonRot(:,2),posMoonRot(:,3));
    axis equal;
    pause(0.001);
end

%plot3(posMoon(:,1),posMoon(:,2),posMoon(:,3))

%plot3(posMoonRot(:,1),posMoonRot(:,2),posMoonRot(:,3))
hold on
[sx,sy,sz]=sphere;
surf(sx*Rm,sy*Rm,sz*Rm);
hold off