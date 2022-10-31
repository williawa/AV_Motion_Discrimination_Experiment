function  [ExpInfo, dstruct, dotInfo, audInfo]= CreateClassStructure(data, monWidth, viewDist, xCenter, yCenter) %Puts all data input into structure for neatness
%% Jack Mayfield 4/22/22

%% GUI Input Parameters 

ExpInfo.t_angle = data(1,1); % Fixation Dot and Target Dots Visual Angle in Degrees
ExpInfo.rew_angle = data(2,1);% Reward Window Visual Angle in Degrees
ExpInfo.num_trials = data(3,1); % Number of Trials for 1 block
ExpInfo.stim_time = data(4,1); %Time of stimulus(RDK) presentaiton (ms)
ExpInfo.iti = data(5,1);%Intertrial Interval (ms)
ExpInfo.fixation_time = data(6,1);% Time to fixate on fixation point before RDK Starts presenting == time of presenting fixation point 
ExpInfo.positions = data(7:15,:); % Binary List of ON(1)/OFF(0) for position 1-9
ExpInfo.possible_pos = find(ExpInfo.positions == 1); %Corresponding Number Position available for use
ExpInfo.fail_timeout = data(16,1); %Failure of trial timeout in (ms)
ExpInfo.rdk_angle = data(17,1); %RDK stimulus visual angle
ExpInfo.target_fixation_time = data(18,1);% Time to fixate inside the target point window in order to get Reward

%% This is the random position number generator

%It takes all possible positions given above and produces a list with the
%length of num_trials for use in the .rcx circuit
ExpInfo.random_list = zeros(1,ExpInfo.num_trials);
    for i = 1:ExpInfo.num_trials
      r_index = randi(length(ExpInfo.possible_pos));
      ExpInfo.random_list(i) = ExpInfo.possible_pos(r_index);
    end
    
%% Display Settings 

dstruct.res = [1280 1024];    % screen resolution x y
dstruct.siz = [40 30];        % screen size in cm W,H 
dstruct.dis = 55;             % viewing distance in cm

%% Other Parameters
%ExpInfo.time_wait = [0.5, 0.24]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.time_wait = [1, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time

%ExpInfo.time_wait = [0.7, 3]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.fixpoint_size_pix = angle2pixels(ExpInfo.t_angle); %Fixation Dot Stimulus Size pixels 
ExpInfo.targpoint_size_pix = ExpInfo.fixpoint_size_pix; %Target Dot Size, same as fixation point for now 
ExpInfo.rew_radius_volts = angle2volts(ExpInfo.rew_angle); %Reward window radius value in volts 
%ExpInfo.target_rew_radius_volts = angle2volts(10);
ExpInfo.target_rew_radius_volts = angle2volts(9);

ExpInfo.ppd = 30;%pi * xCenter / atan(monWidth/viewDist/2) / 360;

%% RDK Parameters
dotInfo = struct;
dotInfo.catchtrials = data(34,1); % # catch trials
dotInfo.dirSet = dirBin_vis(data); %See function dirBin_vis.m
dotInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo,dotInfo,data);%Gives list of 1 = regular trial, 0 = catch trial, see function 
dotInfo.rdk_size_pix = angle2pixels(ExpInfo.rdk_angle); %RDK window size in pixels
%dotInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.50, 0.60, 0.80, 1.00]; %Possible coherencecs to choose from 
%dotInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55]; %Possible coherencecs to choose from 
dotInfo.coherences = [0,0.031,0.044,0.063, 0.89,0.125,0.177, 0.25,0.354,0.5,0.707,1];
%dotInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.70, 0.80, 0.90, 1.00]; %Possible coherencecs to choose from 

dotInfo.cohFreq = data(35:46,1)'; % Each Corresponds to the number of trials in that coherence 
dotInfo.cohSet = cohSet_maker(dotInfo); %Randomly scattered cohSet to choose from for regular trials
dotInfo.random_dir_list = randomizer(ExpInfo,dotInfo);

dotInfo.apXYD = [0 90 (ExpInfo.rdk_angle*10)]; % Location x,y pixels (0,0 is center of screen) and diameter of the aperature, currently in visual degrees - MULTPLIED by 10 because of Shadlen dots code, needed to be an integer
dotInfo.speed = data(20,1); %Degrees per second?
%dotInfo.dotSize = 4; %RDK Field Dots
%dotInfo.dotSize = 5; %RDK Field Dots
dotInfo.dotSize = 6; %RDK Field Dots

