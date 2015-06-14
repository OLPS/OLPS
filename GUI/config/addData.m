function [ ] = addData( dataFileName, dataDescriptionName, newDataFrequency, configFile )

    load(configFile);
    index = length(dataFrequency);
    index = index+1;
    dataList{index} = dataDescriptionName;
    dataName{index} = dataFileName;
    dataFrequency(index) = newDataFrequency;
    
    save(configFile, 'algorithmList', 'algorithmName', 'algorithmParameters', 'dataFrequency', 'dataList', 'dataName', 'defaultParameters', 'windowRisk');
end