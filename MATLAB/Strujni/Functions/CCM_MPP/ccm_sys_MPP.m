function [sys_tf, sys_constants] = ccm_sys_MPP(ccm_op_mpp, boost)
% Calculates plant transfer function

    arguments
        ccm_op_mpp struct
        boost struct
    end

    unpackStruct(ccm_op_mpp);
    unpackStruct(boost);

    % Ulazni krug:
    Tu = Cu*Upv0/Ipv0;
    Ku = -Upv0/Ipv0;

    Gu = tf(Ku, [Tu 1]);

    sys_tf = ro * Gu;

    sys_constants.Tn = Tu;
    sys_constants.K = Ku;
end