%dotInfo.dotSize = 9; %RDK Field Dots
%dotInfo.dotSize = 8; %RDK Field Dots
dotInfo.numDotField = 1; %Do not change 
dotInfo.dotColor = [255 255 255]; %Dot field Color
dotInfo.maxDotTime = ExpInfo.stim_time/1000; %Puts this in seconds from ms 
dotInfo.Incorrect_Opacity = 1; %OPacity for the incorrect target if there is only 1 direction of motion, this for training purposes - eventually will be the same opacity as correct 
dotInfo.maxDotsPerFrame = 400; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific
%dotInfo.maxDotsPerFrame = 200; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific


%% Auditory Parameters 
audInfo.dirSet = dirBin_aud(data); %[LR DU UD RL] 1 - Include, 0 - Exclude
audInfo.catchtrials = data(34,1);
audInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo,audInfo,data); 
%audInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.50, 0.60, 0.80, 1.00];
%audInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.50, 0.80, 0.90, 1.00];

%audInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.45, 0.50, 0.55, 1.00];
audInfo.coherences = [0,0.031,0.044,0.063, 0.89,0.125,0.177, 0.25,0.354,0.5,0.707,1];

audInfo.cohFreq = data(35:46,1)'; %[0.0, 0.2, 0.4, 0.6, 0.8, 1.0] Each Corresponds to the number of trials in that coherence (0.0-1.0)
audInfo.cohSet = cohSet_maker(audInfo); 
audInfo.random_dir_list = randomizer(ExpInfo,audInfo); 
audInfo.set_dur = 2.523;%Seconds, This is going to be set as long as the speakers dont move, the actual duration of the stimulus will be set by the t_start and t_end variables
audInfo.t_start = data(27,1); % In ms, , this will also determine "Location" of perceptive field 
audInfo.t_end = data(28,1);  % In ms,
audInfo.velocity = data(29,1); %deg/sec
audInfo.muxSet = [0]; %Set to zero for now which only includes LR and RL directions
audInfo.random_mux_list = zeros(1,(ExpInfo.num_trials)); %Set to zeros for now which only includes LR and RL directions
audInfo.Incorrect_Opacity = 1;   
 
% This explains the inputs for each direction of auditory motion
% dir | mux
% 1       0  = L to R 
% 0       1  = D to U
% 1       1  = U to D
% 0       0  = R to L 

    
    %% Make sure that the opposing directions of aud and visual only occur a certain percentage of trials 
    wanted_per_congruent = 0.9; % Wanted percentage of congruent Trials
    current_per_congruent = 0; 
    
    while current_per_congruent <= wanted_per_congruent  %Change the aud directions until the percentage of congruent trials has met the requirement
    
    good = zeros(1,ExpInfo.num_trials); 
    bad = zeros(1,ExpInfo.num_trials);  
    congruent = 0; 
    opposing = 0; 
    finder = 1; 
%     
%     current_per_congruent = congruent/ExpInfo.num_trials;
%     if current_per_congruent  >= wanted_per_congruent
%         break
%     end
    
    aud_LtoR = audInfo.random_dir_list == 1;%Binary of where aud == L to R 
    aud_RtoL = audInfo.random_dir_list == 0; 
    rdk_LtoR = dotInfo.random_dir_list == 0; %binary of visual == L to R
    rdk_RtoL = dotInfo.random_dir_list == 180; 
        
        for f = 1:ExpInfo.num_trials
            
            if (aud_LtoR(f) == 1 && rdk_LtoR(f) == 1) || (aud_RtoL(f) == 1 && rdk_RtoL(f) == 1)%Congruent Trials
                congruent = congruent + 1;
                good(finder) = 1;
                 
                
            elseif (aud_LtoR(f) == 1 && rdk_LtoR(f) == 0) || (aud_RtoL(f) == 0 && rdk_RtoL(f) == 1)%Opposing Trials
                opposing = opposing + 1;
                bad(finder) = 1; 
                
            end
            
            finder = finder+1;
        end
        
        rand_index = randi([1 ExpInfo.num_trials]);
        rand_index2 = randi([1 ExpInfo.num_trials]);
        
        if (good(rand_index) == 0)
            audInfo.random_dir_list(rand_index) = 1;
            dotInfo.random_dir_list(rand_index) = 0; 
        elseif (good(rand_index2) == 0)
            audInfo.random_dir_list(rand_index) = 0;
            dotInfo.random_dir_list(rand_index) = 180; 
        end
        current_per_congruent = congruent/ExpInfo.num_trials;
        
    end
audInfo.congruentList = good; 
end
