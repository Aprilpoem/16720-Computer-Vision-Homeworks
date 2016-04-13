function overlap = CheckOverlap(Rect1, Rect2)
% Function to check overlaps of two rectangles
% Rect1, Rect2: Rectangles in the [x, y, w, h] format, where x and y are
% the coordinates of the top left corner

% Calculate the center points of the rectangles
cx1 = Rect1(1) + Rect1(3) / 2;
cy1 = Rect1(2) + Rect1(4) / 2;
cx2 = Rect2(1) + Rect2(3) / 2;
cy2 = Rect2(2) + Rect2(4) / 2;

% Check if the rectangles overlap
if abs(cx1 - cx2) < (Rect1(3) + Rect2(3)) / 2 && ...
        abs(cy1 - cy2) < (Rect1(4) + Rect2(4)) / 2
    overlap = 1;
else
    overlap = 0;
end
 
end
