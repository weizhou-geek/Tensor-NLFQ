function Mask = Generate_LF_Stacks_Mask(AngularDimes)

if length(AngularDimes)~= 2
    error('ERROR: Data Dimension is worng!');
end
Ax = AngularDimes(1);
Ay = AngularDimes(2);

%   horizontal mask
for x = 1:Ax
    temp_matrix = zeros(Ax,Ay);
    temp_matrix(x,:) = temp_matrix(x,:) + 1;
    horizontal_mask{x,1} = temp_matrix;
end

%   vertical mask
for y = 1:Ay
    temp_matrix = zeros(Ax,Ay);
    temp_matrix(:,y) = temp_matrix(:,y) + 1;
    vertical_mask{y,1} = temp_matrix;
end

%   left digonal mask
cnt = 1;
for y = 1:Ay
    temp_matrix = zeros(Ax,Ay);
    curr_col = y;
    curr_row = 1;
    while curr_col~=Ay+1
        temp_matrix(curr_row,curr_col) = temp_matrix(curr_row,curr_col)+1;
        curr_row = curr_row + 1;
        curr_col = curr_col + 1;
    end
    left_digonal_mask{cnt,1} =  temp_matrix;
    cnt = cnt + 1;
end
for x = 2:Ax
    temp_matrix = zeros(Ax,Ay);
    curr_row = x; curr_col = 1;
    while curr_row~=Ax+1
        temp_matrix(curr_row,curr_col) = temp_matrix(curr_row,curr_col)+1;
        curr_row = curr_row + 1;
        curr_col = curr_col + 1;
    end
    left_digonal_mask{cnt,1} =  temp_matrix;
    cnt = cnt + 1;
end

%   right digonal mask
for id  = 2:Ax+Ay
    temp_matrix = zeros(Ax,Ay);
    for x = 1:Ax
        for y = 1:Ay
            if x+y == id
                temp_matrix(x,y) = temp_matrix(x,y) + 1;
            end
        end
    end
    right_digonal_mask{id-1,1} = temp_matrix;
end

Mask = {horizontal_mask,vertical_mask,left_digonal_mask,right_digonal_mask};
