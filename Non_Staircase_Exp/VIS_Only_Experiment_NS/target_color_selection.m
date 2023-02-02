function [right_target_color,left_target_color,correct_target] = target_color_selection(dotInfo)

%picks luminance of targets based on which direcction of stimulus is occcuring at each trial
    if dotInfo.dir == 0
        correct_target = 'right';
       
    elseif dotInfo.dir == 180
        correct_target = 'left';
        
    end
    
    if strcmp(correct_target,'right')
        
        right_target_color = [255; 255; 255; 1];
        left_target_color = [255; 255; 255;dotInfo.Incorrect_Opacity];%incorrect target ; RGBA value, a = alpha which is the opacity of the dot value 0-1.0
        
    elseif strcmp(correct_target,'left')
        right_target_color = [255; 255; 255;dotInfo.Incorrect_Opacity]; %incorrect target
        left_target_color = [255; 255; 255; 1];
    end
    
end

