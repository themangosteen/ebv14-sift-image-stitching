function [ stitchedImage ] = main( impath1, impath2 )
% input: impath1, impath2 ... paths to images (JPG or PNG)
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images 
imA = im2double(imread('../pictures/B1.jpg'));
imB = im2double(imread('../pictures/B2.jpg'));
%% create DoG pyramids
[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4 ] = createDoG(imA);
[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG(imB);

%% find extrema
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );

%% remove low contrast points & edges 
leftoversA = removeLowContrast(extremaA, octA1);
leftoversB = removeLowContrast(extremaB, octB1);
keypointsA = leftoversA; %removeEdges(leftoversA, octA1); % TODO FIX REMOVE EDGES
keypointsB = leftoversB; %removeEdges(leftoversB, octB1);

%% find keypoint orientation
orientationsA = findOrientations( keypointsA, octA1);
orientationsB = findOrientations( keypointsB, octB1);
showKeypoints( imA, keypointsA, orientationsA);
showKeypoints( imB, keypointsB, orientationsB);

%% create descriptors
descriptorsA = createDescriptors( octA1, keypointsA, orientationsA); % TODO
descriptorsB = createDescriptors( octB1, keypointsB, orientationsB);

%% match keypoints
matchKeypoints();

%% find homography (ransac)
findHomography();

%% stitch images

end
