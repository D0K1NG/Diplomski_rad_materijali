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
    k34 = L/T*(Upv0^2*Ir0)/((Ubat0-Upv0)*(Upv0+m0*L)^2);
    k35 = (L*Upv0*Ir0^2)/(2*T)*(Upv0^2+m0*L*(2*Ubat0-Upv0))/((Ubat0-Upv0)^2*(Upv0+m0*L)^3);
    k36 = -L/(2*T)*(Ir0^2*Upv0^2)/((Ubat0-Upv0)^2*(Upv0+m0*L)^2);
    % System:
    k37 = Ci*Rt*Ru;
    k38 = Ru+Rt-Rt*Ru*k36;
    k39 = Rt*Ru*k34;
    k40 = Rt*Ru*k35;
    
    K1 = k39/k38;
    K2 = k40/k38;
    Tn = k37/k38;
    
    G_Ubat_Ir = tf(K1, [Tn, 1]);
    G_Ubat_Upv = tf(K2, [Tn, 1]);

    % input capacitor tf:
    G_Upv_IL = tf(-1, [Cu, Ipv0/Upv0]);

    dcm_separate_tfs.G_Ubat_Ir = G_Ubat_Ir;
    dcm_separate_tfs.G_Ubat_Upv = G_Ubat_Upv;

    dcm_sys.G_PT1 = G_Ubat_Ir + ro*G_Upv_IL*G_Ubat_Upv;

    dcm_sys.K1 = K1;
    dcm_sys.K2 = K2;
    dcm_sys.Tn = Tn;
end