% if mutlitple features are corresponding to one same feature in the second
% image, this is called many-to-one; if one feature in the first image is
% corresponding to mutliple feautres in the 2nd image, this is called
% one-to-many. Both cases should be removed somehow, in order to avoid the
% case that features are replicated positions or has diverse matching 


function [filtered_outmatches] = Chen_DuplicateMatchFiletering(input_matches)
% filter out one to many
a = input_matches(1,:);
[c1,ia1,ic1] = unique(a);
matches_filter_first = input_matches(:,ia1);

b = matches_filter_first(2,:);
[c2,ia2,ic2] = unique(b);
filtered_outmatches = matches_filter_first(:,ia2);

end
