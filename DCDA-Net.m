clear
close all
clc

for ii = 1:10
reset(gpuDevice())
c_matrix = [];
accuracy = [];
Results=[];

d = 'E:\Paper_1\Experiments\R_detection_technique\testing_scal\attention_signal\ref_experiments';
fold_num = strcat(d, '\fold_', num2str(ii));

imdsTrain = imageDatastore(strcat(fold_num,'\training'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imdsValidation = imageDatastore(strcat(fold_num, '\testing'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%% Layers
lgraph = layerGraph();
tempLayers = [
    imageInputLayer([299 299 3],"Name","imageinput","Normalization","rescale-symmetric")
    convolution2dLayer([5 1],16,"Name","sep_conv_1")
    convolution2dLayer([1 5],16,"Name","sep_conv_2")
    batchNormalizationLayer("Name","batchnorm_1")
    reluLayer("Name","relu_1")
    convolution2dLayer([3 3],32,"Name","strided_conv_1","Stride",[2 2])
    batchNormalizationLayer("Name","batchnorm_8")
    reluLayer("Name","relu_8")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([1 1],32,"Name","conv_8","Padding","same")
    groupedConvolution2dLayer([1 1],1,"channel-wise","Name","D_all_1x1_3")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    maxPooling2dLayer([3 3],"Name","maxpool_1","Padding","same")
    convolution2dLayer([1 1],32,"Name","conv_4","Padding","same")
    batchNormalizationLayer("Name","batchnorm_4")
    reluLayer("Name","relu_4")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = groupedConvolution2dLayer([3 3],4,8,"Name","Dgroup_3x3_2","Padding","same");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = groupedConvolution2dLayer([1 1],4,8,"Name","Dgroup_1_1_3","Padding","same");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_3");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([1 1],48,"Name","conv_2","Padding","same")
    convolution2dLayer([5 5],48,"Name","conv_3","Padding","same")
    batchNormalizationLayer("Name","batchnorm_3")
    reluLayer("Name","relu_3")
    groupedConvolution2dLayer([1 1],1,"channel-wise","Name","D_all_1x1_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = groupedConvolution2dLayer([5 5],4,12,"Name","Dgroup_5x5","Padding","same");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = groupedConvolution2dLayer([1 1],4,12,"Name","Dgroup_1_1_2","Padding","same");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([1 1],64,"Name","conv_1","Padding","same")
    convolution2dLayer([3 3],64,"Name","conv_9","Padding","same")
    batchNormalizationLayer("Name","batchnorm_2")
    reluLayer("Name","relu_2")
    groupedConvolution2dLayer([1 1],1,"channel-wise","Name","D_all_1x1_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = groupedConvolution2dLayer([1 1],4,16,"Name","Dgroup_1_1_1","Padding","same");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = groupedConvolution2dLayer([3 3],4,16,"Name","Dgroup_3x3_1","Padding","same");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(4,"Name","depthcat_1")
    maxPooling2dLayer([3 3],"Name","maxpool_2","Stride",[2 2])
    convolution2dLayer([1 1],88,"Name","conv_5","Padding","same")
    batchNormalizationLayer("Name","batchnorm_5")
    reluLayer("Name","relu_5")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([1 1],22,"Name","conv_6","Padding","same")
    batchNormalizationLayer("Name","batchnorm_6")
    reluLayer("Name","relu_6")
    convolution2dLayer([1 1],1,"Name","conv_7","Padding","same")
    batchNormalizationLayer("Name","batchnorm_7")
    reluLayer("Name","relu_7")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","depthcat_2")
    convolution2dLayer([5 1],256,"Name","sep_conv_3")
    convolution2dLayer([1 5],256,"Name","sep_conv_4")
    batchNormalizationLayer("Name","batchnorm_9")
    reluLayer("Name","relu_11")
    convolution2dLayer([3 3],512,"Name","strided_conv_2","Stride",[2 2])
    batchNormalizationLayer("Name","batchnorm_10")
    reluLayer("Name","relu_12")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    globalAveragePooling2dLayer("Name","gapool_1")
    fullyConnectedLayer(256,"Name","fc_1")
    reluLayer("Name","relu_9")
    fullyConnectedLayer(512,"Name","fc_2")
    sigmoidLayer("Name","sigmoid")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","depthcat_3")
    dropoutLayer(0.1,"Name","dropout")
    globalAveragePooling2dLayer("Name","gapool_2")
    fullyConnectedLayer(256,"Name","fc_3")
    reluLayer("Name","relu_10")
    fullyConnectedLayer(2,"Name","fc_4")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

%% connections
lgraph = connectLayers(lgraph,"relu_8","conv_8");
lgraph = connectLayers(lgraph,"relu_8","maxpool_1");
lgraph = connectLayers(lgraph,"relu_8","conv_2");
lgraph = connectLayers(lgraph,"relu_8","conv_1");
lgraph = connectLayers(lgraph,"D_all_1x1_3","Dgroup_3x3_2");
lgraph = connectLayers(lgraph,"D_all_1x1_3","Dgroup_1_1_3");
lgraph = connectLayers(lgraph,"Dgroup_3x3_2","addition_3/in1");
lgraph = connectLayers(lgraph,"Dgroup_1_1_3","addition_3/in2");
lgraph = connectLayers(lgraph,"addition_3","depthcat_1/in4");
lgraph = connectLayers(lgraph,"relu_4","depthcat_1/in3");
lgraph = connectLayers(lgraph,"D_all_1x1_2","Dgroup_5x5");
lgraph = connectLayers(lgraph,"D_all_1x1_2","Dgroup_1_1_2");
lgraph = connectLayers(lgraph,"Dgroup_5x5","addition_2/in1");
lgraph = connectLayers(lgraph,"Dgroup_1_1_2","addition_2/in2");
lgraph = connectLayers(lgraph,"addition_2","depthcat_1/in1");
lgraph = connectLayers(lgraph,"D_all_1x1_1","Dgroup_1_1_1");
lgraph = connectLayers(lgraph,"D_all_1x1_1","Dgroup_3x3_1");
lgraph = connectLayers(lgraph,"Dgroup_1_1_1","addition_1/in2");
lgraph = connectLayers(lgraph,"Dgroup_3x3_1","addition_1/in1");
lgraph = connectLayers(lgraph,"addition_1","depthcat_1/in2");
lgraph = connectLayers(lgraph,"relu_5","conv_6");
lgraph = connectLayers(lgraph,"relu_5","multiplication_1/in2");
lgraph = connectLayers(lgraph,"relu_5","depthcat_2/in2");
lgraph = connectLayers(lgraph,"relu_7","multiplication_1/in1");
lgraph = connectLayers(lgraph,"multiplication_1","depthcat_2/in1");
lgraph = connectLayers(lgraph,"relu_12","gapool_1");
lgraph = connectLayers(lgraph,"relu_12","multiplication_2/in2");
lgraph = connectLayers(lgraph,"relu_12","depthcat_3/in2");
lgraph = connectLayers(lgraph,"sigmoid","multiplication_2/in1");
lgraph = connectLayers(lgraph,"multiplication_2","depthcat_3/in1");

             %% options
             
                options = trainingOptions('adam',...
                'InitialLearnRate',0.001, 'MiniBatchSize',16,...
                'MaxEpochs',30,...
                'Shuffle','every-epoch', ...
                'Plots','training-progress');
                
            % data augmentation
                imageAugmenter = imageDataAugmenter( ...
                'RandRotation',[-8 8], ...
                'RandXShear',[-5 5], ...
                'RandXTranslation',[-30 30], ...
                'RandXReflection', 1);
            
            
            %% results
            imdsTrain_Aug = augmentedImageDatastore([299,299,3], imdsTrain,'DataAugmentation',imageAugmenter);
%             
    
            [net,info] = trainNetwork(imdsTrain_Aug,lgraph,options);

            % save network/info
            trained_custom_net = net;
            save trained_custom_net
            trained_custom_net_info = info;
            save trained_custom_net_info

            [pred,probs] = classify(net,imdsValidation);
            [c_matrix,Result]= confusionmat(imdsValidation.Labels,pred);

            accuracy = mean(pred == imdsValidation.Labels)*100;

            CMat = c_matrix;
            tp=CMat(1,1);
            fp=CMat(2,1);
            fn=CMat(1,2);
            tn=CMat(2,2);

            Pre1 = tp./(tp+fp);
            Rec1 = tp./(tp+fn);
            F1_Score1 = (2*Pre1*Rec1)./(Pre1+Rec1);
            specificity = tn./(tn+fp);
end