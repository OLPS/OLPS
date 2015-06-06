function [ ] = experimenterMenu( )
    % Display Home Menu Screen
    
    % Initialize algorithm job for multiple algorithms
    job.data = '';
    % ...
    
    
    menuId = 3; % Experimenter Menu
    displayMenu(menuId); % 
    
    prompt = 'Please enter your choice (1-5):';
    choice = input(prompt);
    switch(choice),
        case 1,
            % Select Algorithms
            algorithmAnalyserMenu; 
        case 2,
            % Select Dataset
        case 3,
            % View Current Job
        case 4,  
            % START EXECUTION
            
            % STEP 1: Construct input
            
            % STEP 2: Start Execution using "eval"
            
            
        case 5,
            disp('Exiting Experimenter --> to Home');
            homeMenu;
        otherwise,
            disp('ERROR: Please enter a valid input');
            experimenterMenu;
    end
end