clc;
clear all;
I=imread('C:\Documents and Settings\All Users\Documents\My Pictures\Sample Pictures\water lilies.jpg');
I=I(10+[1:256],222+[1:256]);
figure;imshow(I);
title('Original Image');
LEN=31;
THETA=11;
PSF=fspecial('motion',LEN,THETA);
Blurred=imfilter(I,PSF,'circular','conv');
figure;imshow(Blurred);
title('Blurred');

wnrl=deconvwnr(Blurred,PSF);
figure;imshow(wnrl);
title('Restored,True PSF');

wnr2=deconvwnr(Blurred,fspecial('motion',2*LEN,THETA));
figure;imshow(wnr2);
title('Restored,"Long"PSF');

wnr3=deconvwnr(Blurred,fspecial('motion',LEN,2*THETA));
figure;imshow(wnr3);
title('Restored,Steep');

noise=0.1*randn(size(I));
BlurredNoisy=imadd(Blurred,im2uint8(noise));
figure;
imshow(BlurredNoisy);
title('Blurred & Noisy');
wnr4=deconvwnr(BlurredNoisy,PSF);
figure;imshow(wnr4);
title('Inverse Filtering of Noisy Data');

NSR=sum(noise(:).^2/sum(im2double(I(:)).^2));
wnr5=deconvwnr(BlurredNoisy,PSF,NSR);
figure;imshow(wnr5);
title('Restored with NSR');

wnr6=deconvwnr(BlurredNoisy,PSF,NSR/2);
figure;imshow(wnr6);
title('Restored with NSR/2');

NP=abs(fftn(noise)).^2;
NPOW=sum(NP(:))/prod(size(noise));% noise power
NCORR=fftshift(real(ifftn(NP)));% noise ACF,centered
IP=abs(fftn(im2double(I))).^2;
IPOW=sum(IP(:))/prod(size(I));% original image power
ICORR=fftshift(real(ifftn(IP)));% image ACF,centered


wnr7=deconvwnr(BlurredNoisy,PSF,NCORR,ICORR);
figure;imshow(wnr7);
title('Restored with ACF');

ICORR1=ICORR(:,ceil(size(I,1)/2));
wnr8=deconvwnr(BlurredNoisy,PSF,NPOW,ICORR1);
figure;imshow(wnr8);
title('Restored with NP & 1D-ACF');
