%% Specific impulse Claculations
% Specific impulse of LOx + LH2 = 444s
% [http://www.braeunig.us/space/propel.htm]
Is = 444;
g0 = 9.81;
M_Final = 200;
%M_init = M_Final.*exp(dV_tot./(Is.*g0));

%M_1 = M_0 * K

Delta_4_Isp = [462,462,462,462];
Delta_4_K = calc_K(Delta_4_Isp);

Delta_4_M_init = 24*prod(Delta_4_K).*200;

fprintf('Delata 4 Payload To LEO Req = %6.0f Kg\n',Delta_4_M_init)


Falcon_H_M_init = 24*prod(calc_K([348,348,348,348])).*200;
fprintf('Falcon Heavy Payload To LEO Req = %6.0f Kg\n',Falcon_H_M_init)

%%% Advanced optimised Calculations
fprintf('More Advanced Calcs taking the fact not all sats need all the orbital, or satellite spreading impulses\n')';
Delta_4_M_init_adv = (  1*prod(Delta_4_K([1,2,4]))+...
                        3*prod(Delta_4_K([1,2,4,5]))+...
                        5*prod(Delta_4_K(1:4))+...
                        15*prod(Delta_4_K(1:5)))*200;

                
fprintf('Delata 4 Reduced Payload To LEO Req = %6.0f Kg\n',Delta_4_M_init_adv)
FHK = calc_K([348,348,348,348]);
Falcon_H_M_init_adv = ( 1*prod(FHK([1,2,4]))+...
                        3*prod(FHK([1,2,4,5]))+...
                        5*prod(FHK(1:4))+...
                        15*prod(FHK(1:5)))*200;
                
fprintf('Falcon Heavy Reduced Payload To LEO Req = %6.0f Kg\n',Falcon_H_M_init_adv)

fprintf('Percent Saving for Falcon Heavy = %3.0f \n',(1-(Falcon_H_M_init_adv/Falcon_H_M_init))*100)

function K = calc_K(Is)
load('dV_vals.mat');
g0 = 9.81;
K_1 = exp(dV_esc(110)./(Is(1).*g0)); %LEO -> MUN
K_2 = exp(dV_inj(110)./(Is(2).*g0)); %MUN  CAPTURE
K_3 = exp(dV_orb_spr(110)./(Is(2).*g0)); %SPREAD ORBITS
K_4 = exp(791.71./(Is(3).*g0));%dV_inc(110)./(Is(3).*g0)); %CHANGE INC
K_5 = exp(dV_sat_spr(110)./(Is(4).*g0)); %SPREAD SATTELITES
K = [K_1, K_2, K_3, K_4, K_5];
end

