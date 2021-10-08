clc
clear all
close all
% Initialization
threshlevel=0.95;% threshold level selection
% threshlevel=0.6;
nhood=31; % odd numbers only.

% Pre-processing:
IM= imread('brainmri.jpg');
% IM= imread('brainmri2.jpg');
% IM= imread('brainmri4.jpg');
% IM= imread('brainmri3.jpg');
% IM= imread('brainmri6.jpg');
% IM= imread('brainmri5.jpg');
% IM=uint8(IM);
imshow(IM);
% IMMH=sharppolished5(IM);
% IMMH=sharppolished(IMM);
figure
IMG=rgb2gray(IM);
imshow(IMG)
figure
IMM= medfilt2(IMG,[3 3]);
imshow(IMM)
kernel=[-1 2 -1;0 0 0;1 -2 1];
IMMH=imfilter(IMM,kernel);
% imshow(IMMH)
figure
IMMHP=imadd(IMG,IMMH);
imshow(IMMHP)
figure

% Segmentation/Thresholding:

IMMHPT=im2bw(IMMHP,threshlevel);
imshow(IMMHPT)
figure
% Post-processing:
SE = strel('disk',3);
IMMPHTE=imerode(IMMHPT,SE);
imshow(IMMPHTE);
figure

SE = strel('disk',3);
IMMPHTED=imdilate(IMMPHTE,SE);
imshow(IMMPHTED);
[row,col]=size(IMMPHTED);
image=IMMPHTED;

% ROI extraction

for a=((nhood/2)-.5)+1:row-((nhood/2)-.5)
    for b=((nhood/2)-.5)+1:col-((nhood/2)-.5)
        temp=[];
        m=1;
        for k=-((nhood/2)-.5):((nhood/2)-.5)
            n=1;
            for l=-((nhood/2)-.5):((nhood/2)-.5)
                temp(m,n)=image(a+k,b+l);
                n=n+1;
            end
            m=m+1;
        end
        if all(temp(:))
            break
        end
    end
    if all(temp(:))
        break
    end
end
text=['Tumor Region found at row=',num2str(a),',col=',num2str(b)];
disp(text);

while(1)
    if image(a-1,b)==1
        a=a-1;
    else
        break
    end
end
xstart=a;
ystart=b;

% Boolean Direction initialization
dN=false;
dNE=false;
dE=false;
dSE=false;
dS=false;
dSW=false;
dW=false;
dNW=false;

if image(a-1,b+1)==1
    xarray(1,1)=a-1;
    a=a-1;
    yarray(1,1)=b+1;
    b=b+1;
    dNE=true;
elseif image(a,b+1)==1
    xarray(1,1)=a;
    yarray(1,1)=b+1;
    b=b+1;
    dE=true;
elseif image(a+1,b+1)==1
    xarray(1,1)=a+1;
    a=a+1;
    yarray(1,1)=b+1;
    b=b+1;
    dSE=true;
elseif image(a+1,b)==1
    xarray(1,1)=a+1;
    a=a+1;
    yarray(1,1)=b;
    dS=true;
end


iter=2;
while(a~=xstart || b~=ystart)
    if dN
        if image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        elseif image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        elseif image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        elseif image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        end
    elseif dNE
        if image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        elseif image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        elseif image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        end
    elseif dE
        if image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        elseif image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        end
    elseif dSE
        if image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        elseif image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        end
    elseif dS
        if image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        elseif image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        elseif image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        end
    elseif dSW
        if image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        elseif image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        elseif image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        elseif image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        end
    elseif dW
        if image(a+1,b+1)==1
            %SE
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b+1;
            b=b+1;
            dSE=true;
            dN=false;
            dNE=false;
            dE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        elseif image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        elseif image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        elseif image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        end
    elseif dNW
        if image(a+1,b)==1
            %S
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b;
            dS=true;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a+1,b-1)==1
            %SW
            xarray(1,iter)=a+1;
            a=a+1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=true;
            dW=false;
            dNW=false;
        elseif image(a,b-1)==1
            %W
            xarray(1,iter)=a;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=true;
            dNW=false;
        elseif image(a-1,b-1)==1
            %NW
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b-1;
            b=b-1;
            dS=false;
            dN=false;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=true;
        elseif image(a-1,b)==1
            % N
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b;
            dS=false;
            dN=true;
            dNE=false;
            dE=false;
            dSE=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a-1,b+1)==1
            %NE
            xarray(1,iter)=a-1;
            a=a-1;
            yarray(1,iter)=b+1;
            b=b+1;
            dNE=true;
            dN=false;
            dE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        elseif image(a,b+1)==1
            %E
            xarray(1,iter)=a;
            yarray(1,iter)=b+1;
            b=b+1;
            dE=true;
            dN=false;
            dNE=false;
            dSE=false;
            dS=false;
            dSW=false;
            dW=false;
            dNW=false;
        end
    end
    iter=iter+1;
end
figure
mask = poly2mask(yarray,xarray,row,col);
imshow(mask)
hold on
plot(yarray,xarray,'b','LineWidth',2)
hold off


finalimage=image & mask;
figure
imshowpair(IM,finalimage,'montage');


figure
imshow(IM)
hold on
plot(yarray,xarray,'r','LineWidth',2)
hold off