function [sys_tf_ccm, sys_ccm] = sys_ccm(ccm_m_sys, ccm_m_op, boost)

    arguments
        ccm_m_sys struct
        ccm_m_op struct
        boost struct
    end

    unpackStruct(ccm_m_sys);
    unpackStruct(ccm_m_op);
    unpackStruct(boost);

    Tp2 = Cu*Upv0/Ipv0;
    K = K1-ro*K2*Upv0/Ipv0;
    Tz = (K1*Tp2)/(K1-ro*K2*Upv0/Ipv0);

    sys_tf_ccm = tf([K*Tz, K], [Tp1*Tp2, (Tp1+Tp2), 1]);

    sys_ccm.K = K;
    sys_ccm.Tz = Tz;
    sys_ccm.Tp1 = Tp1;
    sys_ccm.Tp2 = Tp2;
end