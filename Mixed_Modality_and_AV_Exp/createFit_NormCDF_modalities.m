function [fig, AUD_p_values, VIS_p_values,...
               AV_aud_p_values, AV_vis_p_values,...
               AUD_threshold, VIS_threshold] = createFit_NormCDF_modalities(AUD_coh_list, AUD_pc,...
                                                                              VIS_coh_list, VIS_pc,...
                                                                              AV_coh_list_aud, AV_aud_pc,...
                                                                              AV_coh_list_vis, AV_vis_pc,...
                                                                              audInfo, dotInfo, AVInfo, chosen_threshold,save_name)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.



%% Fit: 'untitled fit 1'.
[AUD_xData, AUD_yData] = prepareCurveData( AUD_coh_list, AUD_pc );
[VIS_xData, VIS_yData] = prepareCurveData( VIS_coh_list, VIS_pc );
[AV_aud_xData, AV_aud_yData] = prepareCurveData( AV_coh_list_aud, AV_aud_pc );
[AV_vis_xData, AV_vis_yData] = prepareCurveData( AV_coh_list_vis, AV_vis_pc );

%%AUD
AUD_mu = mean(AUD_yData);
AUD_sigma =std(AUD_yData);
AUD_parms = [AUD_mu, AUD_sigma];
%%VIS
VIS_mu = mean(VIS_yData);
VIS_sigma =std(VIS_yData);
VIS_parms = [VIS_mu, VIS_sigma];
%AV_aud
AV_aud_mu = mean(AV_aud_yData);
AV_aud_sigma =std(AV_aud_yData);
AV_aud_parms = [AV_aud_mu, AV_aud_sigma];
%AV_vis
AV_vis_mu = mean(AV_vis_yData);
AV_vis_sigma =std(AV_vis_yData);
AV_vis_parms = [AV_vis_mu, AV_vis_sigma];


fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
AUD_fun = @(b)sum((fun_1(b,AUD_xData) - AUD_yData).^2); 
VIS_fun = @(b)sum((fun_1(b,VIS_xData) - VIS_yData).^2); 
AV_aud_fun = @(b)sum((fun_1(b,AV_aud_xData) - AV_aud_yData).^2);
AV_vis_fun = @(b)sum((fun_1(b,AV_vis_xData) - AV_vis_yData).^2);
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 

AUD_fit_par = fminsearch(AUD_fun, AUD_parms, opts);
VIS_fit_par = fminsearch(VIS_fun, VIS_parms, opts);
AV_aud_fit_par = fminsearch(AV_aud_fun, AV_aud_parms, opts);
AV_vis_fit_par = fminsearch(AV_vis_fun, AV_vis_parms, opts);

x = -1:.01:1;
AUD_p = cdf('Normal', x, AUD_fit_par(1), AUD_fit_par(2));
VIS_p = cdf('Normal', x, VIS_fit_par(1), VIS_fit_par(2));
AV_aud_p = cdf('Normal', x, AV_aud_fit_par(1), AV_aud_fit_par(2));
AV_vis_p = cdf('Normal', x, AV_vis_fit_par(1), AV_vis_fit_par(2));

[AUD_p_values, bootstat_AUD] = p_value_calc(AUD_yData,AUD_parms);
[VIS_p_values, bootstat_VIS] = p_value_calc(VIS_yData,VIS_parms);
[AV_aud_p_values, bootstat_AV_aud] = p_value_calc(AV_aud_yData,AV_aud_parms);
[AV_vis_p_values, bootstat_AV_vis] = p_value_calc(AV_vis_yData,AV_vis_parms);


%Plot different sizes based on amount of frequency of each coh
sizes_L_AUD = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_AUD = audInfo.cohFreq_right(2,:)';
all_sizes_AUD = nonzeros(vertcat(sizes_L_AUD, sizes_R_AUD));

sizes_L_VIS = flip(dotInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_VIS = dotInfo.cohFreq_right(2,:)';
all_sizes_VIS = nonzeros(vertcat(sizes_L_VIS, sizes_R_VIS));

sizes_L_AV_aud = flip(AVInfo.cohFreq_left_aud(2,:)');%Slpit to left and Right 
sizes_R_AV_aud = AVInfo.cohFreq_right_aud(2,:)';
all_sizes_AV_aud = nonzeros(vertcat(sizes_L_AV_aud, sizes_R_AV_aud));

sizes_L_AV_vis = flip(AVInfo.cohFreq_left_vis(2,:)');%Slpit to left and Right 
sizes_R_AV_vis = AVInfo.cohFreq_right_vis(2,:)';
all_sizes_AV_vis = nonzeros(vertcat(sizes_L_AV_vis, sizes_R_AV_vis));

if length(AUD_xData) ~= length(all_sizes_AUD)
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
end

if length(VIS_xData) ~= length(all_sizes_VIS)
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));
end

if length(AV_aud_xData) ~= length(all_sizes_AV_aud)
    all_sizes_AV_aud = all_sizes_AV_aud(1:length(AV_aud_xData));
end

if length(AV_vis_xData) ~= length(all_sizes_AV_vis)
    all_sizes_AV_vis = all_sizes_AV_vis(1:length(AV_vis_xData));
end

AUD_threshold_location=find(AUD_p >= chosen_threshold, 1);
AUD_threshold=x(1,AUD_threshold_location);
VIS_threshold_location=find(VIS_p >= chosen_threshold, 1);
VIS_threshold=x(1,VIS_threshold_location);
% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(AUD_xData, AUD_yData, all_sizes_AUD, 'red', 'filled')
hold on
scatter(VIS_xData, VIS_yData, all_sizes_VIS, 'blue', 'filled')
scatter(AV_aud_xData, AV_aud_yData, all_sizes_AV_aud, 'green', 'filled')
scatter(AV_vis_xData, AV_vis_yData, all_sizes_AV_vis, 'black', 'filled')

plot(x, AUD_p, "red",...
        x, VIS_p, "blue",...
        x, AV_aud_p, 'green',...
        x, AV_vis_p, 'black');

legend('AUD','VIS','AV_aud','AV_vis', 'AUD - NormCDF', 'VIS - NormCDF','AV_aud - NormCDF', 'AV_vis - NormCDF', 'Location', 'Best', 'Interpreter', 'none' );
% Label axes
title(sprintf('AUD,VIS,AV Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on

end