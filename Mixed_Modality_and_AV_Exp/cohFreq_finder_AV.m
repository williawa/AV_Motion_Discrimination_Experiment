function [cohFreq_dir_aud, cohFreq_dir_vis] = cohFreq_finder_AV(AV_dataout, AVInfo)
    


    %For - AV_coherence_list AUD Coh is 1st Column , VIS Coh is 2nd Column
    % First do this for AUD coherences
    if  strcmp(AV_dataout(1,1), 'Trial #')
        AV_coherence_list = cell2mat(AV_dataout(2:end,8));
        [cnt_aud, uniq_aud] = hist(AV_coherence_list(2:end,1), unique(AV_coherence_list(2:end,1)));
    else
        AV_coherence_list = cell2mat(AV_dataout(:,8));
        [cnt_aud, uniq_aud] = hist(AV_coherence_list(1:end,1), unique(AV_coherence_list(1:end,1)));
    end
    
    ii_aud = [uniq_aud';cnt_aud];

    cohFreq_dir_aud = [AVInfo.cohSet_aud;
                                zeros(1,length(AVInfo.cohSet_aud))];
    for i = 1:length(AVInfo.cohSet_dot)
        for j = 1:length(ii_aud)
            if ii_aud(1,j) == cohFreq_dir_aud(1,i)
                cohFreq_dir_aud(2,i) = ii_aud(2,j);
                break
            else
                cohFreq_dir_aud(2,i) = 0;
            end
        end
    end
    
    %Then do it for VIS Coherences, column 2 of AV_coherence list

    if  strcmp(AV_dataout(1,1), 'Trial #')
        AV_coherence_list = cell2mat(AV_dataout(2:end,8));
        [cnt_vis, uniq_vis] = hist(AV_coherence_list(2:end,2), unique(AV_coherence_list(2:end,2)));
    else
        AV_coherence_list = cell2mat(AV_dataout(:,8));
        [cnt_vis, uniq_vis] = hist(AV_coherence_list(1:end,2), unique(AV_coherence_list(1:end,2)));
    end
    
    ii_vis = [uniq_vis';cnt_vis];

    cohFreq_dir_vis = [AVInfo.cohSet_dot;
                                zeros(1,length(AVInfo.cohSet_dot))];
    for i = 1:length(AVInfo.cohSet_dot)
        for j = 1:length(ii_vis)
            if ii_vis(1,j) == cohFreq_dir_vis(1,i)
                cohFreq_dir_vis(2,i) = ii_vis(2,j);
                break
            else
                cohFreq_dir_vis(2,i) = 0;
            end
        end
    end
    
    
end
  