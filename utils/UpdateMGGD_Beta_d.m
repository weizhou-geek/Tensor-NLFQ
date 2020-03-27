
% =========================================================================
% This function is part of the software release, "Bivariate and
% Spatial-Oriented Correlation Models of Natural Images".
%
% Author: Che-Chun Su (ccsu@utexas.edu)
% =========================================================================

function [ result ] = UpdateMGGD_Beta_d ( N , D , y , beta )

sum_y = sum ( y.^beta );
sum_y_ln = sum ( y.^beta.*log(y) );
sum_y_ln_sq = sum ( y.^beta.*(log(y).^2) );
digamma_beta = psi ( D/(2*beta) );
digamma_beta_dv = psi ( 1 , D/(2*beta) );

result = D*N/2 + D*N*sum_y_ln_sq/(2*sum_y) + D*N*(digamma_beta+log(2))/(2*beta^2) + D^2*N*digamma_beta_dv/(4*beta^3) + D*N*log(beta*sum_y/(D*N))/(2*beta^2) - D*N/(2*beta^2) - D*N*sum_y_ln/(2*beta*sum_y);
