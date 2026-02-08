function dcm_tf = calc_dcm_tf(boost, dcm_op)

    arguments
        boost struct
        dcm_op struct
    end

    unpackStruct(boost);
    unpackStruct(dcm_op);

    % Nazivnik:
    k1 = 2*Ci*Cu*Rt*Ru*L^2*Ubat0^5*Upv0 - 8*Ci*Cu*Rt*Ru*L^2*Ubat0^4*Upv0^2 + 12*Ci*Cu*Rt*Ru*L^2*Ubat0^3*Upv0^3 - 8*Ci*Cu*Rt*Ru*L^2*Ubat0^2*Upv0^4 + 2*Ci*Cu*Rt*Ru*L^2*Ubat0*Upv0^5;
    k2 = 2*Cbat*Rt*Ru*D0^4*T^2*Ubat0^3*Upv0^4 - 2*Cu*L*Rt*D0^2*T*Ubat0^3*Upv0^4 - 2*Cbat*Ipv0*L*Rt*Ru*D0^2*T*Ubat0^3*Upv0^3 + 4*Cu*L*Rt*D0^2*T*Ubat0^2*Upv0^5 + 4*Cbat*Ipv0*L*Rt*Ru*D0^2*T*Ubat0^2*Upv0^4 - 2*Cu*L*Rt*D0^2*T*Ubat0*Upv0^6 - 2*Cbat*Ipv0*L*Rt*Ru*D0^2*T*Ubat0*Upv0^5;
    k3 = - 2*Cbat*Cu*L*Rt*Ru*T*D0^2*Ubat0^3*Upv0^4 + 4*Cbat*Cu*L*Rt*Ru*T*D0^2*Ubat0^2*Upv0^5 - 2*Cbat*Cu*L*Rt*Ru*T*D0^2*Ubat0*Upv0^6;
    
    % Brojnik:
    k4 = - 2*Cu*L*Rt*Ru*T*D0^2*Ubat0^3*Upv0^4 + 4*Cu*L*Rt*Ru*T*D0^2*Ubat0^2*Upv0^5 - 2*Cu*L*Rt*Ru*T*D0^2*Ubat0*Upv0^6;
    k5 = - 2*Rt*Ru*D0^4*T^2*Ubat0^3*Upv0^4 - 2*Ipv0*L*Rt*Ru*D0^2*T*Ubat0^3*Upv0^3 + 4*Ipv0*L*Rt*Ru*D0^2*T*Ubat0^2*Upv0^4 - 2*Ipv0*L*Rt*Ru*D0^2*T*Ubat0*Upv0^5;

    G_dcm = tf([k4, k5], [k1, k2, k3]);

    dcm_tf = G_dcm;
end