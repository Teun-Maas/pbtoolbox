function pb_genpassword(varargin)
% PB_GENPASSWORD
%
% PB_GENPASSWORD generates a random strong password (i.e. too long for brute force hacking.
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   v        = varargin;
   nchunk   = pb_keyval('chunks',v,4);
   nchar    = pb_keyval('chars',v,5);
   maxl     = pb_keyval('length',v);
   
   
   abc   = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
   num   = '0123456789';
   spc   = '±§!@€#$%^&*+=:;|\~<,>.?';
   
   password = '';
   rng('shuffle');
   for iChunk = 1:nchunk
      s        = blanks(nchar);
      order    = randperm(nchar);
      s(order(1)) = num(randi(length(num)));
      s(order(2)) = spc(randi(length(spc)));

      for iChar = 3:nchar
         s(order(iChar)) = abc(randi(length(abc)));
      end

      password = [password s];
      if iChunk < nchunk
         password = [password '-'];
      end
   end
   clc;
   len         = length(password);
   strength    = (length(abc)+length(num)+length(spc))^len;
   
   
   disp([sprintf('<strong>Password:</strong>   ') password]);
   disp([sprintf('<strong>Length:</strong>     ') num2str(len) ' characters']);
   disp(newline);
   
   clipboard('copy',password);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

