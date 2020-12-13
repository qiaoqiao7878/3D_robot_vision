function [matchedPoints1, matchedPoints2] = feature_match(image1,image2,detector,descriptor)

if (detector == 'FAST')
    detect_feature1 = detectFASTFeatures(image1,'MinContrast', 0.08);
    detect_feature2 = detectFASTFeatures(image2,'MinContrast', 0.08);
else
    detect_feature1 = detectSURFFeatures(image1);
    detect_feature2 = detectSURFFeatures(image2);
end

if (descriptor == 'BRISK')
    [features1,validPoints1] = extractFeatures(image1,detect_feature1,'method','BRISK');
    [features2,validPoints2] = extractFeatures(image2,detect_feature2,'method','BRISK');
else
    [features1,validPoints1] = extractFeatures(image1,detect_feature1,'method','SURF');
    [features2,validPoints2] = extractFeatures(image2,detect_feature2,'method','SURF');
end

indexPairs = matchFeatures(features1,features2);
matchedPoints1 = validPoints1(indexPairs(:,1),:);
matchedPoints2 = validPoints2(indexPairs(:,2),:);

end