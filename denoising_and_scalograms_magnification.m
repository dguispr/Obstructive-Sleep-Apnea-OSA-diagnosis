clear
close all
clc

n = 2;
for kkk = n:n
    sig_files = {}; apnea_paths = {}; normal_paths = {}; apn_file = {};
    
    sig_files = {'a01.dat','a02.dat','a03.dat','a04.dat','a05.dat','a06.dat','a07.dat','a08.dat','a09.dat','a10.dat','a11.dat','a12.dat','a13.dat','a14.dat','a15.dat','a16.dat','a17.dat','a18.dat','a19.dat','a20.dat','b01.dat','b02.dat','b03.dat','b04.dat','b05.dat','c01.dat','c02.dat','c03.dat','c04.dat','c05.dat','c06.dat','c07.dat','c08.dat','c09.dat','c10.dat'};
    annot_file = {'a01.txt','a02.txt','a03.txt','a04.txt','a05.txt','a06.txt','a07.txt','a08.txt','a09.txt','a10.txt','a11.txt','a12.txt','a13.txt','a14.txt','a15.txt','a16.txt','a17.txt','a18.txt','a19.txt','a20.txt','b01.txt','b02.txt','b03.txt','b04.txt','b05.txt','c01.txt','c02.txt','c03.txt','c04.txt','c05.txt','c06.txt','c07.txt','c08.txt','c09.txt','c10.txt'};

%% Read the whole signal %%

signal_file = fopen(sig_files{kkk}); %read .dat signal
y = fread(signal_file, 'int16', 'ieee-le');
len = length(y)/6000;
fclose(signal_file);

%% denoising
    wname = 'sym8'; level = 6;
    OPsig=wden(y,'rigrsure','s','sln',level, wname);
    [CA,CD] = wavedec(OPsig,level,wname); %wave decomposition
    P = thselect(CA,'rigrsure');
    CA = wthresh(CA,'h',P);
    Csig = waverec(CA, CD, wname); % wave reconstruction
%     den_sig = cmddenoise(CA,CD, wname, level); % wave denoising

%% Read and save annotations %%
Annotations = {};
    text_annot_file = dir(annot_file{kkk});
     nfile = length(text_annot_file);
     ctext = cell(nfile, 1);
     cdata = cell(nfile, 1);
 
 for i = 1:length(text_annot_file)
     fid = fopen(text_annot_file(i).name);
     ctext{i} = textscan(fid,'%s',6);  
     cdata{i} = textscan(fid, '%s');
     fclose(fid);
 end

 % Save annotations in separate .mat file
 B = [ctext{:}];
 Annotate_1 = B{1,1}{3,1};
 Annotations{1} = Annotate_1;
 L = length(cdata{1,1}{1,1});
 
 index=3;
 j=2;
 while index<=L
     
     Annotations{j} = cdata{1,1}{1,1}{index,1};
     index=index+6;
     j=j+1;
 end
        limit = numel(Annotations);

        %% apnea/normal count for indexing %%%%%

        %% Scalograms/magnified scalograms
%         apnea_scalog_path = 'E:\Paper_1\Experiments\R_detection_technique\training_scal\low_freq\apnea/';
%         apnea_scalog_dir = dir(fullfile(apnea_scalog_path, '/*.png'));
%         apnea_scalog_count = numel(apnea_scalog_dir);
%         
%         normal_scalog_path = 'E:\Paper_1\Experiments\R_detection_technique\training_scal\low_freq\normal/';
%         normal_scalog_dir = dir(fullfile(normal_scalog_path, '/*.png'));
%         normal_scalog_count = numel(normal_scalog_dir);
% 
        att_apnea_scalog_path = 'E:\Paper_1\paper1_discussion_figures\FN/';
        att_apnea_scalog_dir = dir(fullfile(att_apnea_scalog_path, '/*.png'));
        att_apnea_scalog_count = numel(att_apnea_scalog_dir);

        att_normal_scalog_path = 'E:\Paper_1\paper1_discussion_figures\FP/';
        att_normal_scalog_dir = dir(fullfile(att_normal_scalog_path, '/*.png'));
        att_normal_scalog_count = numel(att_normal_scalog_dir);

        
        %% Spectrograms/magnified spectrograms

