function [fig] = createFit_NormCDF(coh_list, pc, audInfo, save_name)
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

mu = mean(yData);
sigma =std(yData);
parms = [mu, sigma];

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
fun = @(b)sum((fun_1(b,xData) - yData).^2); 
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
fit_par = fminsearch(fun, parms, opts);

x = -1:.01:1;
p = cdf('Normal', x, fit_par(1), fit_par(2));

%Plot different sizes based on amount of frequency of each coh
sizes_L = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R = audInfo.cohFreq_right(2,:)';
all_sizes = nonzeros(vertcat(sizes_L, sizes_R));


% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(xData, yData, all_sizes)
hold on 
plot(x, p);
legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
title(sprintf('AV Psych. Func. L&R\n%s',save_name), 'Interpreter','none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on

end
