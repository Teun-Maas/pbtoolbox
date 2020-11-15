function outputreeks = fibo(N)
   outputreeks = [0 1];
   for i = 3:N
      outputreeks(i) =  outputreeks(i-1) + outputreeks(i-2);
   end
end