%         att_apnea_spect_path = 'E:\Paper_1\paper1_discussion_figures\apnea/';
%         att_apnea_spect_dir = dir(fullfile(att_apnea_spect_path, '/*.png'));
%         att_apnea_spect_count = numel(att_apnea_spect_dir);
% 
%         att_normal_spect_path = 'E:\Paper_1\paper1_discussion_figures\normal/';
%         att_normal_spect_dir = dir(fullfile(att_normal_spect_path, '/*.png'));
%         att_normal_spect_count = numel(att_normal_spect_dir);
        
        
        %% normal/apnea images per record %%
        normal_images_per_record = 0; apnea_images_per_record =0;
        for jj = 1:limit
            if strcmp(Annotations(jj), 'N')
                normal_images_per_record = normal_images_per_record+1;
            else
                apnea_images_per_record = apnea_images_per_record+1;
            end
        end
        
 %% convert the first segment %%
    normal_index = 1; apnea_index = 1; fs = 100;
    den_sig = Csig(1:5999);

 %% selecting frequency range --> FFT -> select major contributed frequency components -> IFFT
 x1 = den_sig;
 med1 = medfilt1(x1,20);
 subt = x1-med1;
%  subplot(5,1,1)
%  plot(subt)
%  hold on

 %% R detection by max value
R_peaks = []; loc = [];
ik = 0; mini_wind_start = 1; mini_wind_stop = 53;

        for ii=1:length(subt)
            
            [temp_peaks(ii), temp(ii)] = max(subt(mini_wind_start:mini_wind_stop));
            if temp_peaks(ii)>54
                ik = ik+1;
                
                R_peaks(ik) = temp_peaks(ii);
                loc(ik) = temp(ii)+mini_wind_start-1;
        
%                 plot(loc(ik),R_peaks(ik), 'r*')
            end
                mini_wind_start = mini_wind_stop+1; mini_wind_stop = mini_wind_stop+53;
        
        if mini_wind_stop>length(subt) %|next_loc>length(subt)
            break;
        end
        end

    %% remove wrong peaks
%     subplot(2,1,1)
%     plot(subt)
%     hold on
    for ijk = 1:length(loc)
                if ijk+1<length(loc) & (loc(ijk+1) == loc(ijk)+1|loc(ijk+1)  == loc(ijk)+2|loc(ijk+1)  == loc(ijk)+3)

                    if R_peaks(ijk)>R_peaks(ijk+1)
                   R_peaks(ijk) = R_peaks(ijk);
                   R_peaks(ijk+1) = R_peaks(ijk);
                   loc(ijk) = loc(ijk);

                    elseif R_peaks(ijk)<R_peaks(ijk+1)
                        R_peaks(ijk) = R_peaks(ijk+1);
                        loc(ijk+1) = loc(ijk+1);
                    end

                end
%                 plot(loc(ijk),R_peaks(ijk), 'gr*')
                
    end
% hold off

%% interpolation
qp = 1:loc(end);

interp_sig = interp1(loc,R_peaks,qp);
interp_sig_mean = mean(interp_sig(loc(1):loc(end)));
interp_sig_BL_corr = (interp_sig(loc(1):loc(end)) - interp_sig_mean);
med_20 = medfilt1(interp_sig_BL_corr, 20);
med_60 = medfilt1(med_20, 60);

% plot(interp_sig, 'black--')
% subplot(5,1,2)
% plot(med_60, 'black')
% subtitle('interpolated signal')

%% frequency analysis
L = length(med_60);
NFFT = 2^nextpow2(L);
FFT = fft(med_60, NFFT)/L;
freq_range = 20.47;
f = (fs/L)*(0:freq_range);
p1 = FFT(1:freq_range+1);
p1(2:freq_range-1) = 2*p1(2:freq_range-1);

% subplot(5,1,3)
% plot(f, p1, "Color", "cyan")
% subtitle('frequency domain signal')

%% Inverse FFT
IFFT = ifft(p1, NFFT, 'symmetric');
range = length(med_60);
p3 = IFFT(1:range);
p3(2:range-1) = 2*p3(2:range-1);

% subplot(5,1,4)
% plot(p3, "r")
% subtitle('recovered time domain signal')

