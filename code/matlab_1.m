clc,clear;
importfile('X.mat');
importfile('Y.mat');


% Xcentered=Xcentered-right_center;

distance=sqrt(Xcentered(:,1).*Xcentered(:,1)+Xcentered(:,2).*Xcentered(:,2));
road_side=Xcentered(distance<90,:);
clf;
scatter(road_side(:,1),road_side(:,2));

hold on
plot(0,0,'y*');
hold on
theta=0:2*pi/3600:2*pi;
Circle1=64*cos(theta);
Circle2=64*sin(theta);
plot(Circle1,Circle2,'m','Linewidth',1);
axis equal
clf;



plane_region=[1,0,0,0,0,0,0,0,0,0,0,0;
              2,0.054,2400,0,0,0,0,128,0,0,1,0;%0.54
              3,0.041,2100,0,0,0,0,86,0,0,1,0;
              4,0.043,1080,0,0,0,0,46,0,0,1,0;
              5,0.030,900,0,0,0,0,34,0,0,1,0;];%0.43

plane=[repmat(plane_region(2,:),84,1);
       repmat(plane_region(5,:),9,1);
       ];
food=road_side;


for p = 1:size(plane(:,1),1)
    if plane(p,1)==2
        plane(p,:)=plane_region(2,:);
        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
        j=find(distance<64);
        b=j(randperm(length(j)));
        b=b(1);
        plane(p,9:10)=food(b,:);
        plane(p,7)=distance(b);
    end
    if plane(p,1)==4
        plane(p,:)=plane_region(4,:);
        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
        j=find(distance<23);
        b=j(randperm(length(j)));
        b=b(1);
        plane(p,9:10)=food(b,:);
        plane(p,7)=distance(b);
    end
    if plane(p,1)==3
        plane(p,:)=plane_region(3,:);
        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
        j=find(distance<43);
        b=j(randperm(length(j)));
        b=b(1);
        plane(p,9:10)=food(b,:);
        plane(p,7)=distance(b);
    end
    if plane(p,1)==5
        plane(p,:)=plane_region(5,:);
        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
        j=find(distance<17);
        b=j(randperm(length(j)));
        b=b(1);
        plane(p,9:10)=food(b,:);
        plane(p,7)=distance(b);
    end
end



n=size(plane(:,1),1);
time_food=[];
time_plane_1=[];
for time = 0:864000
    if rem(time,1000)==0;
        scatter(food(:,1),food(:,2));
        hold on
        plot(plane(:,4),plane(:,5),'r*');
        hold on
        plot(0,0,'y*')
        clf;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %You need to set breakpoints here, to see what happened.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    time_food=[time_food,length(food(:,1))];
    if isempty(food)
        break;
    end
        for p = 1:size(plane(:,1),1)
            if isempty(food)
                break;
            end
            if p==1
                time_plane_1=[time_plane_1;[plane(1,4),plane(1,5)]];
            end
            if plane(p,11)==1
                if plane(p,6)>plane(p,8)
                    plane(p,9:10)=[0-plane(p,4),0-plane(p,5)];
                    plane(p,11)=0;
                    plane(p,12)=0;
                    plane(p,6)=plane(p,6)-plane(p,2);
                    plane(p,7)=plane(p,6);
                    plane(p,4)=plane(p,4)+plane(p,2)*plane(p,9)/norm(plane(p,9:10));
                    plane(p,5)=plane(p,5)+plane(p,2)*plane(p,10)/norm(plane(p,9:10));
                    plane(p,3)=plane(p,3)-1;
                    plane(p,8)=plane(p,2)*plane(p,3);
                else
                    if plane(p,12)==0
                        plane(p,7)=plane(p,7)-plane(p,2);
                        plane(p,4)=plane(p,4)+plane(p,2)*plane(p,9)/norm(plane(p,9:10));
                        plane(p,5)=plane(p,5)+plane(p,2)*plane(p,10)/norm(plane(p,9:10));
                        plane(p,6)=norm(plane(p,4:5));
                        plane(p,3)=plane(p,3)-1;
                        plane(p,8)=plane(p,2)*plane(p,3);
                        if plane(p,7)<=0
                            distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                            [~,f]=min(distance);
                            food(f,:)=[];
                            if isempty(food)
                                break;
                            end
                            distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                            [~,f]=min(distance);
                            plane(p,9:10)=food(f,:)-plane(p,4:5);
                            plane(p,7)=distance(f);
                            plane(p,12)=1;
                        end
                    else
                        plane(p,7)=plane(p,7)-plane(p,2);
                        plane(p,4)=plane(p,4)+plane(p,2)*plane(p,9)/norm(plane(p,9:10));
                        plane(p,5)=plane(p,5)+plane(p,2)*plane(p,10)/norm(plane(p,9:10));
                        plane(p,6)=norm(plane(p,4:5));
                        plane(p,3)=plane(p,3)-1;
                        plane(p,8)=plane(p,2)*plane(p,3);
                        if plane(p,7)<=0
                            distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                            [~,f]=min(distance);
                            food(f,:)=[];
                            if isempty(food)
                                break;
                            end
                            distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                            [~,f]=min(distance);
                            plane(p,9:10)=food(f,:)-plane(p,4:5);
                            plane(p,7)=distance(f);
                            plane(p,12)=1;
                        end
                    end
                end
            else
                if plane(p,6)<=0
                    if plane(p,1)==2
                        plane(p,:)=plane_region(2,:);
                        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                        j=find(distance<64);
                        if isempty(j)
                        else                        
                        b=j(randperm(length(j)));
                        b=b(1);
                        plane(p,9:10)=food(b,:);
                        plane(p,7)=distance(b);
                        end
                    end
                    if plane(p,1)==4
                        plane(p,:)=plane_region(4,:);
                        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                        j=find(distance<23);
                        if isempty(j)
                        else
                        b=j(randperm(length(j)));
                        b=b(1);
                        plane(p,9:10)=food(b,:);
                        plane(p,7)=distance(b);
                        end
                    end
                    if plane(p,1)==3
                        plane(p,:)=plane_region(3,:);
                        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                        j=find(distance<43);
                        if isempty(j)
                        else
                        b=j(randperm(length(j)));
                        b=b(1);
                        plane(p,9:10)=food(b,:);
                        plane(p,7)=distance(b);
                        end
                    end
                    if plane(p,1)==5
                        plane(p,:)=plane_region(5,:);
                        distance=sqrt((food(:,1)-plane(p,4)).*(food(:,1)-plane(p,4))+(food(:,2)-plane(p,5)).*(food(:,2)-plane(p,5)));
                        j=find(distance<17);
                        if isempty(j)
                        else
                        b=j(randperm(length(j)));
                        b=b(1);
                        plane(p,9:10)=food(b,:);
                        plane(p,7)=distance(b);
                        end
                    end
                else
                    plane(p,7)=plane(p,7)-plane(p,2);
                    plane(p,4)=plane(p,4)+plane(p,2)*plane(p,9)/norm(plane(p,9:10));
                    plane(p,5)=plane(p,5)+plane(p,2)*plane(p,10)/norm(plane(p,9:10));
                    plane(p,6)=plane(p,6)-plane(p,2);
                    plane(p,3)=plane(p,3)-1;
                    plane(p,8)=plane(p,2)*plane(p,3);
                end
            end
        end
end