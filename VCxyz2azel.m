% xyz2azel(X,Y,Z)
%   coordinate transformation (x,y,z) -> (az,el) 
%
%   Annemiek Barsingerhorn

function azel=VCxyz2azel(x,y,z)

if (nargin==1 && size(x,2)==3)
  y=x(:,2);
  z=x(:,3);
  x=x(:,1);
end

RTD = 180/pi;
azel = zeros(length(x),2);

p   = sqrt(x.*x + z.*z);
azel(:,1) = RTD * atan2 (x, sqrt (y.^2 + z.^2));
azel(:,2) = RTD * atan2(y,z);