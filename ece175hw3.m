clear all
data = load('data.mat');
label = load('label.mat');

imageTrain = data.imageTrain;
imageTest = data.imageTest;
labelTest = label.labelTest;
labelTrain = label.labelTrain;

%The following is under the assumption that I find the means in the
%training
totals = [sum(labelTrain(:)==0) sum(labelTrain(:)==1) sum(labelTrain(:)==2) sum(labelTrain(:)==3) sum(labelTrain(:)==4) sum(labelTrain(:)==5) sum(labelTrain(:)==6) sum(labelTrain(:)==7) sum(labelTrain(:)==8) sum(labelTrain(:)==9)];
class0 = zeros(28,28);class1 = zeros(28,28);class2 = zeros(28,28);class3 = zeros(28,28);class4 = zeros(28,28);class5 = zeros(28,28);class6 = zeros(28,28);class7 = zeros(28,28);class8 = zeros(28,28);class9 = zeros(28,28);
for i=1:5000    
    if labelTrain(i) == 0
        class0=class0+imageTrain(:,:,i);
    elseif labelTrain(i) == 1
        class1=class1+imageTrain(:,:,i);            
    elseif labelTrain(i)==2
        class2=class2+imageTrain(:,:,i);
    elseif labelTrain(i)==3
        class3=class3+imageTrain(:,:,i);
    elseif labelTrain(i)==4
        class4=class4+imageTrain(:,:,i);
    elseif labelTrain(i)==5
        class5=class5+imageTrain(:,:,i);
    elseif labelTrain(i)==6
        class6=class6+imageTrain(:,:,i);
    elseif labelTrain(i)==7
        class7=class7+imageTrain(:,:,i);
    elseif labelTrain(i)==8
        class8=class8+imageTrain(:,:,i);
    elseif labelTrain(i)==9
        class9=class9+imageTrain(:,:,i);
    end
    i=i+1;
