function playMovie(movieName, cycles, fps)
% Play MATLAB movie file
% movieName - name of movie file
% cycles - number of cycles to be played
% fps - frames per secont

fig = figure;
set(fig, 'Units','normalized')
set(fig,'position',[0 0 1 1])

movie(movieName, cycles, fps)

end