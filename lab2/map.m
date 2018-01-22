function ret = map(image_l, image_r, x_temp, y_temp)
% Fuction to calculate disparity map

% calculate half size of template
dim_x = floor(x_temp/2);
dim_y = floor(y_temp/2);

% image_l and image_r must have the same size
[x, y] = size(image_l);

%initialization
ret = ones(x - x_temp + 1, y - y_temp + 1);

for i = 1+dim_x : x-dim_x
    for j = 1+dim_y : y-dim_y
        cur_r = image_l(i-dim_x: i+dim_x, j-dim_y: j+dim_y);
        cur_l = rot90(cur_r, 2);
        min_coor = j; 
        min_diff = inf;
        
        % search for simmilar pattern in right image
        % limit search to 15 pixel to the left
        for k = max(1+dim_y , j-14) : j
            T = image_r(i-dim_x: i+dim_x, k-dim_y: k+dim_y);
            cur_r = rot90(T, 2);
            
            % Calculate ssd and update minimum diff
            conv_1 = conv2(T, cur_r);
            conv_2 = conv2(T, cur_l);
            ssd = conv_1(x_temp, y_temp) - 2 * conv_2(x_temp, y_temp);
            if ssd < min_diff
                min_diff = ssd;
                min_coor = k;
            end
        end
        ret(i - dim_x, j - dim_y) = j - min_coor;
    end
end