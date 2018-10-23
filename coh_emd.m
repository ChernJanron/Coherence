% coherence with EEMD
[img,si,ch,bh,th] = altreadsegy('E:\seismic_data\ld212_bem_1100_1200.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ibm');
img = reshape(img,[51 405 301]);
clear th bh ch; 
[nt,nx,ny] = size(img);


%Helix filter
img(:,:,2:2:end) = img(:,end:-1:1,2:2:end) ;
img = reshape(img,[nt nx*ny]);
img(:,2:2:end) = img(end:-1:1,2:2:end);
img = reshape(img,[nt*nx*ny 1]);

img = img.^2;
% img2 = zeros(size(img));
% for i=1:405
%     for j=1:301
%         
%         e3 = eemd(img(:,i,j),0.2,30,3);
%         img2(:,i,j) = e3(2,:)';
%         
%     end
% end

img2 = eemd(img,0.2,30,3)';

img = img2(:,2);
img = reshape(img,[nt nx*ny]);
img(:,2:2:end) = img(end:-1:1,2:2:end);
img = reshape(img,[nt nx ny]);
img(:,:,2:2:end) = img(:,end:-1:1,2:2:end) ;

cov = my_covar2(img);
    
load trace.mat;

