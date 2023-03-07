function [  ] = y_wrfile_phasefile( phasefile, phase, mode )

% mode can be 'w' (write over) or 'a' (append)
if nargin < 2 || nargin > 3
    return;
end
if nargin == 2
    mode = 'w';
end
% read phase file saved from the crazyseismic software
if isempty(phase)
    return;
end
% fid = fopen(phasefile,'w');
fid = fopen(phasefile,mode);
fprintf(fid,'#filename theo_tt tshift obs_tt polarity stnm netwk rayp stla stlo stel evla evlo evdp dist az baz\n');
if isfield(phase,'theo_tt')
    for i = 1:length(phase.filename)
        fprintf(fid,'%s %f %f %f %f %s %s %f %f %f %f %f %f %f %f %f %f\n', phase.filename{i}, phase.theo_tt(i), phase.tshift(i), phase.obs_tt(i),...
            phase.polarity(i), phase.stnm{i}, phase.netwk{i}, phase.rayp(i), phase.stla(i), phase.stlo(i), phase.stel(i), phase.evla(i), phase.evlo(i),...
            phase.evdp(i), phase.dist(i), phase.az(i), phase.baz(i));
    end
else
    for i = 1:length(phase.filename)
        fprintf(fid,'%s\n', phase.filename{i});
    end
end

fclose(fid);

end

