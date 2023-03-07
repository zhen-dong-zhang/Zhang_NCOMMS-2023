function [tvec, dvec]=read_ascii_traces(filename)
%%% function read ascii trace files
%%% input CMT and Station name
    fid  = fopen(filename,'rt');
    hdr   = strtrim(regexp(fgetl(fid),'\t','split'));
    fclose(fid);
    
    fid  = fopen(filename,'rt');
    mattp = cell2mat(textscan(fid,repmat('%f',1,numel(hdr))));
    fclose(fid);
    
%     dvec(1)   = hdr{1,2};
%     tvec(1)   = hdr{1,1};
    dvec(:)  =  mattp(2:2:end);
    tvec(:)  = mattp(1:2:end);
    

end