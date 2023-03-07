
function jth= jlayer (zdep, zi)
%  jth= jlayer (zdep, zi)
% 
%  given depth 'zdep' , find which layer 'jlayer' it is in
 
jth = -1; 
nlayer = length(zi); 

for i = 1: nlayer -1 
  if ( zdep >= zi(i) && zdep <= zi(i+1) ) ,
     jth = i; 
  end
end
return
% end function jlayer