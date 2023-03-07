function SetDefaultValue(argName, defaultValue)
% Initialise a missing or empty value in the caller function.
% 
% SETDEFAULTVALUE(POSITION, ARGNAME, DEFAULTVALUE) checks to see if the
% argument named ARGNAME in position POSITION of the caller function is
% missing or empty, and if so, assigns it the value DEFAULTVALUE.
% 
% Example:
% function x = TheCaller(x)
% SetDefaultValue(1, 'x', 10);
% end
% TheCaller()    % 10
% TheCaller([])  % 10
% TheCaller(99)  % 99
% 
% $Author: Richie Cotton $  $Date: 2010/03/23 $

if evalin(isempty(evalin('caller', argName))
   assignin(argName, defaultValue);
end
end