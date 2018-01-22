%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.1

% a
P = imread('image/maccropped.jpg');
I = rgb2gray(P);
imshow(I);

% b
sobel_v = [
    -1 0 1; 
    -2 0 2; 
    -1 0 1;
];
sobel_h = [
    -1 -2 -1; 
    0 0 0; 
    1 2 1;
];

res1 = conv2(I, sobel_v);
imshow(uint8(res1))
res2 = conv2(I, sobel_h); 
imshow(uint8(res2)) 

% c
E = res1.^2 + res2.^2;
imshow(uint8(E));

% d
t = [10000, 20000, 40000, 80000];
Et = E>t(1);
imshow(Et)
Et = E>t(2);
imshow(Et)
Et = E>t(3);
imshow(Et)
Et = E>t(4);
imshow(Et)

% e (i)
tl = 0.04;
th = 0.1;
sigma = [1.0, 2.0, 3.0, 4.0, 5.0];
E = edge(I, 'canny', [tl th], sigma(1));
imshow(E)
E = edge(I, 'canny', [tl th], sigma(2));
imshow(E)
E = edge(I, 'canny', [tl th], sigma(3));
imshow(E)
E = edge(I, 'canny', [tl th], sigma(4));
imshow(E)
E = edge(I, 'canny', [tl th], sigma(5));
imshow(E)

tl = [0.09, 0.04, 0.01];
th = 0.1;
sigma = 1.0;
E = edge(I, 'canny' ,[tl(1) th], sigma);
imshow(E);
E = edge(I, 'canny' ,[tl(2) th], sigma);
imshow(E);
E = edge(I, 'canny' ,[tl(3) th], sigma);
imshow(E);


tl = 0.04;
E = edge(I,'canny',[tl th],sigma);
imshow(E);


tl = 0.0001;
E = edge(I,'canny',[tl th],sigma);
imshow(E);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.2

% a
P = imread('image/maccropped.jpg');
I = rgb2gray(P);
tl = 0.04; th = 0.1; sigma = 1.0;
E = edge(I,'canny',[tl th],sigma);
imshow(E);

% b
[H, xp] = radon(E);
imshow(uint8(H));

% c
imagesc(uint8(H));
colormap('default');

% d
theta = 103;
radius = xp(157);
[A, B] = pol2cart(theta*pi/180, radius);
B = -B;

C = A*(A+179) + B*(B+145);

%e
xl = 0;
yl = (C - A * xl) / B;
xr = 357;
yr = (C - A * xr) / B;

%f
imshow(I)
line([xl xr], [yl yr])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3.3

% a

% b
l = imread('image/corridorl.jpg'); 
l = rgb2gray(l);
imshow(l);
r = imread('image/corridorr.jpg');
r = rgb2gray(r);
imshow(r);

% c
D = map(l, r, 11, 11);
imshow(D,[-15 15]);
res = imread('image/corridor_disp.jpg');
imshow(res);

%d
l = imread('image/triclopsi2l.jpg'); 
l = rgb2gray(l);
imshow(l);
r = imread('image/triclopsi2r.jpg');
r = rgb2gray(r);
imshow(r);

D = map(l, r, 11, 11);
imshow(D,[-15 15]);
res = imread('image/triclopsid.jpg');
imshow(res);