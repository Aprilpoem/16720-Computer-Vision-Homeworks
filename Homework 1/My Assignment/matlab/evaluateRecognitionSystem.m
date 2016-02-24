function evaluateRecognitionSystem

%% Load train and test data
load('../dat/traintest.mat');

%% Initialize
% Initialize the confusion matrix
C = zeros(length(mapping));

% Number of test images
N_train = length(test_imagenames);

%% Calculate train features
for i = 1 : N_train
    % Guess the classification of the current image
    testfile = ['../dat/', test_imagenames{1, i}];
    fprintf('Guessing classification of %s\n', testfile);
    guess = find(strcmp(guessImage(testfile), mapping));
    
    % Update the confusion matrix
    C(test_labels(i), guess) = C(test_labels(i), guess) + 1;

    % Tell me the correct classification if something goes wrong
    if test_labels(i) ~= guess
        fprintf('Failed to correctly classify as %s\n', mapping{1, test_labels(i)});
        %pause;
    end

end

fprintf('Accuracy for classification = %0.2f%%\n', 100 * trace(C) / sum(C(:)));

fprintf('Confusion matrix: \n');
disp(C);