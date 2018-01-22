%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.1 Contrast Stretching

% a
Pc = imread('image/mrttrainbland.jpg');
whos Pc;
P = rgb2gray(Pc);
whos P;

% b
imshow(P);

% c
min(P(:))
max(P(:))

% d
P2(:,:) = imsubtract(P(:,:), 13);
P2(:,:) = immultiply(P2(:,:), 255 / (204 - 13));

min(P2(:))
max(P2(:))

% e
imshow(P2);
imshow(P, []);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.2 Histogram Equalization

% a
Pc = imread('image/mrttrainbland.jpg');
P = rgb2gray(Pc);
imhist(P, 10);
imhist(P, 256);

% b
P3 = histeq(P, 255);
imhist(P3, 10);
imhist(P3, 256);

% c
P3 = histeq(P3, 255);
imhist(P3, 10);
imhist(P3, 256);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.3 Linear Spatial Filtering

% a i)
x = -2:2;
y = -2:2;
sigma_1 = 1.0;

[X,Y] = meshgrid(x,y);

filter_1 = exp(-((X).^2 + (Y).^2) / (2 * sigma_1^2));
filter_1 = filter_1 ./ (2 * pi * sigma_1^2);
filter_1 = filter_1 ./ sum(filter_1(:));
mesh(filter_1);

% a ii)
x = -2:2;
y = -2:2;
sigma_2 = 2.0;

[X,Y] = meshgrid(x,y);

filter_2 = exp(-((X).^2 + (Y).^2) / (2 * sigma_2^2));
filter_2 = filter_2 ./ (2 * pi * sigma_2^2);
filter_2 = filter_2 ./ sum(filter_2(:));
mesh(filter_2);

% b
P = imread('image/ntugn.jpg');
imshow(P);

% c
P1 = uint8(conv2(P,filter_1));
imshow(P1);
P2 = uint8(conv2(P,filter_2));
imshow(P2);

% d
P = imread('image/ntusp.jpg');
imshow(P);

% e
P1 = uint8(conv2(P,filter_1));
imshow(P1);
P2 = uint8(conv2(P,filter_2));
imshow(P2);

%Gaussian filter is more effective in removing gaussian noise than speckle
%noise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.4 Median Filtering

% b
P = imread('image/ntugn.jpg');
imshow(P);

% c
P1 = medfilt2(P,[3,3]);
imshow(P1);
P2 = medfilt2(P,[5,5]);
imshow(P2);

% d 
P = imread('image/ntusp.jpg');
imshow(P);

% e
P1 = medfilt2(P,[3,3]);
imshow(P1);
P2 = medfilt2(P,[5,5]);
imshow(P2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.5 Suppressing Noise Interference Patterns

% a
P = imread('image/pckint.jpg');
imshow(P);

% b
F = fft2(P);
S = abs(F);
imagesc(fftshift(S.^0.1));
colormap('default');

% c
imagesc(S.^0.1);
colormap('default');

% d
x1 = 241; y1 = 9;
x2 = 17; y2 = 249;
F(x1-2:x1+2, y1-2:y1+2) = 0;
F(x2-2:x2+2, y2-2:y2+2) = 0;
S = abs(F);
imagesc(fftshift(S.^0.1));
colormap('default');

% e
result = uint8(ifft2(F));
imshow(result);

% f
P = imread('image/primatecaged.jpg');
P = rgb2gray(P);
imshow(P);

F = fft2(P);    
S = abs(F);
imagesc(S.^0.0001);
colormap('default');

x1 = 252; y1 = 11; F(x1-2:x1+2, y1-2:y1+2) = 0;
x2 = 248; y2 = 22; F(x2-2:x2+2, y2-2:y2+2) = 0;
x3 = 5; y3 = 247; F(x3-2:x3+2, y3-2:y3+2) = 0;
x4 = 10; y4 = 236; F(x4-2:x4+2, y4-2:y4+2) = 0;
S = abs(F);
imagesc(S.^0.1);
colormap('default');

result = uint8(ifft2(F));
imshow(result);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.6 Undoing Perspective Distortion of Planar Surface

% a
P = imread('image/book.jpg');
imshow(P);

% b
[X, Y] = ginput(4);
Xim = [0; 210; 210; 0];
Yim = [0; 0; 297; 297];

% c
A = [
    [X(1), Y(1), 1, 0, 0, 0, -Xim(1)*X(1), -Xim(1)*Y(1)];
    [0, 0, 0, X(1), Y(1), 1, -Yim(1)*X(1), -Yim(1)*Y(1)];
    [X(2), Y(2), 1, 0, 0, 0, -Xim(2)*X(2), -Xim(2)*Y(2)];
    [0, 0, 0, X(2), Y(2), 1, -Yim(2)*X(2), -Yim(2)*Y(2)];
    [X(3), Y(3), 1, 0, 0, 0, -Xim(3)*X(3), -Xim(3)*Y(3)];
    [0, 0, 0, X(3), Y(3), 1, -Yim(3)*X(3), -Yim(3)*Y(3)];
    [X(4), Y(4), 1, 0, 0, 0, -Xim(4)*X(4), -Xim(4)*Y(4)];
    [0, 0, 0, X(4), Y(4), 1, -Yim(4)*X(4), -Yim(4)*Y(4)];
];
v = [Xim(1); Yim(1); Xim(2); Yim(2); Xim(3); Yim(3); Xim(4); Yim(4)];
u = A \ v;
U = reshape([u;1], 3, 3)'; 
w = U*[X'; Y'; ones(1,4)];
w = w ./ (ones(3,1) * w(3,:));

% d
T = maketform('projective', U');
P2 = imtransform(P, T, 'XData', [0 210], 'YData', [0 297]);

% e
imshow(P2);
