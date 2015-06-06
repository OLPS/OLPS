function [ algorithmJob ] = jobInit()
% Construct an instance of an algorithm analyser job

    % Read configuration
    load ../GUI/config/config.mat;   
    algorithmJob.algorithmId    = 1;
    algorithmJob.datasetId      = 1;
    AL                          = char(algorithmList);
    algorithmJob.algorithm      = AL(algorithmJob.algorithmId,:);
    DL                          = char(dataList);
    algorithmJob.dataset        = DL(algorithmJob.datasetId,:);
    algorithmJob.parameters     = cell2mat(defaultParameters(algorithmJob.algorithmId,:));
end