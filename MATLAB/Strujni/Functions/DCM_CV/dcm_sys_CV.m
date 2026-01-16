function [sys_tf, sys_constants] = dcm_sys_CV(dcm_cv_constants, dcm_op_cv, boost)
% Calculates final system transfer functions

    arguments
        dcm_cv_constants struct
        dcm_op_cv struct
        boost struct
    end

    unpackStruct(dcm_cv_constants);
    unpackStruct(dcm_op_cv);
    unpackStruct(boost);

    % Input tf:
    Tu = -Cu/G_incr_pv;
    Ku = 1/G_incr_pv;

    % Measurement low pass filter:
    Gmf = tf(1, [Tmfc, 1]);

    K = K1+ro*Ku*K2;
    Tz = (K1*Tu)/(K);

    Gp = tf([K*Tz, K], [Tn*Tu, (Tn+Tu), 1]);
    sys_tf = Gp * Gmf;

    sys_constants.Tp1 = Tu;
    sys_constants.Tp2 = Tn;
    sys_constants.Tp3 = Tmfc;
    sys_constants.K = K;
    sys_constants.Tz = Tz;
end