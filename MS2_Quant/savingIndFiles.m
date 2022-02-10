function savingIndFiles(my3DData,nCh,outputFolder)

[myImageData]             =loadStack(my3DData);

[~,~,nSlices,numFiles]=size(myImageData);
nZstk=nSlices/nCh;


for iFiles = 1:numFiles

    for jZstk = 1:nSlices

        if mod(jZstk, 2) == 1

            % mZstk is odd

            saveTiff(myImageData(:,:,jZstk,iFiles), sprintf([outputFolder, 'file_z%d_t%d','_ch00.tif'],((jZstk+1)/nCh),iFiles));
        else

            % mZstk is even

            saveTiff(myImageData(:,:,jZstk,iFiles), sprintf([outputFolder, 'file_z%d_t%d','_ch01.tif'],(jZstk/nCh),iFiles));

        end

    end

end
end