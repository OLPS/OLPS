function [ ] = homeMenu( )
    % Display Home Menu Screen
    
    menuId = 1; % Home Menu
    displayMenu(menuId); % 
    
    % Read configuration
    load ../GUI/config/config.mat;   
    
    
    % Construct algorithm job data structure for algorithmAnalyser
    % Populate the datastructure with default values
    
    algorithmJob.algorithmId    = 1;
    algorithmJob.datasetId      = 1;
    AL                          = char(algorithmList);
    algorithmJob.algorithm      = AL(algorithmJob.algorithmId,:);
    DL                          = char(dataList);
    algorithmJob.dataset        = DL(algorithmJob.datasetId,:);
    algorithmJob.parameters     = cell2mat(defaultParameters(algorithmJob.algorithmId,:));
    
    prompt = 'Please enter your choice (1-5):';
    choice = input(prompt);
    switch(choice),
        case 1,
            % Algorithm Analyser
            algorithmAnalyserMenu(algorithmJob);          
        case 2,
            % Experimenter
            experimenterMenu;
        case 3,
            % Configuration
            configurationMenu;
        case 4,
            % About OLPS
            disp('Opening README file about OLPS...');
            edit ../README.md;
            homeMenu;
        case 5, 
            disp('Exiting OLPS');
            %cd ..;
        otherwise,
            disp('ERROR: Please enter a valid input');
            homeMenu;
    end
end