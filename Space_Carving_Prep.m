clear
clc
data = jsondecode(fileread("transforms.json"));

[paths, sorted] = sortrows(cell2mat(split([data.frames.file_path],".jpg")));
sil_paths = string(paths) + "s.jpg";
img_paths = string(paths) + ".jpg";

rt = readlines("colmap_text/images.txt");
rt = rt(5:2:end-1);
str = split(rt);
rt = sortrows(str2double(str));
counter = 1
for i = 1:length(rt)
    %if rt(i,1)==(92) || rt(i,1)==(93) || rt(i,1)==(94)
    %    continue
    %end
    images{i} = (imread(img_paths(i)));
    sil = sum(imread(sil_paths(i)),3);
    sil_images{i} = rot90(boolean(ceil(sil/max(sil,[],"all"))));
    E{i} = data.frames(sorted(i)).transform_matrix(1:3,:);
    K{i} = [data.fl_x, 0, data.cx; 0, data.fl_y, data.cy; 0, 0, 1];

    Qw = rt(i,2);
    Qx = rt(i,3);
    Qy = rt(i,4);
    Qz = rt(i,5);
    Tx = rt(i,6);
    Ty = rt(i,7);
    Tz = rt(i,8);

    Q{i} = [Qw, Qx, Qy, Qz];
    %R{i} = quat2rotm(Q{i});

    %T{i} = [Tx;Ty;Tz];
    R{i} = E{i}(1:3,1:3);
    T{i} = E{i}(1:3,4);

    P{i} = K{i}*[R{i} T{i}];

    frames(counter).image = images{i};
    frames(counter).P = P{i};
    frames(counter).K = K{i};
    frames(counter).R = R{i};
    frames(counter).T = T{i};
    frames(counter).silhouette = sil_images{i};
    frames(counter).trueSilhouette = sil_images{i};
    counter = counter + 1;
end