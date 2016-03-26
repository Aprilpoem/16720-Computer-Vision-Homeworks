function tl_detect_script

load('template_images_pos.mat');
load('template_images_neg.mat');

template = tl_pos(template_images_pos);
[x,y,score] = detect(Itest,template,ndet);
draw_detection();


template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score] = detect(Itest,template,ndet);
draw_detection();

template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,score] = detect(Itest,template,ndet);
draw_detection();

det_res = multiscale_detect(Itest, template, ndet);
draw_detection();

end

function draw_detection
% please complete this function to show the detection results

end