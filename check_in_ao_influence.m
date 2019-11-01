function within_zone = check_in_ao_influence(Sat_pos_vect, point_vect)
%% all vectors are relative to the moon coord frame.

%% calculating radius of orbit
Sat_alt=sqrt(sum(Sat_pos_vect.^2));

%% moon Radius
R_moon=sqrt(sum(point_vect.^2));

%% calculating angle between vectors using dot product.

angle=acosd(dot(Sat_pos_vect,point_vect)/(Sat_alt*R_moon));

%% calculating the angle at centre corresponding to 
a=15;
A=R_moon;
C=Sat_alt;
c=asind(C*sind(a)/A);

if c < 90
    c= 180-c;
end

theta=180-c-a;

%% if angle lies within maximum angle, the point is seen and true is returned - else false is returned
if angle <= theta
    within_zone = true;    
else
    within_zone = false;
end

end