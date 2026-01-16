function [constants, separate_tfs] = ccm_tfs_CV(boost, ccm_op_CV)
% boost            -> boost converter system parameters
% ccm_op_CV        -> steaday state operating point parameters

    arguments
        boost struct
        ccm_op_CV struct
    end

    unpackStruct(boost);
    unpackStruct(ccm_op_CV);

    % Im:
    k1 = 1/T*(Ubat0)/(Upv0+m0*L);
    k2 = -1/T*(Ubat0)/(Upv0+m0*L);
    k3 = 1/L-1/T*(Ubat0)/((Upv0+m0*L)^2)*(Ir0-Im0);
    k4 = 1/T*(Ir0-Im0)/(Upv0+m0*L)-1/L;
    % ID1:
    k5 = 1-L/T*(2*(Ir0-Im0))/(Upv0+m0*L)+(Ubat0-Upv0-m0*L)/(Upv0+m0*L)-L/T*(Ubat0-Upv0-2*m0*L)/((Upv0+m0*L)^2)*(Ir0-Im0);
    k6 = L/T*Ir0/(Upv0+m0*L)-(Ubat0-Upv0-m0*L)/(Upv0+m0*L)+L/T*(Ubat0-Upv0-2*m0*L)/((Upv0+m0*L)^2)*(Ir0-Im0);
    k7 = T/(2*L)+(Ir0-Im0)/((Upv0+m0*L)^2)*(L/T*Ir0-Ubat0)+L/(2*T)*((Ir0-Im0)^2)*(2*Ubat0-Upv0-3*m0*L)/((Upv0+m0*L)^3);
    k8 = -T/(2*L)+(Ir0-Im0)/(Upv0+m0*L)-L/(2*T)*((Ir0-Im0)^2)/((Upv0+m0*L)^2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  with Cbat  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k9 = Cbat*Ci*Rt*Ru;
    k10 = Cbat*Ru+Ci*Rt+Cbat*Rt-Cbat*Rt*Ru*k8-Cbat*Ci*Rt*Ru*k2;
    k11 = Cbat*Rt*Ru*k2*k8-Cbat*Rt*Ru*k4*k6-Ci*Rt*k2-Cbat*Ru*k2-Cbat*Rt*k2-Rt*k8+1;
    k12 = Rt*k2*k8-Rt*k4*k6-k2;
    % Ir numerator:
    k13 = Cbat*Rt*Ru*k5;
    k14 = Cbat*Rt*Ru*k1*k6-Cbat*Rt*Ru*k2*k5+Rt*k5;
    k15 = Rt*k1*k6-Rt*k2*k5;
    % Upv numerator:
    k16 = Cbat*Rt*Ru*k7;
    k17 = Cbat*Rt*Ru*k3*k6-Cbat*Rt*Ru*k2*k7+Rt*k7;
    k18 = Rt*k3*k6-Rt*k2*k7;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  with Cbat  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cbat -> inf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k19 = Ci*Rt*Ru;
    k20 = Ru+Rt-Ci*Rt*Ru*k2-Rt*Ru*k8;
    k21 = Rt*Ru*k2*k8-Rt*Ru*k4*k6-Rt*k2-Ru*k2;
    % Ir:
    k22 = Rt*Ru*k5;
    k23 = Rt*Ru*k1*k6-Rt*Ru*k2*k5;
    % Upv:
    k24 = Rt*Ru*k7;
    k25 = Rt*Ru*k3*k6-Rt*Ru*k2*k7;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cbat -> inf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % System characteristics:
    Tn = sqrt(k19/k21);
    zeta = 1/2*(k20/(sqrt(k19*k21)));
    Tz1 = k22/k23;
    Tz2 = k24/k25;
    K1 = k23/k21;
    K2 = k25/k21;
    Tp1 = Tn/(zeta-sqrt(zeta^2-1));
    Tp2 = Tn/(zeta+sqrt(zeta^2-1));

    % system tf with finite Cbat:
    G_Ubat_Ir_full = tf([k13, k14, k15], [k9, k10, k11, k12]);
    G_Ubat_Upv_full = tf([k16, k17, k18], [k9, k10, k11, k12]);

    % system tf's with infinite Cbat:
    % 2. order:
    G_Ubat_Ir = tf([K1*Tz1, K1], [(Tp1*Tp2), (Tp1+Tp2), 1]);
    G_Ubat_Upv = tf([K2*Tz2, K2], [(Tp1*Tp2), (Tp1+Tp2), 1]);
    % 1. order with zero:
    G_Ubat_Ir_red = tf(K1, [Tp1, 1]);
    G_Ubat_Upv_red = tf(K2, [Tp1, 1]);


    separate_tfs.G_Ubat_Ir_full = G_Ubat_Ir_full;
    separate_tfs.G_Ubat_Upv_full = G_Ubat_Upv_full;

    separate_tfs.G_Ubat_Ir = G_Ubat_Ir;
    separate_tfs.G_Ubat_Upv = G_Ubat_Upv;

    separate_tfs.G_Ubat_Ir_red = G_Ubat_Ir_red;
    separate_tfs.G_Ubat_Upv_red = G_Ubat_Upv_red;

    constants.Tn = Tn;
    constants.zeta = zeta;
    constants.Tz1 = Tz1;
    constants.Tz2 = Tz2;
    constants.K1 = K1;
    constants.K2 = K2;
    constants.Tp1 = Tp1;
    constants.Tp2 = Tp2;
end