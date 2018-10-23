function [ev_1,ev_2] = normal_v_2D(img)
[nt, nx, ny] = size(img);
[dx, ~, dy] = gradient(img);
Ixx = dx.^2;   Iyy = dy.^2;   Ixy = dx.*dy;

%filter
r1 = 2;  r2 =  1;
Ixx = recur_gauss_filt_3D(Ixx,r1,r2);  Iyy = recur_gauss_filt_3D(Iyy,r1,r2); 
Ixy = recur_gauss_filt_3D(Ixy,r1,r2);  

ev_1 = zeros(nt,nx,ny);   ev_2 = zeros(nt,nx,ny);    %define directional vector
ev_3 = zeros(nt,nx,ny);   ev_4 = zeros(nt,nx,ny);
for i = 1:nt
    for j = 1:nx
        for k = 1:ny
            st=[Ixx(i,j,k) Ixy(i,j,k); Ixy(i,j,k) Iyy(i,j,k)] ;   %结构张量
            [ev, eva] = eig(st);     %特征向量 特征值
            
            [~, index] = sort(diag(eva),'descend');% 由大到小排序
            ev = ev(:,index);
            ev_1(i,j,k) = ev(1,1);     ev_2(i,j,k) = ev(2,1);
            ev_3(i,j,k) = ev(1,2);     ev_4(i,j,k) = ev(2,2);
        end
    end
end
ev_1 = recur_gauss_filt_3D(ev_1,r1,r2);  ev_2 = recur_gauss_filt_3D(ev_2,r1,r2); 
ev_3 = recur_gauss_filt_3D(ev_3,r1,r2);  ev_4 = recur_gauss_filt_3D(ev_4,r1,r2); 




end