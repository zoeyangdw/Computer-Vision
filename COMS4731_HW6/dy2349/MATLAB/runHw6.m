function runHw6(varargin)
% runHw6 is the "main" interface that lets you execute all the 
% challenges in homework 6. It lists a set of 
% functions corresponding to the problems that need to be solved.
%
% Note that this file also serves as the specifications for the functions 
% you are asked to implement. In some cases, your submissions will be autograded. 
% Thus, it is critical that you adhere to all the specified function signatures.
%
% Before your submssion, make sure you can run runHw6('all') 
% without any error.
%
% Usage:
% runHw6                       : list all the registered functions
% runHw6('function_name')      : execute a specific test
% runHw6('all')                : execute all the registered functions

% Settings to make sure images are displayed without borders.
orig_imsetting = iptgetpref('ImshowBorder');
iptsetpref('ImshowBorder', 'tight');
temp1 = onCleanup(@()iptsetpref('ImshowBorder', orig_imsetting));

fun_handles = {@honesty,...
    @debug1a, @challenge1a,...
    @challenge2a, @challenge2b};

% Call test harness
runTests(varargin, fun_handles);

%--------------------------------------------------------------------------
% Academic Honesty Policy
%--------------------------------------------------------------------------
%%
function honesty()
% Type your full name and uni (both in string) to state your agreement 
% to the Code of Academic Integrity.
signAcademicHonestyPolicy('Danwen Yang', 'dy2349');

%--------------------------------------------------------------------------
% Tests for Challenge 1: Optical flow using template matching
%--------------------------------------------------------------------------

%%
function debug1a()
img1 = imread('simple1.png');
img2 = imread('simple2.png');

search_half_window_size = 15;   % Half size of the search window
template_half_window_size = 4; % Half size of the template window
[m, n] = size(img1);
grid_MN = [m/16, n/16];              % Number of rows and cols in the grid

result = computeFlow(img1, img2, search_half_window_size, template_half_window_size, grid_MN);
imwrite(result, 'simpleresult.png');

%%
function challenge1a()
img_list = {'flow1.png', 'flow2.png', 'flow3.png', 'flow4.png', 'flow5.png'};
for i = 1:length(img_list)
    img_stack{i} = imread(img_list{i});
end

search_half_window_size = 24;   % Half size of the search window
template_half_window_size = 12; % Half size of the template window 
[m,n] = size(img_stack{1});
grid_MN = [m/16, n/16];              % Number of rows and cols in the grid

for i = 2:length(img_stack)
    result = computeFlow(img_stack{i-1}, img_stack{i},...
        search_half_window_size, template_half_window_size, grid_MN);
    imwrite(result, ['result' num2str(i-1) '_' num2str(i) '.png']);
end
%--------------------------------------------------------------------------
% Tests for Challenge 2: Tracking with color histogram template
%--------------------------------------------------------------------------

%%
function challenge2a
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'walking_person';
data_params.out_dir = 'walking_person_result';
data_params.frame_ids = [1:250];
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% ****** IMPORTANT ******
% In your submission, replace the call to "chooseTarget" with actual parameters
% to specify the target of interest
%tracking_params.rect = chooseTarget(data_params);
% tracking_params.rect = [xmin ymin width height];
tracking_params.rect = [190 60 35 125];

% Half size of the search window
%tracking_params.search_half_window_size = [round(tracking_params.rect(3)*0.1), round(tracking_params.rect(4)*0.15)];
tracking_params.search_half_window_size = [7, 7];
% Number of bins in the color histogram
tracking_params.bin_n = 128;                    

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params);

%%
function challenge2b
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'rolling_ball';
data_params.out_dir = 'rolling_ball_result';
data_params.frame_ids = [1:20];
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% ****** IMPORTANT ******
% In your submission, replace the call to "chooseTarget" with actual parameters
% to specify the target of interest
%tracking_params.rect = chooseTarget(data_params);
% tracking_params.rect = [xmin ymin width height];
tracking_params.rect = [157 130 40 42];
img = imread(fullfile(data_params.data_dir,...
    data_params.genFname(data_params.frame_ids(1))));
res = drawBox(img, tracking_params.rect, [0 0 255], 1);
    imshow(res);
% Half size of the search window
% tracking_params.search_half_window_size = [round(tracking_params.rect(3)*0.26), round(tracking_params.rect(4)*0.26)];
tracking_params.search_half_window_size = [10, 11];
% Number of bins in the color histogram
 tracking_params.bin_n = 8;           

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params);


%%
function rect = chooseTarget(data_params)
% chooseTarget displays an image and asks the user to drag a rectangle
% around a tracking target
% 
% arguments:
% data_params: a structure contains data parameters
% rect: [xmin ymin width height]

% Reading the first frame from the focal stack
img = imread(fullfile(data_params.data_dir,...
    data_params.genFname(data_params.frame_ids(1))));

% Pick an initial tracking location
imshow(img);
disp('===========');
disp('Drag a rectangle around the tracking target: ');
h = imrect;
rect = round(h.getPosition);

% To make things easier, let's make the height and width all odd
if mod(rect(3), 2) == 0, rect(3) = rect(3) + 1; end
if mod(rect(4), 2) == 0, rect(4) = rect(4) + 1; end
str = mat2str(rect);
disp(['[xmin ymin width height]  = ' str]);
disp('===========');
