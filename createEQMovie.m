function [myVideo] = createEQMovie(movieFile, Name, FPS, Quality)
% ----------------------------------------------------------------------- %
% Input:                                                                  %
% movieFile - MATLAB movie file composed of captured figures, generated   %
% from EQMovie.                                                           %
% Name - Name of output file                                              %
% FPS - video frames per second                                           %
% Quality - percentage of max. video quality                              %
%                                                                         %
% Output:                                                                 %
% myVideo - final .avi file                                               %
% ----------------------------------------------------------------------- %

% 1. Create a VideoWriter object by calling the VideoWriter function.
myVideo = VideoWriter(Name);

% 2. Optionally, adjust the frame rate (number of frames to display per second) or the quality setting (a percentage from 0 through 100).
myVideo.FrameRate = FPS;  % Default 30
myVideo.Quality = Quality;    % Default 75

% 3. Open the file:
open(myVideo);

% 4. Write frames, still images, or an existing MATLAB movie to the file by calling writeVideo. For example, suppose that you have created a MATLAB movie called myMovie. Write your movie to a file:
writeVideo(myVideo, movieFile)

% 5. Close the file:
close(myVideo);

end