[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ibm');
img = reshape(img,[11 405 301]);
clear th bh ch; 

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\bm_nq_6_15.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[451 1121 771]);
% clear th bh ch;
% img = img(290:310,:,:);

% img = img(1:50,:,:);

[nt,nx,ny] = size(img);
 L = 20;   I=3;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
gau = tri/sum(tri(:));            
aver2 = ones(1,I,I);

%%
[row,col] = ind2sub([3,3],1:9);
ma = [row-2;col-2]';
dx1 = eye(3,3);    dx1(1,1) = -1;  dx1(2,2) = 0;
dy1 = fliplr(dx1);   dy1(1,3) = -1;  dy1(2,2) = 0;   
dx = zeros(3,3);  dx(2,:) = 1;  dx(2,1) = -1;   dx(2,2) = 0;
dy = dx';    dy(1,2) = -1;   dy(2,2) = 0;

%filtering
iy = imfilter(img,dy);  ix = imfilter(img,dx);
ix1 = imfilter(img,dx1); iy1 = imfilter(img,dy1);
iaver = (ix + iy + ix1 + iy1)/4;  ix = ix - iaver;  iy = iy - iaver;
ix1 = ix1 - iaver;  iy1 = iy1 - iaver;

Ixx = ix.*ix;   Ixy = ix.*iy;   Iyy = iy.*iy;   
Ix1x1 = ix1.*ix1;  Ix1y1 = ix1.*iy1;   Iy1y1 = iy1.*iy1;   
Ixx1 = ix.*ix1;   Ixy1 = ix.*iy1;    Iyy1 = iy.*iy1;   Iyx1 = iy.*ix1;

% Ixx = Ixx + Ixx1;  Iyy = Iyy + Iyy1;  Ixy = Ixy + Ixy1;  Itx = Itx + Itx1;  Ity = Ity + Ity1;  
% Itt = Itt*8;

r1 = 2;  r2 =  1;
Ixx = recur_gauss_filt_3D(Ixx,r1,r2);  Iyy = recur_gauss_filt_3D(Iyy,r1,r2); 
Ixy = recur_gauss_filt_3D(Ixy,r1,r2);  
Ix1x1 = recur_gauss_filt_3D(Ix1x1,r1,r2);  Iy1y1 = recur_gauss_filt_3D(Iy1y1,r1,r2); 
Ix1y1 = recur_gauss_filt_3D(Ix1y1,r1,r2);  
Ixx1 = recur_gauss_filt_3D(Ixx1,r1,r2);  Iyy1 = recur_gauss_filt_3D(Iyy1,r1,r2); 
Ixy1 = recur_gauss_filt_3D(Ixy1,r1,r2);   Iyx1 = recur_gauss_filt_3D(Iyx1,r1,r2); 

%%
img_eva1 = zeros(nt,nx,ny);   img_eva2 = zeros(nt,nx,ny);   img_eva3 = zeros(nt,nx,ny);
img_eva4 = zeros(nt,nx,ny);   img_eva5 = zeros(nt,nx,ny);  img_all = zeros(nt,nx,ny);
img2 = zeros(nt,nx,ny);   img3 = zeros(nt,nx,ny);
for i=1:nt
    for j=2:nx-1
        for k=2:ny-1
            st = reshape(img(i,j-1:j+1,k-1:k+1),[3 3]);
            st = st'*st;
%             st=[Ixx(i,j,k)    Ixy(i,j,k)  Ixx1(i,j,k)  Ixy1(i,j,k);...
%                 Ixy(i,j,k)    Iyy(i,j,k)  Iyx1(i,j,k)  Iyy1(i,j,k);...
%                 Ixx1(i,j,k)   Iyx1(i,j,k) Ix1x1(i,j,k) Ix1y1(i,j,k);...
%                 Ixy1(i,j,k)   Iyy1(i,j,k) Ix1y1(i,j,k) Iy1y1(i,j,k)];   %结构张量
            [ev, eva] = eig(st);     %特征向量 特征值
            
            [eva_v, index] = sort(diag(eva),'descend');% 由大到小排序
            ev = ev(:,index);
            
            img_eva1(i,j,k) = eva_v(1);    
            img_eva2(i,j,k) = eva_v(2);
            img_eva3(i,j,k) = eva_v(3);
%             img_eva4(i,j,k) = eva_v(4);

            img_all(i,j,k) = sum(eva_v(:));
            img2(i,j,k) = sum(eva_v(:)).^2;  img3(i,j,k) = sum(eva_v(:).^2);
        end
    end
end

cova = imfilter(img2,gau)./(1+imfilter(img3,gau));
imagesc(reshape((img_eva1(5,:,:)-img_eva2(5,:,:))./(0.001+img_eva1(5,:,:)),[405 301]));

% imagesc(reshape((img_eva1(5,:,:)-img_eva2(5,:,:))./(0.001+img_all(5,:,:)),[405 301]));

