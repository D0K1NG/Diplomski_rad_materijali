function ccm = ccm_param(boost, Bat, pv_data)
% calculate steady state param. for CCM mode

    arguments
        boost struct
        Bat struct
        pv_data struct
    end

    unpackStruct(boost);
    unpackStruct(Bat);
    unpackStruct(pv_data);
    
    Ipv0 = Impp;
    Upv0 = Umpp;
    Ubat0 = Ubat_nom;
    Ir0 = Ipv0;
    Im0 = Ir0-(T*Upv0)/(L*Ubat0)*(Ubat0 - Upv0);
    Lmin = (T*Upv0)/(Ubat0*Ir0)*(Ubat0-Upv0);
    ro = Ubat0/Upv0+(L/T)*(Ubat0/Upv0^2)*(Im0-Ir0);

    ccm.Ipv0 = Ipv0;
    ccm.Upv0 = Upv0;
    ccm.Ubat0 = Ubat0;
    ccm.Ir0 = Ir0;
    ccm.Im0 = Im0;
    ccm.Lmin = Lmin;
    ccm.ro = ro;
end

