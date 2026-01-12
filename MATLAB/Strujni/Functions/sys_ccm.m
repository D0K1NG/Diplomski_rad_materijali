function [sys_tf_ccm, sys_ccm] = sys_ccm(ccm_m_sys, ccm_m_op, boost)

    arguments
        ccm_m_sys struct
        ccm_m_op struct
        boost struct
    end

    unpackStruct(ccm_m_sys);
    unpackStruct(ccm_m_op);
    unpackStruct(boost);

    % OLD:
    % % Input transfer function:
    % Tu = Cu*Upv0/Ipv0;
    % Ku = -Upv0/Ipv0;
    % 
    % % Measurement low pass filter:
    % % Gmf = tf(1, [Tmfc, 1]);
    % 
    % K = K1+ro*Ku*K2;
    % Tz = (K1*(Tu+Tz1)+ro*Ku*K2*Tz2)/(K);
    % 
    % Gp = tf([K*Tz, K], [Tu*Tp1, (Tu+Tp1), 1]);
    % % sys_tf_ccm = Gp * Gmf;
    % sys_tf_ccm = Gp;

    % NEW:
    Tu = -Cu/G_incr_pv;
    Ku = 1/G_incr_pv;

    % Measurement low pass filter:
    Gmf = tf(1, [Tmfc, 1]);

    K = K1+ro*Ku*K2;
    Tz = (K1*Tu)/(K);

    Gp = tf([K*Tz, K], [Tu*Tp1, (Tu+Tp1), 1]);
    sys_tf_ccm = Gp * Gmf;
    % sys_tf_ccm = Gp

    sys_ccm.K = K;
    sys_ccm.Tz = Tz;
    sys_ccm.Tp1 = Tu;
    sys_ccm.Tp2 = Tp1;
    sys_ccm.Tp3 = Tmfc;
end