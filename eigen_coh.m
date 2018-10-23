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
dy = ma*[0;1]; dy = reshape(dy,[1,3,3]);    dy(1,2,1)=-2;   dy(1,2,3)=2;% y direction
dx = ma*[1;0]; dx = reshape(dx,[1,3,3]);    dx(1,1,2)=-2;   dx(1,3,2)=2;% x direction
dx1 = ma*[1;1]; dx1 = reshape(dx1,[1,3,3]); 
dy1 = ma*[1;-1]; dy1 = reshape(dy1,[1,3,3]);

dy = dy./sum(abs(dy(:)));  dx = dx./sum(abs(dx(:)));   dx1 = dx1./sum(abs(dx1(:)));
dy1 = dy1./sum(abs(dy1(:)));
%filtering
iy = imfilter(img,dy);  ix = imfilter(img,dx);
ix1 = imfilter(img,dx1); iy1 = imfilter(img,dy1);
[~,it,~] = gradient(img);
it = 5*it;
Ixx = ix.*ix;   Ixy = ix.*iy;   Iyy = iy.*iy;    Itx = it.*ix;   Ity = it.*iy;  Itt = it.*it;
Ix1x1 = ix1.*ix1;  Ix1y1 = ix1.*iy1;   Iy1y1 = iy1.*iy1;   Itx1 = it.*ix1;  Ity1 = it.*iy1;
Ixx1 = ix.*ix1;   Ixy1 = ix.*iy1;    Iyy1 = iy.*iy1;   Iyx1 = iy.*ix1;

% Ixx = Ixx + Ixx1;  Iyy = Iyy + Iyy1;  Ixy = Ixy + Ixy1;  Itx = Itx + Itx1;  Ity = Ity + Ity1;  
% Itt = Itt*8;

r1 = 2;  r2 =  1;
Ixx = recur_gauss_filt_3D(Ixx,r1,r2);  Iyy = recur_gauss_filt_3D(Iyy,r1,r2); 
Ixy = recur_gauss_filt_3D(Ixy,r1,r2);  Ity = recur_gauss_filt_3D(Ity,r1,r2);
Itt = recur_gauss_filt_3D(Itt,r1,r2);  Itx = recur_gauss_filt_3D(Itx,r1,r2); 

Ix1x1 = recur_gauss_filt_3D(Ix1x1,r1,r2);  Iy1y1 = recur_gauss_filt_3D(Iy1y1,r1,r2); 
Ix1y1 = recur_gauss_filt_3D(Ix1y1,r1,r2);  Ity1 = recur_gauss_filt_3D(Ity1,r1,r2);
Itx1 = recur_gauss_filt_3D(Itx1,r1,r2); 
Ixx1 = recur_gauss_filt_3D(Ixx1,r1,r2);  Iyy1 = recur_gauss_filt_3D(Iyy1,r1,r2); 
Ixy1 = recur_gauss_filt_3D(Ixy1,r1,r2);   Iyx1 = recur_gauss_filt_3D(Iyx1,r1,r2); 

%%
img_eva1 = zeros(nt,nx,ny);   img_eva2 = zeros(nt,nx,ny);   img_eva3 = zeros(nt,nx,ny);
 img_eva4 = zeros(nt,nx,ny);   img_eva5 = zeros(nt,nx,ny);  img_all = zeros(nt,nx,ny);
 img2 = zeros(nt,nx,ny);   img3 = zeros(nt,nx,ny);
for i=1:nt
    for j=1:nx
        for k=1:ny
            st=[Ixx(i,j,k)  Itx(i,j,k)  Ixy(i,j,k)  Ixx1(i,j,k)  Ixy1(i,j,k);...
                Itx(i,j,k)  Itt(i,j,k)  Ity(i,j,k)  Itx1(i,j,k)  Ity1(i,j,k);...
                Ixy(i,j,k)  Ity(i,j,k)  Iyy(i,j,k)  Iyx1(i,j,k)  Iyy1(i,j,k);...
                Ixx1(i,j,k) Itx1(i,j,k) Iyx1(i,j,k) Ix1x1(i,j,k) Ix1y1(i,j,k);...
                Ixy1(i,j,k) Ity1(i,j,k) Iyy1(i,j,k) Ix1y1(i,j,k) Iy1y1(i,j,k)];   %�ṹ����
            [ev, eva] = eig(st);     %�������� ����ֵ
            
            [eva_v, index] = sort(diag(eva),'descend');% �ɴ�С����
            ev = ev(:,index);
            
            img_eva1(i,j,k) = eva_v(1);    
            img_eva2(i,j,k) = eva_v(2);
            img_eva3(i,j,k) = eva_v(3);
            img_eva4(i,j,k) = eva_v(4);
            img_eva5(i,j,k) = eva_v(5);
            img_all(i,j,k) = sum(eva_v(:));
            img2(i,j,k) = sum(eva_v(:)).^2;  img3(i,j,k) = sum(eva_v(:).^2);
        end
    end
end

cova = imfilter(img2,gau)./(1+imfilter(img3,gau));
imagesc(reshape((img_eva1(5,:,:)-img_eva2(5,:,:))./(0.001+img_eva1(5,:,:)),[405 301]));

% imagesc(reshape((img_eva1(5,:,:)-img_eva2(5,:,:))./(0.001+img_all(5,:,:)),[405 301]));

