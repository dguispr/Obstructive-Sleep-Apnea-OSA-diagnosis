clear
close all
clc

for ii = 1:35
    sig_files = {}; apnea_paths = {}; normal_paths = {}; apn_file = {};
    
    sig_files = {'a01.dat','a02.dat','a03.dat','a04.dat','a05.dat','a06.dat','a07.dat','a08.dat','a09.dat','a10.dat','a11.dat','a12.dat','a13.dat','a14.dat','a15.dat','a16.dat','a17.dat','a18.dat','a19.dat','a20.dat','b01.dat','b02.dat','b03.dat','b04.dat','b05.dat','c01.dat','c02.dat','c03.dat','c04.dat','c05.dat','c06.dat','c07.dat','c08.dat','c09.dat','c10.dat'};
    annot_file = {'a01.txt','a02.txt','a03.txt','a04.txt','a05.txt','a06.txt','a07.txt','a08.txt','a09.txt','a10.txt','a11.txt','a12.txt','a13.txt','a14.txt','a15.txt','a16.txt','a17.txt','a18.txt','a19.txt','a20.txt','b01.txt','b02.txt','b03.txt','b04.txt','b05.txt','c01.txt','c02.txt','c03.txt','c04.txt','c05.txt','c06.txt','c07.txt','c08.txt','c09.txt','c10.txt'};
    
    %% read signal (.dat) file
    file_num = sig_files{ii};
    signal_file = fopen(file_num);
    y = fread(signal_file, 'int16', 'ieee-le');
    fclose(signal_file);
    len = length(y);
    
    %% denoising
    wname = 'sym8'; level = 6;
    OPsig=wden(y,'rigrsure','s','sln',level, wname);
    [CA,CD] = wavedec(OPsig,level,wname); %wave decomposition
    P = thselect(CA,'rigrsure');
    CA = wthresh(CA,'h',P);
    Csig = waverec(CA, CD, wname); % wave reconstruction
%     den_sig = cmddenoise(CA,CD, wname, level); % wave denoising

    %% read annotations
    Annotations = {};
    text_annot_file = dir(annot_file{ii});
     nfile = length(text_annot_file);
     ctext = cell(nfile, 1);
     cdata = cell(nfile, 1);
 
 for i = 1:length(text_annot_file)
     fid = fopen(text_annot_file(i).name);
     ctext{i} = textscan(fid,'%s',6);  
     cdata{i} = textscan(fid, '%s');
     fclose(fid);
 end

 %Save annotations in separate .mat file
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
        %% apnea/normal count for indexing
        normal_path = 'E:\Paper_1\Experiments\final_mannual_spect_scalog\final_train_mannual_scalog\normal/';
        normal_dir = dir(fullfile(normal_path, '/*.png'));
        normal_count = numel(normal_dir);
        
        apnea_path = 'E:\Paper_1\Experiments\final_mannual_spect_scalog\final_train_mannual_scalog\apnea/';
        apnea_dir = dir(fullfile(apnea_path, '/*.png'));
        apnea_count = numel(apnea_dir);
        
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
    normal_index = 1; apnea_index = 1;
    segm(1,:) = Csig(1:5999);
    den_sig = segm(1,:);
    
    [wt,f] = cwt(den_sig, 'morse');
    t = 1:5999;
    hp = pcolor(t,f,abs(wt));
    hp.EdgeColor = 'none';
    set(gca,'yscale','log');
    
    if strcmp(Annotations{1}, 'N')
        fname = sprintf('%d.png', normal_index+normal_count);
        normal_folder = fullfile(normal_path, fname);
        saveas(gcf,normal_folder)
        normal_index = normal_index+1;

        elseif strcmp(Annotations{1}, 'A')
            fname = sprintf('%d.png', apnea_index+apnea_count);
            apnea_folder = fullfile(apnea_path, fname);
            saveas(gcf,apnea_folder)
            apnea_index = apnea_index+1;
    else
    end
    
    %% convert rest of the record %%
present = 6000; next=present+5999;
for c = 2:limit
    if next<=len
    ii
    c
    normal_index
    apnea_index
    split(c,:) = Csig(present:next); 
    den_sig = split(c,:);

    [wt,f] = cwt(den_sig, 'morse');
    t = present:next;
    hp = pcolor(t,f,abs(wt));
    hp.EdgeColor = 'none';
    set(gca,'yscale','log');
    
    if strcmp(Annotations{c}, 'N')
        fname = sprintf('%d.png', normal_index+normal_count);
        normal_folder = fullfile(normal_path, fname);
        saveas(gcf,normal_folder)
        normal_index = normal_index+1;
        elseif strcmp(Annotations{c}, 'A')
            fname = sprintf('%d.png', apnea_index+apnea_count);
            apnea_folder = fullfile(apnea_path, fname);
            saveas(gcf,apnea_folder)
            apnea_index = apnea_index+1;
    else
    end
    else
    end
     present=next+1;
     next=next+6000;
end
end