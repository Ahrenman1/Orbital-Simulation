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

function K = calc_K(Is)
load('dV_vals.mat');
g0 = 9.81;
K_1 = exp(max(dV_esc)./(Is(1).*g0)); %LEO -> MUN
K_2 = exp(max(dV_inj)./(Is(2).*g0)); %MUN  CAPTURE
K_3 = exp(max(dV_inc)./(Is(3).*g0)); %CHANGE INC
K_4 = exp(max(dV_spr)./(Is(4).*g0)); %SEPERATE ON ORB
K = [K_1, K_2, K_3, K_4];
end