%% bitwise attention
attention_sig = p3.*med_60;
% subplot(1,2,1)
% plot(attention_sig, "magenta")
% hold off
% subplot(1,2,2)
fname = sprintf('%d.png', 1);
    if strcmp(Annotations{1}, 'N')
%         fname = sprintf('%d.png', normal_index);
%         normal_spect_folder = fullfile(att_normal_spect_path, fname);
% 
%       % magnified scalograms
        [wt,fw] = cwt(attention_sig, 'morse');
        t = 1:length(attention_sig);
        hp = pcolor(t,fw,abs(wt));
        hp.EdgeColor = 'none';
        set(gca,'yscale','log');
        att_normal_scalog_folder = fullfile(att_normal_scalog_path, fname);
        saveas(gca,att_normal_scalog_folder)
        clear gca;

        normal_index = normal_index+1;

        elseif strcmp(Annotations{1}, 'A')
%             fname = sprintf('%d.png', apnea_index);
%             apnea_spect_folder = fullfile(att_apnea_spect_path, fname);
% 
%             % magnified scalograms
            [wt,fw] = cwt(attention_sig, 'morse');
            t = 1:length(attention_sig);
            hp = pcolor(t,fw,abs(wt));
            hp.EdgeColor = 'none';
            set(gca,'yscale','log');
            att_apnea_scalog_folder = fullfile(att_apnea_scalog_path, fname);
            saveas(gca, att_apnea_scalog_folder)
            clear gca;

            apnea_index = apnea_index+1;
    else
    end

    clear x1; clear den_sig; clear med1; clear subt;
    
%% convert rest of the record %%
present = 96000; next=present+5999;
for c = 2:limit
    kkk
    c
    segment = [present next]
    normal_index
    apnea_index
    den_sig = Csig(present:next);
%     plot(den_sig)
%     spectrogram(den_sig, blackman(30,'periodic'), 25, 15000, 'yaxis');
%% selecting frequency range --> FFT -> select major contributed frequency components -> IFFT
x1 = den_sig;
med1 = medfilt1(x1,20);
subt = x1-med1;
% subplot(2,1,1)
% plot(subt)
% xlabel('Sample index')
% ylabel('Apmlitude')
% xlim([1 1000])
% hold on

%% R detection by max value
R_peaks = []; loc = []; next_loc = 0;
ik = 0; mini_wind_start = 1; mini_wind_stop = 53;

        for ii=1:length(subt)
            [temp_peaks(ii), temp(ii)] = max(subt(mini_wind_start:mini_wind_stop));
            if temp_peaks(ii)>54
                ik = ik+1;               
                loc(ik) = temp(ii)+mini_wind_start;
                R_peaks(ik) = temp_peaks(ii);
%                 plot(loc(ik),R_peaks(ik), 'r*')
            end
                mini_wind_start = mini_wind_stop+1; mini_wind_stop = mini_wind_stop+53;
        if mini_wind_stop>length(subt)
            break;
        end
        end
%         hold off

    %% remove wrong peaks
%     subplot(2,1,1)
%     plot(subt)
%     hold on
    for ijk = 1:length(loc)
                if ijk+1<length(loc) & (loc(ijk+1) == loc(ijk)+1|loc(ijk+1)  == loc(ijk)+2|loc(ijk+1)  == loc(ijk)+3|loc(ijk+1)  == loc(ijk)+4|loc(ijk+1)  == loc(ijk)+5)
                    if R_peaks(ijk)>R_peaks(ijk+1)
                   R_peaks(ijk) = R_peaks(ijk);
                   R_peaks(ijk+1) = R_peaks(ijk);
                   loc(ijk) = loc(ijk);
                    elseif R_peaks(ijk)<R_peaks(ijk+1)
                        R_peaks(ijk) = R_peaks(ijk+1);
                        loc(ijk+1) = loc(ijk+1);
                    end
                end
%                 plot(loc(ijk),R_peaks(ijk), 'gr*') 
    end
% hold off
% subtitle("(a)- Original signal")
% input('')

