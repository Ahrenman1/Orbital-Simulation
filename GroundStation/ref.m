function reference = ref(xp,yp,i,w,omega)

rotMatrix = [cosd(w)*cosd(omega)-sind(w)*cosd(i)*sind(omega) -1*sind(w)*cosd(omega)-cosd(w)*cosd(i)*sind(omega) sind(i)*sind(omega); cosd(w)*sind(omega)+sind(w)*cosd(i)*cosd(omega) -1*sind(w)*sind(omega)+cosd(w)*cosd(i)*cosd(omega) -1*sind(i)*cosd(omega); sind(w)*sind(i) cosd(w)*sind(i) cosd(i)];

globPos = rotMatrix*[xp;yp;0];

%globVel = rotMatrix*[vxp;vyp;0];

reference = globPos;

%disp(globVel)