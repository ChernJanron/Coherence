function [vt,vx,vy] = normal_v(img)
[nt,nx,ny] = size(img);
vx = zeros(nt,nx,ny);  vt = vx; vy = vx;


[dxx, dtt, dyy, dtx, dty, dxy] = const_tensor_3D(img);
% difussion tensor
for i=1:nt
    for j=1:nx
        for k=1:ny
            st=[dxx(i,j,k) dtx(i,j,k) dxy(i,j,k);...
                dtx(i,j,k) dtt(i,j,k) dty(i,j,k);...
                dxy(i,j,k) dty(i,j,k) dyy(i,j,k)];   %�ṹ����
            [ev, eva] = eig(st);     %�������� ����ֵ
            
            [~, index] = sort(diag(eva),'descend');% �ɴ�С����
            ev = ev(:,index);
            
            vx(i,j,k) = ev(1,1);    
            vt(i,j,k) = ev(2,1);
            vy(i,j,k) = ev(3,1);
            
        end
    end
end


end