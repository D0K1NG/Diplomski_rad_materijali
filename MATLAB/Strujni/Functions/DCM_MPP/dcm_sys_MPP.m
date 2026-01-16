function [sys_tf, sys_constants] = dcm_sys_MPP(dcm_op_mpp, boost)
% Calculates plant transfer function

    arguments
        dcm_op_mpp struct
        boost struct
    end

    unpackStruct(dcm_op_mpp);
    unpackStruct(boost);

    % Ulazni krug:
    Tu = Cu*Upv0/Ipv0;
    Ku = -Upv0/Ipv0;

    Gu = tf(Ku, [Tu 1]);

    sys_tf = ro * Gu;

    sys_constants.Tn = Tu;
    sys_constants.K = Ku;
end