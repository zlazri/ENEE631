function panoramaImg = createPanoramaN(imgs)

% imgs is a cell full of the images used to create the panorama (in order
% of how we wish for them to be displayed)

for i = 1:length(imgs)
    imgs{i} = imresize(imgs{i}, [512, 512]);
end

for i = 1:length(imgs)-1
    figure
    subplot(1,2,1)
    imshow(imgs{i})
    subplot(1,2,2)
    imshow(imgs{i+1})
    snapnow
end

% Extract Critical Points
Descs = cell(1,length(imgs));
pts = cell(1, length(imgs));
for i = 1:length(imgs)
    [Pts, Desc] = SIFT(imgs{i}, 6, 21, 4);
    Descs{i} = Desc;
    pts{i} = [Pts(:,2) Pts(:,3)];
end

% Match Critical Points
matches = cell(1, length(imgs)-1);
middleidx = ceil(length(pts)/2);
for i = 1:middleidx-1
    matches{i} = SIFTPtMatching(Descs{i+1}, Descs{i});
end
% match towards the middle image so that we can make the middle image the
% coordiate system to which all other image's coordinates are mapped.
for i = middleidx:length(matches)
    matches{i} = SIFTPtMatching(Descs{i}, Descs{i+1});
end

% for i = 1:length(matches)
%     figure(i)
%     subplot(1,2,1);
%     hold on
%     label = 1:length(matches{i});
%     plot(pts{i}(matches{i}(:,1),2), pts{i}(matches{i}(:,1),1), 'og');
%     y = pts{i}(matches{i}(:,1),2);
%     x = pts{i}(matches{i}(:,1),1);
%     for j = 1:length(label)
%         text(y(j)+5,x(j)+5,num2str(label(j)));
%     end
%     hold off
%     
%     subplot(1,2,2)
%     hold on
%     label = 1:length(matches{i});
%     plot(pts{i+1}(matches{i}(:,2),2), pts{i+1}(matches{i}(:,2),1), 'og');
%     y = pts{i+1}(matches{i}(:,2),2);
%     x = pts{i+1}(matches{i}(:,2),1);
%     for j = 1:length(label)
%         text(y(j)+5,x(j)+5,num2str(label(j)));
%     end
%     hold off
% end

% Rule out outliers and keep inliers
new_matches = cell(1,length(pts)-1);
for i = 1:middleidx-1
    new_matches{i} = RANSAC_alg(pts{i+1}, pts{i}, matches{i}, 6, 3);
end
for i = middleidx:length(matches)
    new_matches{i} =  RANSAC_alg(pts{i}, pts{i+1}, matches{i}, 6, 3);
end

% Allow User to manually add more matches
remain_matches = cell(1, length(matches));
for i = 1:length(matches)
    current_matches = matches{i};
    current_new_matches = new_matches{i};
    idxs = find(~ismember(current_matches, current_new_matches, 'rows'));
    remain_matches{i} = current_matches(idxs,:);
%     G = Keypoint_manager(remain_matches, {imgs{i+1}, imgs{i}}, {pts{i+1}, pts{i}});
%     new_matches{i} = [current_new_matches; G];
end

G = Keypoint_manager(remain_matches, imgs, pts);
for i = 1:length(matches)
    new_matches{i} = [new_matches{i}; G{i}];
end

% for i = 1:length(new_matches)
%     figure(i)
%     subplot(1,2,1);
%     hold on
%     label = 1:length(new_matches{i});
%     plot(pts{i}(new_matches{i}(:,1),2), pts{i}(new_matches{i}(:,1),1), 'or');
%     y = pts{i}(new_matches{i}(:,1),2);
%     x = pts{i}(new_matches{i}(:,1),1);
%     for j = 1:length(label)
%         text(y(j)+5,x(j)+5,num2str(label(j)));
%     end
%     hold off
%     
%     subplot(1,2,2)
%     hold on
%     label = 1:length(new_matches{i});
%     plot(pts{i+1}(new_matches{i}(:,2),2), pts{i+1}(new_matches{i}(:,2),1), 'or');
%     y = pts{i+1}(new_matches{i}(:,2),2);
%     x = pts{i+1}(new_matches{i}(:,2),1);
%     for j = 1:length(label)
%         text(y(j)+5,x(j)+5,num2str(label(j)));
%     end
%     hold off
% end

% Create homography
H = cell(1, length(new_matches));
% Homography matrix from the image preceding the middle to the middle image
if middleidx-1 > 0
    H{middleidx-1} = homography(pts{middleidx},pts{middleidx-1}, new_matches{middleidx-1});
end
% Homography matrix from the image succeeding the middle to the middle
% image
H{middleidx} = homography(pts{middleidx},pts{middleidx+1}, new_matches{middleidx});
if length(H) == 3
    H{middleidx+1} = updated_homography(pts{middleidx+1},pts{middleidx+2}, new_matches{middleidx+1}, H{2});
elseif length(H) > 3
    for i = middleidx-2:-1:1
        H{i} = updated_homography(pts{i+1}, pts{i}, new_matches{i}, H{i+1});
    end
    for i = middleidx+1:length(H)
        H{i} = updated_homography(pts{i}, pts{i+1}, new_matches{i}, H{i-1});
    end
end

% Generate Panorama
panoramaImg = panorama_generatorN(imgs, H);  %CHANGE BACK TO panorama_generator()

end
