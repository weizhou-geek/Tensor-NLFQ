function [percentile_data] = percentile_data(data,percet,direction)

if direction == 0
    descend_data = sort(data(:),'descend');
    len_data = length(descend_data);
    percentile_data = mean(descend_data(1:ceil(len_data*percet)));
else
    ascend_data = sort(data(:),'ascend');
    len_data = length(ascend_data);
    percentile_data = mean(ascend_data(1:ceil(len_data*percet)));
end


