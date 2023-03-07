function setParameterDefault(pname, defval, warn)
% setParameterDefault(pname, defval, warn=true)
% sets the parameter NAMED pname to the value defval if it is undefined or
% empty
%
% example:
% function y = f(x,t)
% setParameterDefault('x',1);
% setParameterDefault('t',3);
% y = 3*x-2*t;
%
% originally posted at
% http://stackoverflow.com/q/5389428/321973
%
% Author: Tobias Kienzler

if ~isParameterDefined('pname')
    error('paramDef:noPname', 'No parameter name defined!');
elseif ~isvarname(pname)
    error('paramDef:pnameNotChar', 'pname is not a valid varname!');
elseif ~isParameterDefined('defval')
    error('paramDef:noDefval', ['No default value for ' pname ' defined!']);
elseif ~isParameterDefined('warn')
    warn = true;
end;


% isParameterNotDefined copy&pasted since evalin can't handle caller's
% caller...
if ~evalin('caller',  ['exist(''' pname ''', ''var'') && ~isempty(' pname ')'])
    if warn
        callername = evalin('caller', 'mfilename');
        warnMsg = ['Setting ' pname ' to default value'];
        if isscalar(defval) || ischar(defval) || isvector(defval)
            warnMsg = [warnMsg ' (' num2str(defval) ')'];
        end;
        warnMsg = [warnMsg '!'];
        warning([callername ':paramDef:assigning'], warnMsg);
    end
    assignin('caller', pname, defval);
end
