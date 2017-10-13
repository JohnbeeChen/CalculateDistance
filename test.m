% [trainIamges,~,trainAngles] = digitTrain4DArrayData;

numTrainImages = size(trainIamges,4);
figure
idx = randperm(numTrainImages,20);
for ii = 1:numel(idx)
   subplot(4,5,ii);
   imshow(trainIamges(:,:,:,idx(ii)));
   drawnow; 
end