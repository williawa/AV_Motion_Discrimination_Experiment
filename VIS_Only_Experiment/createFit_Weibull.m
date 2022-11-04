function [fitresult, gof, fig] = createFit_Weibull(coh_list, pc)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : coh_list
%      Y Output: pc
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 10-Aug-2022 10:09:38


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( coh_list, pc );


% Set up fittype and options.
ft = fittype( '1-exp(-(x/a)^k)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [1e-06 -Inf];
opts.StartPoint = [0.884990233378475 0.276025076998578];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
h = plot( fitresult, xData, yData );
legend( h, '% Rightward Resp. vs. Coherence', 'Weibull', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Coherence (9 = -1 Coh (Leftward) / 11 = +1 Coh (Rightward))', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([9 11])
ylim([0 1])
grid on


