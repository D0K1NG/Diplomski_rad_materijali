function [G_full, reg_param] = SO_regulator(Gp ,constants)

PM = 50;
a = PM/14;

% System poles:
wz = 1/constants.Tz;
wp1 = 1/constants.Tp1;
wp2 = 1/constants.Tp2;
wp3 = 1/constants.Tp3;
wc = wp3/a;
wi = wc/a;


dL1 = -20*log10(wi/wc);
dL2 = -40*log10(wp2/wi);
dL3 = -20*log10(wp1/wp2);
dL4 = -20*log10(1/wz);

Ko = 10^((dL4 + dL3 + dL2 + dL1)/20);
Ti = 1/wi;
KR = (Ko*Ti)/(constants.K);

Gr = tf([KR, KR/Ti], [1, 0]); 

G_full = Gr * Gp;

reg_param.KR = KR;
reg_param.Ti = Ti;

end

