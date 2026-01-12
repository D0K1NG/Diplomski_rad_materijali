function [sys_tf_ccm, sys_dcm] = sys_dcm(dcm_sys, dcm_op, boost)

    arguments
        dcm_sys struct
        dcm_op struct
        boost struct
    end

    unpackStruct(dcm_sys);
    unpackStruct(dcm_op);
    unpackStruct(boost);

    % Input transfer function:
    % Tu = Cu*Upv0/Ipv0;
    % Ku = -Upv0/Ipv0;
    Tu = -Cu/G_incr_pv;
    Ku = 1/G_incr_pv;

    % Measurement low pass filter:
    Gmf = tf(1, [Tmfc, 1]);

    Tp1 = T;
    K = K1+ro*Ku*K2;
    Tz = (K1*Tu)/(K);

    Gp = tf([K*Tz, K], [Tp1*Tu, (Tp1+Tu), 1]);
    sys_tf_ccm = Gp * Gmf;
    % sys_tf_ccm = Gp;

    sys_dcm.Tp1 = Tp1;
    sys_dcm.Tp2 = Tu;
    sys_dcm.Tp3 = Tmfc;
    sys_dcm.K = K;
    sys_dcm.Tz = Tz;
end