%% interpolation
qp = 1:loc(end);
interp_sig = interp1(loc,R_peaks,qp);
interp_sig_mean = mean(interp_sig(loc(1):loc(end)));
interp_sig_BL_corr = (interp_sig(loc(1):loc(end)) - interp_sig_mean);
med_20 = medfilt1(interp_sig_BL_corr, 20);
med_60 = medfilt1(med_20, 60);
% plot(interp_sig, 'black--')
% hold off
% subplot(2,1,2)
% plot(med_60, 'black-', 'LineWidth', 2)
% xlabel('Sample index')
% ylabel('Apmlitude')
% subtitle('(b)- Interpolated signal')

%% frequency analysis
L = length(med_60);
% NFFT = 2^nextpow2(L);
FFT = fft(med_60, L);
absFFT = abs(FFT/L);
halfFFT = absFFT(1:L);
halfFFT(2:end-1) = 2*halfFFT(2:end-1);
f = fs*(0:(L)-1)/L;
% subplot(2,1,1)
% plot(f, halfFFT, 'color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
H_idx = 21;
halfFFTtr = halfFFT(1:H_idx);
ftr = (fs/L)*(0:H_idx-1);
padH = zeros(1, length(halfFFT)-(H_idx));
pad_half = [halfFFTtr padH];
filtrdSig = pad_half.*halfFFT;
% subplot(2,1,2)
% plot(ftr, halfFFTtr, 'color', [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
% input('')
% freq_range = 20.55;
% fr = (fs/L)*(0:freq_range);
% p1 = FFT(1:freq_range+1);
% p1(2:freq_range-1) = 2*p1(2:freq_range-1);

% subplot(2,1,2)
% plot(f, p1, 'magenta', 'LineWidth', 1)
% xlabel('Frequency')
% ylabel('Apmlitude')
% subtitle('(c)- Frequency domain signal')

%% Inverse FFT
Ltr = length(filtrdSig);
IFFT = ifft(filtrdSig, Ltr, 'symmetric');
p3 = IFFT(1:Ltr);
p3(2:Ltr-1) = 2*p3(2:Ltr-1);

% subplot(2,1,1)
% plot(p3, 'blue', 'LineWidth', 2)
% xlabel('Sample index')
% ylabel('Apmlitude')
% subtitle('(d)- Recovered time domain signal')

%% Magnification
attention_sig = p3.*med_60;

% subplot(2,1,2)
% plot(attention_sig, 'r', 'LineWidth', 2)
% xlabel('Sample index')
% ylabel('Apmlitude')
% subtitle('(e)- Magnified signal')

%% desired low frequency scalograms and attention scalograms
% subplot(1,2,2)
fname = sprintf('%d.png', c);
    if strcmp(Annotations{c}, 'N')
        fname = sprintf('%d.png', normal_index+att_normal_spect_count);
        normal_spect_folder = fullfile(att_normal_spect_path, fname);
% 
        % magnified scalograms
        [wt,fw] = cwt(attention_sig, 'morse');
        t = 1:length(attention_sig);
        hp = pcolor(t,fw,abs(wt));
        hp.EdgeColor = 'none';
        set(gca,'yscale','log');
        xlabel('Samples')
        ylabel('Normalized Frequency')
        fname1 = sprintf('%d.png', apnea_index+1);
        att_normal_scalog_folder = fullfile(att_normal_scalog_path, fname);
        saveas(gca,att_normal_scalog_folder)
        clear gca;
        normal_index = normal_index+1;

        elseif strcmp(Annotations{c}, 'A')
%             fname = sprintf('%d.png', apnea_index+att_apnea_spect_count);
%             apnea_spect_folder = fullfile(att_apnea_spect_path, fname);
% 
            % magnified scalograms
            [wt,fw] = cwt(attention_sig, 'morse');
            t = 1:length(attention_sig);
            hp = pcolor(t,fw,10*abs(wt));
            hp.EdgeColor = 'none';
            set(gca,'yscale','log');
            xlabel('Samples')
            ylabel('Normalized Frequency')
            fname1 = sprintf('%d.png', apnea_index+1);
            
            att_apnea_scalog_folder = fullfile(att_apnea_scalog_path, fname);
            saveas(gca, att_apnea_scalog_folder)
            clear gca;
            apnea_index = apnea_index+1;
        
    else
    end
    
     present=next+1;
     next=next+6000;
end
end