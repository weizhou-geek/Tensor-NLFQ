
% =========================================================================
% This function is part of the software release, "Bivariate and
% Spatial-Oriented Correlation Models of Natural Images".
%
% Author: Che-Chun Su (ccsu@utexas.edu)
% =========================================================================

function [ result ] = UpdateMGGD_Beta ( N , D , y , beta )

sum_y = sum ( y.^beta );
sum_y_ln = sum ( y.^beta.*log(y) );
digamma_beta = psi ( D/(2*beta) );

result = D*N*sum_y_ln/(2*sum_y) - D*N*(digamma_beta+log(2))/(2*beta) - N - D*N*log(beta*sum_y/(D*N))/(2*beta);
