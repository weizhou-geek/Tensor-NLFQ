function [o2] = my_dctOrient2(I)

C = 1e-7;
rf = dct2(I);
rf(1,1) = C;
rf = abs(rf);
nrf=rf.^2/sum(sum(rf.^2)) + C;

orient2_mask = ...
    [0     0     0     0     0     0     0     0
     0     1     1     0     0     0     0     0
     0     1     1     1     0     0     0     0
     0     0     1     1     1     0     0     0
     0     0     0     1     1     1     0     0
     0     0     0     0     1     1     1     0
     0     0     0     0     0     1     1     1
     0     0     0     0     0     0     1     1];
 
orient_coeffs = nrf(find(nrf.*orient2_mask));
o2 = -sum(sum(orient_coeffs.*log2(orient_coeffs)));