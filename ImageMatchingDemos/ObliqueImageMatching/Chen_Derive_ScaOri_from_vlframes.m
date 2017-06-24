% this function converts frames derived from vl_covdet (with DoG and
% EstimateOrientation) to a standard form of [x, y, scale, orientation)
% input_frame with form of [x, y, A(:)]
function [frame_out] = Chen_Derive_ScaOri_from_vlframes(input_frame)
scale = sqrt(input_frame(3,:).^2 + input_frame(4,:).^2);
cos_theta = input_frame(3,:)./scale;
sin_theta = input_frame(4,:)./scale;
theta = atan2(sin_theta,cos_theta);
frame_out(1:2,:) = input_frame(1:2,:);
frame_out(3,:) = scale;
frame_out(4,:) = theta;
end