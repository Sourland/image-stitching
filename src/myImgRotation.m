function rotImg = myImgRotation(img, angle)
%MYIMGROTATION Rotates an image in a certain angle
%   @param img the image to be rotated
%   @param angle the angle to rotate the image

    if angle == 0
        rotImg = img;
        return
    end
    
    %Find the needed image size for the rotation and create new image
    [X, Y, ~] = size(img); % X for rows, Y for columns
    R_pad = [cosd(angle) sind(angle); ...
             sind(angle) cosd(angle)];
    padSize = abs(R_pad)*[X;Y];
    rotImg = uint8(zeros(floor(padSize(1)), floor(padSize(2)), 3));
    [newX, newY, ~] = size(rotImg);
    
    %Start Coloring
    for i = 1:newX
        for j = 1:newY
            [x,y] = coordTransform(i, j, angle, newX, newY, X, Y);
            if y < 1 || y > Y || x < 1 || x > X  
                continue
            else
                rotImg(i, j,:) = getColor(img, x, y, X, Y, 'RGB', 'Rotate');
            end
        end
    end
end
function [x,y] = coordTransform(i, j, angle, newX, newY, X, Y)
    midX = floor(newX/2);
    midY = floor(newY/2);
    x0 = floor(X/2);
    y0 = floor(Y/2);
    R = [cosd(angle) sind(angle) 0; ...
        -sind(angle) cosd(angle) 0; ...
        0 0 1];
    T1 = [1 0 x0;...
          0 1 y0;...
          0 0 1];
    T2= [1 0 -midX;...
         0 1 -midY;...
         0 0 1];

    oldPixelPos = T1*R*T2*[i;j;1];
    x = floor(oldPixelPos(1));
    y = floor(oldPixelPos(2));
end

