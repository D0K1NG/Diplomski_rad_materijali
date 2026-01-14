function unpackStruct(s)
    % UNPACKSTRUCT Unpack all fields of a struct into variables in the caller workspace
    fields = fieldnames(s);
    for i = 1:numel(fields)
        assignin('caller', fields{i}, s.(fields{i}));
    end
end