function [ccm_sys, ccm_separate_tfs] = ccm_calc_tfs_no_ramp(boost, op)
% boost     -> boost converter system parameters
% op        -> steaday state operating point parameters

    arguments
        boost struct
        op struct
    end

    unpackStruct(boost);
    unpackStruct(op);

    % Im:
    k4 = 1/T*Ubat0/Upv0;
    k5 = -1/T*Ubat0/Upv0;
    k6 = 1/L-1/T*Ubat0/(Upv0^2)*(Ir0-Im0);
    k7 = (Ir0-Im0)/(T*Upv0)-1/L;
    % ID1:
    k8 = Ubat0/Upv0-(L*Ir0)/(T*Upv0)*(1+Ubat0/Upv0)+(L*Ubat0)/(T*Upv0^2)*Im0;
    k9 = 1-Ubat0/Upv0+(L*Im0)/(T*Upv0)*(1-Ubat0/Upv0)+(L*Ubat0)/(T*Upv0^2)*Ir0;
    k10 = (T)/(2*L)-((Ubat0)/(Upv0^2))*(Ir0-Im0)+(L)/(2*T)*(Ir0^2-Im0^2)/(Upv0^2)+(L*Ubat0)/(T*Upv0^3)*((Ir0-Im0)^2);
    k11 = -(T)/(2*L)+(Ir0-Im0)/Upv0-(L)/(2*T)*((Ir0-Im0)^2)/(Upv0^2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cbat -> inf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ubat:
    k12 = Ci*Rt*Ru;
    k13 = Ru+Rt-Rt*Ru*k11-Ci*Rt*Ru*k5;
    k14 = Rt*Ru*k5*k11-Rt*Ru*k7*k9-Rt*k5-Ru*k5;
    % Ir:
    k15 = Rt*Ru*k8;
    k16 = Rt*Ru*k4*k9-Rt*Ru*k5*k8;
    % Upv:  
    k17 = Rt*Ru*k10;
    k18 = Rt*Ru*k6*k9-Rt*Ru*k5*k10;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cbat -> inf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  with Cbat  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ubat:
    k90 = -Cbat*Ci*Rt*Ru;
    k91 = Cbat*Rt*Ru*k11-Cbat*Ru-Ci*Rt-Cbat*Rt+Cbat*Ci*Rt*Ru*k5;
    k92 = Rt*k11+Cbat*Rt*k5+Cbat*Ru*k5+Ci*Rt*k5-Cbat*Rt*Ru*k5*k11+Cbat*Rt*Ru*k7*k9-1;
    k93 = k5-Rt*k5*k11+Rt*k7*k9;
    % Ir:
    k94 = -Cbat*Rt*Ru*k8;
    k95 = Cbat*Rt*Ru*k5*k8-Cbat*Rt*Ru*k4*k9-Rt*k8;
    k96 = Rt*k5*k8-Rt*k4*k9;
    %Upv:
    k97 = -Cbat*Rt*Ru*k10;
    k98 = Cbat*Rt*Ru*k5*k10-Rt*k10-Cbat*Rt*Ru*k6*k9;
    k99 = Rt*k5*k10-Rt*k6*k9;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  with Cbat  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % system characteristics:
    Tn = sqrt(k12/k14);
    zeta = 1/2*k13/(sqrt(k14*k12));
    Tz1 = -k15/k16;
    Tz2 = k17/k18;
    K1 = k16/k14;
    K2 = k18/k14;
    Tp1 = Tn/(zeta-sqrt(zeta^2-1));
    Tp2 = Tn/(zeta+sqrt(zeta^2-1));

    % system tf with finite Cbat:
    G_Ubat_Ir_full = tf([k94, k95, k96], [k90, k91, k92, k93]);
    G_Ubat_Upv_full = tf([k97, k98, k99], [k90, k91, k92, k93]);

    % system tf's with infinite Cbat:
    % 2. order:
    G_Ubat_Ir = tf([-Tz1*K1, K1], [(Tp1*Tp2), (Tp1+Tp2), 1]);
    G_Ubat_Upv = tf([Tz2*K2, K2], [(Tp1*Tp2), (Tp1+Tp2), 1]);
    % without a zero:
    G_Ubat_Ir_nozero = tf(K1, [(Tp1*Tp2), (Tp1+Tp2), 1]);
    G_Ubat_Upv_nozero = tf(K2, [(Tp1*Tp2), (Tp1+Tp2), 1]);
    % 1. order without a zero:
    G_Ubat_Ir_red = tf(K1, [Tp1, 1]);
    G_Ubat_Upv_red = tf(K2, [Tp1, 1]);

    % input capacitor tf:
    G_Upv_IL = tf(-1, [Cu, Ipv0/Upv0]);

    ccm_separate_tfs.G_Ubat_Ir_full = G_Ubat_Ir_full;
    ccm_separate_tfs.G_Ubat_Ir = G_Ubat_Ir;
    ccm_separate_tfs.G_Ubat_Ir_nozero = G_Ubat_Ir_nozero;
    ccm_separate_tfs.G_Ubat_Ir_red = G_Ubat_Ir_red;

    ccm_separate_tfs.G_Ubat_Upv_full = G_Ubat_Upv_full;
    ccm_separate_tfs.G_Ubat_Upv = G_Ubat_Upv;
    ccm_separate_tfs.G_Ubat_Upv_nozero = G_Ubat_Upv_nozero;
    ccm_separate_tfs.G_Ubat_Upv_red = G_Ubat_Upv_red;

    ccm_sys.G_PT1 = G_Ubat_Ir_red + ro*G_Upv_IL*G_Ubat_Upv_red;

    ccm_sys.Tn = Tn;
    ccm_sys.zeta = zeta;
    ccm_sys.Tz1 = Tz1;
    ccm_sys.Tz2 = Tz2;
    ccm_sys.K1 = K1;
    ccm_sys.K2 = K2;
    ccm_sys.Tp1 = Tp1;
    ccm_sys.Tp2 = Tp2;
end