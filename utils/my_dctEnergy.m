function [f]=my_dctEnergy(I)

C = 1e-7;
rf = dct2(I);
rf(1,1) = C;
rf = abs(rf);
nrf=rf.^2/sum(sum(rf.^2)) + C;

low_band = ...
[    0     1     1     1     1     0     0     0
     1     1     1     1     0     0     0     0
     1     1     1     0     0     0     0     0
     1     1     0     0     0     0     0     0
     1     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0];
 
high_band = ...
[    0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     1
     0     0     0     0     0     0     1     1
     0     0     0     0     0     1     1     1
     0     0     0     0     1     1     1     1
     0     0     0     1     1     1     1     1];
 
middle_band = ones(8,8) -  low_band - high_band;
middle_band(1,1) = 0;

low_coeffs      = nrf(find(nrf.*low_band));
mid_coeffs      = nrf(find(nrf.*middle_band));
hig_coeffs      = nrf(find(nrf.*high_band));

low_ent = -sum(sum(low_coeffs.*log2(low_coeffs)));
mid_ent = -sum(sum(mid_coeffs.*log2(mid_coeffs)));
hig_ent = -sum(sum(hig_coeffs.*log2(hig_coeffs)));


r1 = abs(hig_ent - mean([ low_ent mid_ent]))/(hig_ent + mean([ low_ent mid_ent]) + C);
r2 = abs(mid_ent - low_ent)/(mid_ent - low_ent + C);

f = (r1+r2)/2;

