[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ibm');
img = reshape(img,[11 405 301]);
clear th bh ch; 

% img = img(1:50,:,:);

[nt,nx,ny] = size(img);
 L = 20;   I=3;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
gau = tri/sum(tri(:));            
aver2 = ones(1,I,I);

%% derivative
[dx,dt,dy] = gradient(img);

%% filtering
me_dx = ones(nt,1);  me_dy = ones(nt,1);  me_dt = ones(nt,1);  
dx = abs(dx);  dt = abs(dt);  dy = abs(dy);
for i = 1:nt
    me_dx(i) = sum(dx(i,:))/(nx*ny);  me_dy(i) = sum(dy(i,:))/(nx*ny);    me_dt(i) = sum(dt(i,:))/(nx*ny); 
end

%% variance
var_dx = ones(nt,1);  var_dy = ones(nt,1);  var_dt = ones(nt,1);  
for i = 1:nt
    var_dx(i) = sum((dx(i,:)-me_dx(i)).^2)/(nx*ny);  
    var_dy(i) = sum((dy(i,:)-me_dy(i)).^2)/(nx*ny);  
    var_dt(i) = sum((dt(i,:)-me_dt(i)).^2)/(nx*ny);
end

%% final value
a1 = ones(nt,1);  a2 = ones(nt,1);
for i = 1:nt
    a1(i) = ( sum(dx(i,:).*dt(i,:))/(nx*ny) - me_dx(i)*me_dt(i) )/(var_dt(i) + eps);
end


% %%
% [row,col] = ind2sub([3,3],1:9);
% ma = [row-2;col-2]';
% dy = ma*[0;1]; dy = reshape(dy,[1,3,3]);    dy(1,2,1)=-2;   dy(1,2,3)=2;% y direction
% dx = ma*[1;0]; dx = reshape(dx,[1,3,3]);    dx(1,1,2)=-2;   dx(1,3,2)=2;% x direction
% dx1 = ma*[1;1]; dx1 = reshape(dx1,[1,3,3]); 
% dy1 = ma*[1;-1]; dy1 = reshape(dy1,[1,3,3]);
% 
% dy = dy./sum(abs(dy(:)));  dx = dx./sum(abs(dx(:)));   dx1 = dx1./sum(abs(dx1(:)));
% dy1 = dy1./sum(abs(dy1(:)));
% %filtering
% iy = imfilter(img,dy);  ix = imfilter(img,dx);
% ix1 = imfilter(img,dx1); iy1 = imfilter(img,dy1);
% [~,it,~] = gradient(img);
% 
% Ixx = ix.*ix;   Ixy = ix.*iy;   Iyy = iy.*iy;    Itx = it.*ix;   Ity = it.*iy;  Itt = it.*it;
% Ixx1 = ix1.*ix1;  Ixy1 = ix1.*iy1;   Iyy1 = iy1.*iy1;   Itx1 = it.*ix1;  Ity1 = it.*iy1;
% 
% Ixx = Ixx + Ixx1;  Iyy = Iyy + Iyy1;  Ixy = Ixy + Ixy1;  Itx = Itx + Itx1;  Ity = Ity + Ity1;  
% Itt = Itt*8;
% 
% r1 = 2;  r2 =  1;
% Ixx = recur_gauss_filt_3D(Ixx,r1,r2);  Iyy = recur_gauss_filt_3D(Iyy,r1,r2); 
% Ixy = recur_gauss_filt_3D(Ixy,r1,r2);  Ity = recur_gauss_filt_3D(Ity,r1,r2);
% Itt = recur_gauss_filt_3D(Itt,r1,r2);  Itx = recur_gauss_filt_3D(Itx,r1,r2); 
% %%
% img_eva1 = zeros(nt,nx,ny);   img_eva2 = zeros(nt,nx,ny);   img_eva3 = zeros(nt,nx,ny);
% for i=1:nt
%     for j=1:nx
%         for k=1:ny
%             st=[Ixx(i,j,k) Itx(i,j,k) Ixy(i,j,k);...
%                 Itx(i,j,k) Itt(i,j,k) Ity(i,j,k);...
%                 Ixy(i,j,k) Ity(i,j,k) Iyy(i,j,k)];   %结构张量
%             [ev, eva] = eig(st);     %特征向量 特征值
%             
%             [eva_v, index] = sort(diag(eva),'descend');% 由大到小排序
%             ev = ev(:,index);
%             
%             img_eva1(i,j,k) = eva_v(1);    
%             img_eva2(i,j,k) = eva_v(2);
%             img_eva3(i,j,k) = eva_v(3);
%             
%         end
%     end
% end
% 
% imagesc(reshape((img_eva1(5,:,:)-img_eva2(5,:,:))./(0.001+img_eva1(5,:,:)),[405 301]));