end
class0=class0/totals(1);class1=class1/totals(2);class2=class2/totals(3);class3=class3/totals(4);class4=class4/totals(5);class5=class5/totals(6);class6=class6/totals(7);class7=class7/totals(8);class8=class8/totals(9);class9=class9/totals(10);
%{
figure(1)
imshow(class0(:,:)/255)
title('Mean Value for Class 0')
figure(2)
imshow(class1(:,:)/255)
title('Mean Value for Class 1')
figure(3)
imshow(class2(:,:)/255)
title('Mean Value for Class 2')
figure(4)
imshow(class3(:,:)/255)
title('Mean Value for Class 3')
figure(5)
imshow(class4(:,:)/255)
title('Mean Value for Class 4')
figure(6)
imshow(class5(:,:)/255)
title('Mean Value for Class 5')
figure(7)
imshow(class6(:,:)/255)
title('Mean Value for Class 6')
figure(8)
imshow(class7(:,:)/255)
title('Mean Value for Class 7')
figure(9)
imshow(class8(:,:)/255)
title('Mean Value for Class 8')
figure(10)
imshow(class9(:,:)/255)
title('Mean Value for Class 9')
%}
catclass = cat(3,class0,class1,class2,class3,class4,class5,class6,class7,class8,class9);
istarmatrix = zeros(1,10);
for j=1:500    
    for i=1:10
        subtraction = (imageTest(:,:,j)-catclass(:,:,i));
        istarmatrix(i) = (-0.5*((subtraction(:).')*subtraction(:))-(1/2)*(sqrt(28))*((log10(2*pi))^784)+(log10(1/10)));
        i=i+1;
    end
    [argvalue istar(j)] = max(istarmatrix(:));
    istar(j) = istar(j)-1; %normalize values between 0 and 9 instead of 1 and 10
    j=j+1;
end
istar=istar.';

misses = zeros(1, 10);
hits = zeros(1, 10);
for x=1:500    
    if labelTest(x) == istar(x)
        if labelTest(x)==0
            hits(1) = hits(1)+1;
        elseif labelTest(x)==1
            hits(2) = hits(2) + 1;
                    elseif labelTest(x)==2
            hits(3) = hits(3)+1;
                    elseif labelTest(x)==3
            hits(4) = hits(4)+1;
                    elseif labelTest(x)==4
            hits(5) = hits(5)+1;
                    elseif labelTest(x)==5
            hits(6) = hits(6)+1;
                    elseif labelTest(x)==6
            hits(7) = hits(7)+1;
                    elseif labelTest(x)==7
            hits(8) = hits(8)+1;
                    elseif labelTest(x)==8
            hits(9) = hits(9)+1;
                    elseif labelTest(x)==9
            hits(10)=hits(10)+1;
        end
    end
    if labelTest(x) ~= istar(x)
        if labelTest(x)==0
            misses(1) = misses(1)+1;
        elseif labelTest(x)==1
            misses(2) = misses(2)+1;
                    elseif labelTest(x)==2
            misses(3) = misses(3)+1;
                    elseif labelTest(x)==3
            misses(4) = misses(4)+1;
                    elseif labelTest(x)==4
            misses(5) = misses(5)+1;
                    elseif labelTest(x)==5
            misses(6) = misses(6)+1;
                    elseif labelTest(x)==6
            misses(7) = misses(7)+1;
                    elseif labelTest(x)==7
            misses(8) = misses(8)+1;
                    elseif labelTest(x)==8
            misses(9) = misses(9)+1;
                    elseif labelTest(x)==9
            misses(10) = misses(10)+1;
        end
    end
    
    x=x+1;
end

sumtotalrate = hits+misses;
errorrates=(misses./sumtotalrate).';

errors=zeros(500,1);
for a=1:500
    if istar(a) == labelTest(a)
        errors(a,1) = 0;
    else
        errors(a,1) = 1;
    end
    a=a+1;
end
sumerror = sum(errors); %sumerror is 47; 47 total errors out of 500
P_error = sumerror/500; %P_error is equal to .0940, or 9.4%
%{
image(1)
scatter([1:10],errorrates);
title('Error Rates For Classes 0-9')
xlabel('Class + 1')
ylabel('Error Rate Ratio')
%}

xmatrix = imageTest(:,:,1);
subtraction0 = xmatrix(:)-class0(:);
multiplier0 = subtraction0*(subtraction0.');
figure(1)
imshow(multiplier0,[])
title('Covariance Matrix Between First imageTest Matrix And Class 0')

subtraction1 = xmatrix(:)-class1(:);
multiplier1 = subtraction1*(subtraction1.');
figure(2)
imshow(multiplier1,[])
title('Covariance Matrix Between First imageTest Matrix And Class 1')

subtraction2 = xmatrix(:)-class2(:);
multiplier2 = subtraction2*(subtraction2.');
figure(3)
imshow(multiplier2,[])
title('Covariance Matrix Between First imageTest Matrix And Class 2')

subtraction3 = xmatrix(:)-class3(:);
multiplier3 = subtraction3*(subtraction3.');
figure(4)
imshow(multiplier3,[])
title('Covariance Matrix Between First imageTest Matrix And Class 3')

subtraction4 = xmatrix(:)-class4(:);
multiplier4 = subtraction4*(subtraction4.');
figure(5)
imshow(multiplier4,[])
title('Covariance Matrix Between First imageTest Matrix And Class 4')

subtraction5 = xmatrix(:)-class5(:);
multiplier5 = subtraction5*(subtraction5.');
figure(6)
imshow(multiplier5,[])
title('Covariance Matrix Between First imageTest Matrix And Class 5')

subtraction6 = xmatrix(:)-class6(:);
multiplier6 = subtraction6*(subtraction6.');
figure(7)
imshow(multiplier6,[])
title('Covariance Matrix Between First imageTest Matrix And Class 6')

subtraction7 = xmatrix(:)-class7(:);
multiplier7 = subtraction7*(subtraction7.');
figure(8)
imshow(multiplier7,[])
title('Covariance Matrix Between First imageTest Matrix And Class 7')

subtraction8 = xmatrix(:)-class8(:);
multiplier8 = subtraction8*(subtraction8.');
figure(9)
imshow(multiplier8,[])
title('Covariance Matrix Between First imageTest Matrix And Class 8')

subtraction9 = xmatrix(:)-class9(:);
multiplier9 = subtraction9*(subtraction9.');
figure(10)
imshow(multiplier9,[])
title('Covariance Matrix Between First imageTest Matrix And Class 9')


