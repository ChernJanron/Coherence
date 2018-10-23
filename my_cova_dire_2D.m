% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[11 405 301]);
% clear th bh ch; 

[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\bm_nq_6_15.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
img = reshape(img,[451 1121 771]);
clear th bh ch;
img = img(290:310,:,:);

[nt,nx,ny] = size(img);
[vx,vy] = normal_v(img);     %normal vector

L = 21;   I=3;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
gau = tri/sum(tri(:));

%%
[row,col] = ind2sub([3,3],1:9);
ma = [row-2;col-2]';
ma = ma./(0.00001 + repmat(sqrt(sum(ma.^2,2)),[1 2]));   % mask

%%
img2 = zeros(nt,nx,ny);  img3 = zeros(nt,nx,ny);
for i = 2:nt-1
    for j = 2:nx-1
        for k = 2:ny-1
            nv= [vx(i,j,k); vy(i,j,k)];  
            panel = exp(-abs(ma*nv)*10);
            
            img_t = reshape(img(i,j-1:j+1,k-1:k+1),[9 1]);
%             wd = img_t(panel>0.8);    N = length(wd);
            wd = panel.*img_t;
            
            img2(i,j,k) = sum(wd(:)).^2;
            img3(i,j,k) = sum(panel(:).^2)*sum(img_t(:).^2);

        end
    end
end

cova = imfilter(img2,gau)./(1+imfilter(img3,gau));

