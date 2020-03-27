function fe = my_dct(I)
C = 1e-7;
temp1=dct2(I);
temp2=temp1(:);
rf = temp2(2:end);
rf = abs(rf);
nrf=rf.^2/sum(sum(rf.^2))+C;
fe=-sum(sum(nrf.*log2(nrf)));
