%before running, create a folder with all the auditory only blocks you want
%to combine, plot, and analyze. this script goes into that folder, combines
%those files, plots the psychometric function, and gives you mu and the
%standard deviation of the cumulative gaussian of the function (mu)
Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/Alv_Jan_aud_26velocity/' ;% wherever you want to search
[dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path);
save_name='Alvarez_AudOnly_January2024_26velocity_22degrees_824ms';

audInfo.coherences=unique(cell2mat(dataout(2:end,8)))';
[audInfo.cohFreq] = cohFreq_finder(dataout, audInfo);

total_trials=size(dataout,1)-1;

num_regular_trials = total_trials;  
num_catch_trials =0; %set catch trials to 0 since the combine_data_acrossblocks function already deleted catch trials

%[Fixation_Success_Rate, AUD_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)
    format long g
    %Break down of each success rate based on coherence level 
    prob = coherence_probability(dataout,audInfo)
%    prob_zero = prob(1,:); 
    
    [Right_dataout, Left_dataout] = direction_splitter(dataout);
    
    audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);
    
    
    prob_Right = directional_probability(Right_dataout, audInfo); 
    prob_Left = directional_probability(Left_dataout, audInfo); 
    
    [x, y, fig_both,mu,std_gaussian,LR_xdata,LR_ydata,LR_curve_xvals,LR_curve_yvals] = psychometric_plotter(prob_Right,prob_Left, audInfo,save_name,'red');
   % Eye_Tracker_Plotter(eye_data_matrix);
    
    %%Make Rightward only graph
    prob_right_only = coherence_probability_1_direction(Right_dataout, audInfo);
    [R_coh, R_pc, R_fig] = psychometric_plotter_1_direction(prob_right_only, 'RIGHT ONLY', audInfo, save_name);
    
    %%Make Leftward only graph
    prob_left_only = coherence_probability_1_direction(Left_dataout, audInfo);
    [L_coh, L_pc, L_fig] = psychometric_plotter_1_direction(prob_left_only, 'LEFT ONLY', audInfo, save_name);

    mu
    std_gaussian
    slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi))
    dy_dx = diff(LR_curve_yvals) ./ diff(LR_curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
    slope = mean(dy_dx)
    figure_file_directory=Path;
    %Save all figures to Figure Directory
   % saveas(fig_both, [figure_file_directory save_name '_AUD_Psyc_Func_LR.png'])
   % saveas(R_fig, [figure_file_directory save_name '_AUD_Psyc_Func_R.png'])
   % saveas(L_fig, [figure_file_directory save_name '_AUD_Psyc_Func_L.png'])
    
    
  