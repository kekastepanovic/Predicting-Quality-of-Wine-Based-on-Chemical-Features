clear all;clc;
R1=1;
C1=0;
XY=importdata('whitewine.xlsx');
mat=XY.data;
n=length(mat);
X=mat(:,1:11);
Y=mat(:,12);
% THIS IS CROSS-VALIDATION FOR DETERMINING NUMBER OF NEIGHBOURS
K_max=100;
neighbour=1:1:K_max; 
val=10;
error_test_vek=zeros(1,length(neighbour));
for i=1:length(neighbour)
     k=neighbour(i);
     error_test=0; 
      for j=1:val
            x_train=[X(1:(j-1)*floor(n/val),:);X(j*floor(n/val)+1:end,:)];
            x_test=X((j-1)*floor(n/val)+1:j*floor(n/val),:);
            y_train= [Y(1:(j-1)*floor(n/val),:);Y(j*floor(n/val)+1:end,:)];
            y_test= Y((j-1)*floor(n/val)+1:j*floor(n/val),:);
            y_train_feature=zeros(1,length(x_test));
              for m=1:length(x_test)
                 distance=zeros(1,length(x_train)); 
                 point1_test_x=x_test(m,:);
                  for s=1:length(x_train)
                     distance(s)=sqrt(sum((x_train(s,:)-point1_test_x).^2));
                  end 
                 [~,index]=sort(distance); 
                 index=index(1:k);
                 y_train_vector=y_train(index);
                 y_train_feature(m)=mean(y_train_vector);
              end
            error_test=error_test+sqrt(sum((y_test-(y_train_feature)').^2)/length(y_test));
      end
    error_test_vek(i)=error_test/val; % i-za odredjeno k
end
figure;
plot(1:K_max,error_test_vek);
% cross-validation for determing number of neighbours is from the line 10
% to the line 39
% there is no need to run the part for cross-validation because it last too
% long. The determined number of neighbours is 70.
k=70; % cross-validation determined this number of neighbours
mat_con=zeros(9,9);
x_train=X(1:4000,:);
y_train=Y(1:4000,:);
x_test=X(4001:4898,:);
y_test=Y(4001:4898,:);
for m=1:length(x_test)
              distance=zeros(1,length(x_train));
              point_test_x=x_test(m,:);
                for s=1:length(x_train)
                    distance(s)=sqrt(sum((x_train(s,:)-point_test_x).^2));
                end 
                [~,index]=sort(distance); % vraca index-e k najmanjih elemenata niza
                index=index(1:k);
                y_train_vector=y_train(index);
                y_train_decision(m)=round(mean(y_train_vector));%odluka za jednu konkretnu tacku iz testirajuceg skupa!
                mat_con(y_test(m),y_train_decision(m))=mat_con(y_test(m),y_train_decision(m))+1;
end
y_forecast_3=sum(mat_con(:,3));
y_forecast_4=sum(mat_con(:,4));
y_forecast_5=sum(mat_con(:,5));
y_forecast_6=sum(mat_con(:,6));
y_forecast_7=sum(mat_con(:,7));
y_forecast_8=sum(mat_con(:,8));
y_forecast_9=sum(mat_con(:,9));
y_forecasts=[y_forecast_3 y_forecast_4 y_forecast_5 y_forecast_6 y_forecast_7 y_forecast_8 y_forecast_9 ];
x_forecasts=[3 4 5 6 7 8 9];
figure(10);
plot(x_forecasts,y_forecasts,'ro','MarkerSize',20);
hold all;
correct1=0;
overestimated1=0; 
underestimated1=0;
for i=1:9
  for j=1:9 
    if(i==j) correct1=correct1+mat_con(i,i);
    end
    if(i<j) overestimated1=overestimated1+mat_con(i,j);
    end
    if(i>j) underestimated1=underestimated1+mat_con(i,j);
    end
  end
end
          
           
           
           
           
           
           
           
           
           
           
           
           
           
    