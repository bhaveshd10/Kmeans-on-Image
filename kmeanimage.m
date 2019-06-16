clear all;clc;close all

img=imread('Rock_Climbing_Color.jpg');                                      % Read Image
R=double(img(:,:,1));                                                       % Get its R value
G=double(img(:,:,2));                                                       % Get its G value
B=double(img(:,:,3));                                                       % Get its B value

k=200;
means=randi(256,1,3*k);                                                     % Get randomly generated means
E=0.001;                                                                    % Threshold for comparing change of mean

[l,n]=size(R);
iteration=1;
while iteration<20;
    c=[];
    a=[];
    prev_mean=means;                                                        % Store old mean for comparison
    for i=1:l
        for j=1:n
            temp1=[R(i,j),G(i,j),B(i,j)];                                   % Get the R,G,B pixel values
            count=1;
            for t=1:3:length(means)-2
                d(count)=sqrt(sum((temp1-means(t:t+2)).^2));                % calculate distance from mean
                count=count+1;
            end
            [m,p]=min(d);                                                   % minimum distance amongst all and corresponding mean value
            c=[c;temp1,p];                                                  % centroid belonging to mean p
            a=[a;i,j,p];                                                    % pixel value locations to change in original image
        end
    end
    new_mean=[];                                                            % new mean matrix    
    ii=1;
    while ii<=k                                                             % Calculate new mean value
        temp_mean=[];               
        parfor g=1:length(c)
            if c(g,4)==ii;
                temp_mean=[temp_mean;c(g,1:3)];                             % append to temporary array centroids belonging to particular mean                
            end               
        end
        TF=isempty(temp_mean)                                               % Check if mean array is empty
        sz=size(temp_mean);
        if TF==0;
            if (sz(1)==1)
                new_mean=[new_mean,temp_mean];
            else
                new_mean=[new_mean,mean(temp_mean(:,1:3))];                 % If not empty then append newly calculated mean values        
            end
        end
        if TF==1;                                                 
            new_mean=[new_mean,[0,0,0]];                                    % If empty assign 0 to mean value
        end
        ii=ii+1;
    end
    means=(new_mean);                                                       % Replace old mean with new mean values

    for jj=1:3:length(prev_mean)-2                                          % check if the mean values have changed
        if abs(prev_mean(jj:jj+2)-means(jj:jj+2))<E
            condition=1;
        else 
            condition=0;
        end
    end
    if condition==1;                                                        % Break if change of mean is less than E
        break;
    end
    iteration=iteration+1;                                                  % Else continue iteration
end

ii=1;
x=1;
while ii<=k                                                                 % Calculate new mean value  
    a_new=[];
    parfor i=1:length(a)
        if a(i,3)==ii
            a_new=[a_new;a(i,1:2)];                                         % append to temporary array centroids belonging to particular mean                
        end               
    end   
    tf=isempty(a_new)
    if tf==0
        [R,G,B]=replace(R,G,B,a_new,means(1,x:x+2));                        % Function call to replace the pixel values with newly calculated mean 
    end
    x=x+3;
    ii=ii+1;    
end

output=cat(3,R,G,B);                                                        % Combine R G and B images
figure,imshow(uint8(output))