function [sys_tf, sys_constants] = ccm_sys_CV(ccm_cv_constants, ccm_op_cv, boost)
% Calculates final system transfer functions

    arguments
        ccm_cv_constants struct
        ccm_op_cv struct
        boost struct
    end

    unpackStruct(ccm_cv_constants);
    unpackStruct(ccm_op_cv);
    unpackStruct(boost);

    % Input tf:
    Tu = -Cu/G_incr_pv;
    Ku = 1/G_incr_pv;

    % Measurement low pass filter:
    Gmf = tf(1, [Tmfc, 1]);

    K = K1+ro*Ku*K2;
    Tz = (K1*Tu)/(K);

    Gp = tf([K*Tz, K], [Tu*Tp1, (Tu+Tp1), 1]);
    sys_tf = Gp * Gmf;

    sys_constants.K = K;
    sys_constants.Tz = Tz;
    sys_constants.Tp1 = Tu;
    sys_constants.Tp2 = Tp1;
    sys_constants.Tp3 = Tmfc;
end