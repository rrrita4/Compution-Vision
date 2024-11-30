%% GrabCut 函数应用
% 从图像中抠出前景色

clear;clc;
%读入RGB图像
RGB = imread('rabbit.jpg');%可以自行更改图片
%超像素分割——创建一个同样大小的图像
L = superpixels(RGB,500);

%% 创建可变多边形
imshow(RGB)
%①手动创建，gca为函数句柄
% 在弹出figure窗口直接鼠标点击选取闭环区域。
%h1 = impoly(gca); %impoly() = drawpolygon() = drawpolyline()

%②定点创建，gca为函数句柄
h1 = impoly(gca,[1,650; 1,1; 650,1; 650,650]);
%% 获取ROI位置坐标
ROIPoints = getPosition(h1);

%% 将感兴趣区域（ROI）多边形转换为区域蒙版
% poly2mask（x，y，m，n）从在x和y处具有顶点的ROI多边形计算大小为m×n的二进制感兴趣区域（ROI）掩模BW。 
ROI = poly2mask(ROIPoints(:,1),ROIPoints(:,2),size(L,1),size(L,2));

%% 开始分割
BW = grabcut(RGB,L,ROI);
figure
subplot(223);
imshow(BW);
title('分割模板');

maskedImage = RGB;
%将maskedImage图像背景全部改为0,即黑色
maskedImage(repmat(~BW,[1 1 3])) = 0;
subplot(224);
imshow(maskedImage)
title('分割效果');

subplot(221);
imshow(RGB);
title('原始图像');

subplot(222);
imshow(L);
title('L模板');
