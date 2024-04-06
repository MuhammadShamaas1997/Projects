clc;clear all;
global urdu_letter;
global urdu_letter_I;

% Load the image of the Urdu letter
urdu_letter = imread('Islam.png');
urdu_letter = im2double(urdu_letter);
sz=size(urdu_letter);
urdu_letter = urdu_letter(1:min(sz(1),sz(2)),1:min(sz(1),sz(2)),1);
sz=size(urdu_letter);

for i=1:sz(1)
    for j=1:sz(2)
        if (urdu_letter(i,j)<1)
            urdu_letter(i,j) = 1;
        else
            urdu_letter(i,j) = 0;
        end
    end
end

for i=1:sz(1)
    for j=1:sz(1)
        urdu_letter_I(i,j)=0;
    end
end


totalCoordinates = 1;

coordinates{1,1} = [355 212];
coordinates{1,2} = [355 464];
coordinates{1,3} = [357 582];
coordinates{1,4} = [484 594];
coordinates{1,5} = [128 113];
coordinates{1,6} = [209 164];
coordinates{1,7} = [172 192];
found = 1;
for iter = 1:1000
    tc = size(coordinates);
    totalCoordinates = 0;
    if (found==1)
        found = 0;
        for cIndex = 1:tc(2)
            sc = size(coordinates{iter,cIndex});
            if (sc(1)>0 && sc(2)>0)
                x=coordinates{iter,cIndex}(1);
                y=coordinates{iter,cIndex}(2);

                if (x>0 && y>0 && x<sz(1) && y<sz(2))
                    if (urdu_letter(x,y)==1 && urdu_letter_I(x,y)==0)
                        urdu_letter_I(x,y)=1;

                        if ((x+1)>0 && y>0 && (x+1)<sz(1) && y<sz(2))
                            if (urdu_letter((x+1),y)==1 && urdu_letter_I((x+1),y)==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x+1 y];
                                found = 1;
                            end
                        end

                        if (x>0 && (y+1)>0 && x<sz(1) && (y+1)<sz(2))
                            if (urdu_letter(x,(y+1))==1 && urdu_letter_I(x,(y+1))==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x y+1];
                                found = 1;
                            end
                        end

                        if ((x+1)>0 && (y+1)>0 && (x+1)<sz(1) && (y+1)<sz(2))
                            if (urdu_letter((x+1),(y+1))==1 && urdu_letter_I((x+1),(y+1))==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x+1 y+1];
                                found = 1;
                            end
                        end

                        if ((x-1)>0 && y>0 && (x-1)<sz(1) && y<sz(2))
                            if (urdu_letter((x-1),y)==1 && urdu_letter_I((x-1),y)==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x-1 y];
                                found = 1;
                            end
                        end

                        if ((x-1)>0 && (y+1)>0 && (x-1)<sz(1) && (y+1)<sz(2))
                            if (urdu_letter((x-1),(y+1))==1 && urdu_letter_I((x-1),(y+1))==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x-1 y+1];
                                found = 1;
                            end
                        end

                        if ((x-1)>0 && (y-1)>0 && (x-1)<sz(1) && (y-1)<sz(2))
                            if (urdu_letter((x-1),(y-1))==1 && urdu_letter_I((x-1),(y-1))==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x-1 y-1];
                                found = 1;
                            end
                        end

                        if (x>0 && (y-1)>0 && x<sz(1) && (y-1)<sz(2))
                            if (urdu_letter(x,(y-1))==1 && urdu_letter_I(x,(y-1))==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x y-1];
                                found = 1;
                            end
                        end

                        if ((x+1)>0 && (y-1)>0 && (x+1)<sz(1) && (y-1)<sz(2))
                            if (urdu_letter((x+1),(y-1))==1 && urdu_letter_I((x+1),(y-1))==0)
                                totalCoordinates = totalCoordinates + 1;
                                coordinates{iter+1,totalCoordinates} = [x+1 y-1];
                                found = 1;
                            end
                        end
                    end
                end
            end
        end
        wave(i) = surf(1:sz(1),1:sz(2),urdu_letter_I(:,1:i),'EdgeColor','None');
        axis off;
        colormap('bone');
        view([0 270]);
        saveas(gcf,['Plot' num2str(iter) '.png'])
        pause(0.1);
        set(wave(i),'Visible','off');
    end
end