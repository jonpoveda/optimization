function [animated_file] = animate_images(folder)
  % Convert PNG images from a folder into an animated GIF
  
  images = dir(fullfile(folder, '*.png'));
  animated_file = fullfile(folder, 'animated.gif');
  
  for n=1:length(images)
    filename = fullfile(folder, images(n).name);
    im = imread(filename);
    [imind,cm] = rgb2ind(im,256);

    if n == 1
      imwrite(imind,cm, animated_file, 'gif', 'Loopcount', inf);
    else
      imwrite(imind,cm, animated_file, 'gif', 'WriteMode','append');
    end
  end
end
