function [G_full, param_out] = TO_regulator(Gp, param)
% Gp    -> process transfer function
% param -> transfer function parameters 

Ti = param.Tn;
KR = 1/param.K;

GR = tf([KR, KR/Ti], [1, 0]); 

G_full = GR * Gp;

param_out.KR = KR;
param_out.Ti = Ti;
end