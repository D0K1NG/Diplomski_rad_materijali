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
    Tu = Cu*Upv0/Ipv0;
    Ku = -Upv0/Ipv0;

    Tp1 = Tn;
    Tp2 = Tu;
    K = K1+ro*Ku*K2;
    Tz = (K1*Tu)/(K);

    sys_tf_ccm = tf([K*Tz, K], [Tp1*Tp2, (Tp1+Tp2), 1]);

    sys_dcm.Tp1 = Tp1;
    sys_dcm.Tp2 = Tp2;
    sys_dcm.K = K;
    sys_dcm.Tz = Tz;
end