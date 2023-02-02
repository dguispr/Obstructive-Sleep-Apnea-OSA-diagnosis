close all;
clear all;
clc;

folder_read_from1 = 'E:\Paper_1\paper1_discussion_figures\FP/';
images = dir(fullfile(folder_read_from1, '/*.png'));

no_of_images = numel(images);
%% apnea test scalograms %%
% jj = 1;
for n = 392: 392
%     n = n+jj;
%     n = 8*n;
% if n ~= 8*jj
    n
I =imread(strcat(folder_read_from1,num2str(n),'.png'));
imshow(I)
rect=[118,53,671,528];
I2 = imcrop(I, rect);
I3 = imresize(I2, [299 299], 'nearest');
imshow(I3)
gray = rgb2gray(I3);
% imshow(gray)
% histogram(gray)
%% Threshold for white pixels
    for i = 1:299
        for j = 1:299
            if gray(i,j)>170
                gray(i,j) = gray(i,j);
            else
                gray(i,j) = 0;
            end
        end
    end

    [com_label, co] = bwlabel(gray);
    imshow(com_label)
    [r,c] = find(com_label);
    rc = [r,c];

    %% find the max contributed region
    c1 = 0; c2 = 0; c3 = 0; c4 = 0; c5 = 0;
    c6 = 0; c7 = 0; c8 = 0; c9 = 0; c10 = 0;

    for ijk = 1:co
        if ijk == 1
            [r1, c1] = find(com_label == 1);
        elseif ijk == 2
            [r2, c2] = find(com_label == 2);
        elseif ijk == 3
            [r3, c3] = find(com_label == 3);
        elseif ijk == 4
            [r4, c4] = find(com_label == 4);
        elseif ijk == 5
            [r5, c5] = find(com_label == 5);
        elseif ijk == 6
            [r6, c6] = find(com_label == 6);
        elseif ijk == 7
            [r7, c7] = find(com_label == 7);
        elseif ijk == 8
            [r8, c8] = find(com_label == 8);
        elseif ijk == 9
            [r9, c9] = find(com_label == 9);
        elseif ijk == 10
            [r10, c10] = find(com_label == 10);
        end
    end

    c1_len = length(c1); c2_len = length(c2);
    c3_len = length(c3); c4_len = length(c4);
    c5_len = length(c5); c6_len = length(c6);
    c7_len = length(c7); c8_len = length(c8);
    c9_len = length(c9); c10_len = length(c10);

    if co == 1
        c_med = median(c1);
        left = min(c1);
        right = max(c1);
        rows = r1; col = c1;

    elseif co == 2
        if c1_len>c2_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        end
        
    elseif co == 3
        if c1_len>c2_len & c1_len>c3_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        end

    elseif co == 4
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        end

   elseif co == 5
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len & c1_len>c5_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len & c2_len>c5_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len & c3_len>c5_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len & c4_len>c5_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        elseif c5_len>c1_len & c5_len>c2_len & c5_len>c3_len & c5_len>c4_len
            c_med = median(c5);
            left = min(c5);
            right = max(c5);
            rows = r5; col = c5;
        end

   elseif co == 6
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len & c1_len>c5_len & c1_len>c6_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len & c2_len>c5_len & c2_len>c6_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len & c3_len>c5_len & c3_len>c6_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len & c4_len>c5_len & c4_len>c6_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        elseif c5_len>c1_len & c5_len>c2_len & c5_len>c3_len & c5_len>c4_len& c5_len>c6_len
            c_med = median(c5);
            left = min(c5);
            right = max(c5);
            rows = r5; col = c5;
        elseif c6_len>c1_len & c6_len>c2_len & c6_len>c3_len & c6_len>c4_len& c6_len>c5_len
            c_med = median(c6);
            left = min(c6);
            right = max(c6);
            rows = r6; col = c6;
        end

   elseif co == 7
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len & c1_len>c5_len & c1_len>c6_len & c1_len>c7_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len & c2_len>c5_len & c2_len>c6_len & c2_len>c7_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len & c3_len>c5_len & c3_len>c6_len & c3_len>c7_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len & c4_len>c5_len & c4_len>c6_len & c4_len>c7_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        elseif c5_len>c1_len & c5_len>c2_len & c5_len>c3_len & c5_len>c4_len & c5_len>c6_len & c5_len>c7_len
            c_med = median(c5);
            left = min(c5);
            right = max(c5);
            rows = r5; col = c5;
        elseif c6_len>c1_len & c6_len>c2_len & c6_len>c3_len & c6_len>c4_len & c6_len>c5_len & c6_len>c7_len
            c_med = median(c6);
            left = min(c6);
            right = max(c6);
            rows = r6; col = c6;
        elseif c7_len>c1_len & c7_len>c2_len & c7_len>c3_len & c7_len>c4_len & c7_len>c5_len & c7_len>c6_len
            c_med = median(c7);
            left = min(c7);
            right = max(c7);
            rows = r7; col = c7;
        end

   elseif co == 8
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len & c1_len>c5_len & c1_len>c6_len & c1_len>c7_len & c1_len>c8_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len & c2_len>c5_len & c2_len>c6_len & c2_len>c7_len & c2_len>c8_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len & c3_len>c5_len & c3_len>c6_len & c3_len>c7_len & c3_len>c8_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len & c4_len>c5_len & c4_len>c6_len & c4_len>c7_len & c4_len>c8_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        elseif c5_len>c1_len & c5_len>c2_len & c5_len>c3_len & c5_len>c4_len & c5_len>c6_len & c5_len>c7_len & c5_len>c8_len
            c_med = median(c5);
            left = min(c5);
            right = max(c5);
            rows = r5; col = c5;
        elseif c6_len>c1_len & c6_len>c2_len & c6_len>c3_len & c6_len>c4_len & c6_len>c5_len & c6_len>c7_len & c6_len>c8_len
            c_med = median(c6);
            left = min(c6);
            right = max(c6);
            rows = r6; col = c6;
        elseif c7_len>c1_len & c7_len>c2_len & c7_len>c3_len & c7_len>c4_len & c7_len>c5_len & c7_len>c6_len & c7_len>c8_len
            c_med = median(c7);
            left = min(c7);
            right = max(c7);
            rows = r7; col = c7;
        elseif c8_len>c1_len & c8_len>c2_len & c8_len>c3_len & c8_len>c4_len & c8_len>c5_len & c8_len>c6_len & c8_len>c7_len
            c_med = median(c8);
            left = min(c8);
            right = max(c8);
            rows = r8; col = c8;
        end

   elseif co == 9
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len & c1_len>c5_len & c1_len>c6_len & c1_len>c7_len & c1_len>c8_len & c1_len>c9_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len & c2_len>c5_len & c2_len>c6_len & c2_len>c7_len & c2_len>c8_len & c2_len>c9_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len & c3_len>c5_len & c3_len>c6_len & c3_len>c7_len & c3_len>c8_len & c3_len>c9_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len & c4_len>c5_len & c4_len>c6_len & c4_len>c7_len & c4_len>c8_len & c4_len>c9_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        elseif c5_len>c1_len & c5_len>c2_len & c5_len>c3_len & c5_len>c4_len & c5_len>c6_len & c5_len>c7_len & c5_len>c8_len & c5_len>c9_len
            c_med = median(c5);
            left = min(c5);
            right = max(c5);
            rows = r5; col = c5;
        elseif c6_len>c1_len & c6_len>c2_len & c6_len>c3_len & c6_len>c4_len & c6_len>c5_len & c6_len>c7_len & c6_len>c8_len & c6_len>c9_len
            c_med = median(c6);
            left = min(c6);
            right = max(c6);
            rows = r6; col = c6;
        elseif c7_len>c1_len & c7_len>c2_len & c7_len>c3_len & c7_len>c4_len & c7_len>c5_len & c7_len>c6_len & c7_len>c8_len & c7_len>c9_len
            c_med = median(c7);
            left = min(c7);
            right = max(c7);
            rows = r7; col = c7;
        elseif c8_len>c1_len & c8_len>c2_len & c8_len>c3_len & c8_len>c4_len & c8_len>c5_len & c8_len>c6_len & c8_len>c7_len & c8_len>c9_len
            c_med = median(c8);
            left = min(c8);
            right = max(c8);
            rows = r8; col = c8;
        elseif c9_len>c1_len & c9_len>c2_len & c9_len>c3_len & c9_len>c4_len & c9_len>c5_len & c9_len>c6_len & c9_len>c7_len & c9_len>c8_len
            c_med = median(c9);
            left = min(c9);
            right = max(c9);
            rows = r9; col = c9;
        end

   elseif co == 10
        if c1_len>c2_len & c1_len>c3_len & c1_len>c4_len & c1_len>c5_len & c1_len>c6_len & c1_len>c7_len & c1_len>c8_len & c1_len>c9_len & c1_len>c10_len
            c_med = median(c1);
            left = min(c1);
            right = max(c1);
            rows = r1; col = c1;
        elseif c2_len>c1_len & c2_len>c3_len & c2_len>c4_len & c2_len>c5_len & c2_len>c6_len & c2_len>c7_len & c2_len>c8_len & c2_len>c9_len & c2_len>c10_len
            c_med = median(c2);
            left = min(c2);
            right = max(c2);
            rows = r2; col = c2;
        elseif c3_len>c1_len & c3_len>c2_len & c3_len>c4_len & c3_len>c5_len & c3_len>c6_len & c3_len>c7_len & c3_len>c8_len & c3_len>c9_len & c3_len>c10_len
            c_med = median(c3);
            left = min(c3);
            right = max(c3);
            rows = r3; col = c3;
        elseif c4_len>c1_len & c4_len>c2_len & c4_len>c3_len & c4_len>c5_len & c4_len>c6_len & c4_len>c7_len & c4_len>c8_len & c4_len>c9_len & c4_len>c10_len
            c_med = median(c4);
            left = min(c4);
            right = max(c4);
            rows = r4; col = c4;
        elseif c5_len>c1_len & c5_len>c2_len & c5_len>c3_len & c5_len>c4_len & c5_len>c6_len & c5_len>c7_len & c5_len>c8_len & c5_len>c9_len & c5_len>c10_len
            c_med = median(c5);
            left = min(c5);
            right = max(c5);
            rows = r5; col = c5;
        elseif c6_len>c1_len & c6_len>c2_len & c6_len>c3_len & c6_len>c4_len & c6_len>c5_len & c6_len>c7_len & c6_len>c8_len & c6_len>c9_len c6_len>c10_len
            c_med = median(c6);
            left = min(c6);
            right = max(c6);
            rows = r6; col = c6;
        elseif c7_len>c1_len & c7_len>c2_len & c7_len>c3_len & c7_len>c4_len & c7_len>c5_len & c7_len>c6_len & c7_len>c8_len & c7_len>c9_len & c7_len>c10_len
            c_med = median(c7);
            left = min(c7);
            right = max(c7);
            rows = r7; col = c7;
        elseif c8_len>c1_len & c8_len>c2_len & c8_len>c3_len & c8_len>c4_len & c8_len>c5_len & c8_len>c6_len & c8_len>c7_len & c8_len>c9_len & c8_len>c10_len
            c_med = median(c8);
            left = min(c8);
            right = max(c8);
            rows = r8; col = c8;
        elseif c9_len>c1_len & c9_len>c2_len & c9_len>c3_len & c9_len>c4_len & c9_len>c5_len & c9_len>c6_len & c9_len>c7_len & c9_len>c8_len & c9_len>c10_len
            c_med = median(c9);
            left = min(c9);
            right = max(c9);
            rows = r9; col = c9;
        elseif c10_len>c1_len & c10_len>c2_len & c10_len>c3_len & c10_len>c4_len & c10_len>c5_len & c10_len>c6_len & c10_len>c7_len & c10_len>c8_len & c10_len>c9_len
            c_med = median(c10);
            left = min(c10);
            right = max(c10);
            rows = r10; col = c10;
        end

    end

    roi = 0;

    %% creating the ROI from the significant labeled region
    for iii = 1:length(rows)
        roi(rows(iii), col(iii)) = 1;
    end
    imshow(roi)

    %% padding the bottom rows of the image as '0'
    for row_pad = max(rows)+1:299
        for fixed_col = left:right
            roi(row_pad, fixed_col) = 0;
        end
    end
imshow(roi)

range = right-left;
rect=[left,1,range,298];
I4 = imcrop(I3,rect);
imshow(I4)
roi_crop = imcrop(roi,rect);

imshow(roi_crop)

% subplot(1,3,1)
% I3 = imresize(I2,[299 299],'nearest');
I3_gray = rgb2gray(I4);
recov_img = ind2rgb(I3_gray, colormap);
imshow(recov_img)

% subplot(1,3,2)
roi_resize = imresize(roi_crop,[299 299],'nearest');
% imshow(roi_resize)

masked_img = times(recov_img, roi_crop);
% subplot(1,3,3)
imshow(masked_img)
roi_resize = imresize(masked_img,[299 299],'nearest');
imshow(roi_resize)

resized_images_path = 'C:\Users\Nadeem\Desktop\PaperWriting\scalograms binarized images\apnea_binar_img';
fname = sprintf('%d.png', n);
resized_images_folder = fullfile(resized_images_path, fname);
imwrite(roi_resize,resized_images_folder);
% else
%     jj = jj+1;
% end
end