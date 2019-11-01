function reference = ref(xp,yp,i,w,omega)

%% defines the rotational matrix for the given orbital parameters
rotMatrix = [cosd(w)*cosd(omega)-sind(w)*cosd(i)*sind(omega) -1*sind(w)*cosd(omega)-cosd(w)*cosd(i)*sind(omega) sind(i)*sind(omega); cosd(w)*sind(omega)+sind(w)*cosd(i)*cosd(omega) -1*sind(w)*sind(omega)+cosd(w)*cosd(i)*cosd(omega) -1*sind(i)*cosd(omega); sind(w)*sind(i) cosd(w)*sind(i) cosd(i)];

%% finds the 3D point of the 2D point from the rotational matrix
globPos = rotMatrix*[xp;yp;0];

%% returns the global position
reference = globPos;
