function dcm_op = calc_dcm_op(boost, Bat, pv)

    arguments
        boost struct
        Bat struct
        pv struct
    end

    unpackStruct(boost);
    unpackStruct(Bat);

    Upv0 = pv.Umpp;
    Ipv0 = pv.Impp;
    Uoc0 = Ubat_nom;
    IL0 = Ipv0;
    Ubat0 = (Rt*(Uoc0 + ((- 4*RL*IL0^2*Ru^2 - 4*RL*Rt*IL0^2*Ru + 4*Upv0*IL0*Ru^2 + 4*Rt*Upv0*IL0*Ru + Rt*Uoc0^2)/Rt)^(1/2)))/(2*(Rt + Ru));
    D0 = sqrt((2*IL0*L*(Ubat0-Upv0))/(Upv0*Ubat0*T));
    E0 = Ebat_min + (Ubat0 - Ubat_cut_off)*1/nagib;

    dcm_op.Upv0 = Upv0;
    dcm_op.Ipv0 = Ipv0;
    dcm_op.IL0 = IL0;
    dcm_op.Ubat0 = Ubat0;
    dcm_op.D0 = D0;
    dcm_op.E0 = E0;
end