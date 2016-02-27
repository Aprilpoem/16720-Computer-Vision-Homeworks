function [u, v] = LucasKanadeWithTemplateCorrection(It, It1, rect, I0, rect0)

% Initialize parameters
epsil = 2;  % The threshold for correcting vs not correcting the template

% Calculate new position using the template from previous frame
[delta_u_n, delta_v_n] = LucasKanade(It, It1, rect);
rect_n = rect + [delta_u_n, delta_v_n, delta_u_n, delta_v_n];

% Calculate new position using the template from the first frame
[u_star, v_star] = LucasKanadeWithInitialValue(I0, It1, rect0, ...
    (rect_n(1 : 2) - rect0(1 : 2))' );

% Update the outputs
u_star = u_star - (rect(1) - rect0(1));
v_star = v_star - (rect(2) - rect0(2));

if norm([u_star, v_star] - [delta_u_n, delta_v_n]) <= epsil
    u = u_star;
    v = v_star;
else
    u = delta_u_n;
    v = delta_v_n;
end

end