function [dcm_sys, dcm_separate_tfs] = dcm_calc_tfs(boost, op)
% boost     -> boost converter system parameters
% op        -> steaday state operating point parameters

    arguments
        boost struct
        op struct
    end

    unpackStruct(boost);
    unpackStruct(op);

    % ID1:
    k1 = L/T*(Upv0^2*Ir0)/((Ubat0-Upv0)*(Upv0+m0*L)^2);
    k2 = (L*Upv0*Ir0^2)/(2*T)*(Upv0^2+m0*L*(2*Ubat0-Upv0))/(((Ubat0-Upv0)^2)*((Upv0+m0*L)^3));
    k3 = -L/(2*T)*(Ir0^2*Upv0^2)/(((Ubat0-Upv0)^2)*((Upv0+m0*L)^2));
    
    % FULL System:
    k4 = Cbat*Ci*Rt*Ru;
    k5 = Cbat*Ru+Ci*Rt+Cbat*Rt-Cbat*Rt*Ru*k3;
    k6 = 1-Rt*k3;
    % Ir dio:
    k7 = Cbat*Rt*Ru*k1;
    k8 = Rt*k1;
    % Upv dio:
    k9 = Cbat*Rt*Ru*k2;
    k10 = Rt*k2;
    
    % Reduced system (Cbat -> inf):
    k11 = Ci*Rt*Ru;
    k12 = Ru+Rt-Rt*Ru*k3;
    % Ir dio:
    k13 = Rt*Ru*k1;
    % Upv dio:
    k14 = Rt*Ru*k2;

    K1 = k13/k12;
    K2 = k14/k12;
    Tn = k11/k12;
    
    % Full:
    G_Ubat_Ir_full = tf([k7, k8], [k4, k5, k6]);
    G_Ubat_Upv_full = tf([k9, k10], [k4, k5, k6]);
    % Reduced:
    G_Ubat_Ir = tf(K1, [Tn, 1]);
    G_Ubat_Upv = tf(K2, [Tn, 1]);

    % input capacitor tf:
    G_Upv_IL = tf(-1, [Cu, Ipv0/Upv0]);

    dcm_separate_tfs.G_Ubat_Ir_full = G_Ubat_Ir_full;
    dcm_separate_tfs.G_Ubat_Upv_full = G_Ubat_Upv_full;

    dcm_separate_tfs.G_Ubat_Ir = G_Ubat_Ir;
    dcm_separate_tfs.G_Ubat_Upv = G_Ubat_Upv;

    dcm_separate_tfs.G_Upv_IL = G_Upv_IL;

    dcm_sys.G_PT1 = G_Ubat_Ir + ro*G_Upv_IL*G_Ubat_Upv;
    dcm_sys.K1 = K1;
    dcm_sys.K2 = K2;
    dcm_sys.Tn = Tn;
end