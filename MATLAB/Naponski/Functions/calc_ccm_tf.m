function ccm_tf = calc_ccm_tf(boost, ccm_op)

    arguments
        boost struct
        ccm_op struct
    end

    unpackStruct(boost);
    unpackStruct(ccm_op);

    % Nazivnik:
    k1 = Ci*Cu*L*Rt*Ru*Upv0;
    k2 = Cu*L*Rt*Upv0 + Cu*L*Ru*Upv0 + Ci*Ipv0*L*Rt*Ru + Ci*Cu*RL*Rt*Ru*Upv0;
    k3 = Cu*Rt*Ru*Upv0*D0^2 - 2*Cu*Rt*Ru*Upv0*D0 + Ipv0*L*Rt + Ipv0*L*Ru + Cu*RL*Rt*Upv0 + Cu*RL*Ru*Upv0 + Ci*Rt*Ru*Upv0 + Cu*Rt*Ru*Upv0 + Ci*Ipv0*RL*Rt*Ru;
    k4 = Ipv0*Rt*Ru*D0^2 - 2*Ipv0*Rt*Ru*D0 + Rt*Upv0 + Ru*Upv0 + Ipv0*RL*Rt + Ipv0*RL*Ru + Ipv0*Rt*Ru;
    
    % Brojnik:
    k5 = - Cu*IL0*L*Rt*Ru*Upv0;
    k6 = Cu*Rt*Ru*Ubat0*Upv0 - IL0*Ipv0*L*Rt*Ru - Cu*D0*Rt*Ru*Ubat0*Upv0 - Cu*IL0*RL*Rt*Ru*Upv0;
    k7 = - IL0*Rt*Ru*Upv0 + Ipv0*Rt*Ru*Ubat0 - D0*Ipv0*Rt*Ru*Ubat0 - IL0*Ipv0*RL*Rt*Ru;

    G_ccm = tf([k5, k6, k7], [k1, k2, k3, k4]);

    ccm_tf = G_ccm;
end

