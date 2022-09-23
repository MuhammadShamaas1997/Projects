clc;clear all;
fid=fopen('Code.m','wt');

fprintf(fid,'addpath(genpath(''F:\\Softwares''));\n');
fprintf(fid,'addpath(genpath(''C:\\gurobi912''));\n');
fprintf(fid,'yalmip(''clear'');\n');


fprintf(fid,'Constraints=[];\n');
% InitialValues=[
%     0 6 0 0 3 0 0 1 0;
%     0 0 0 1 2 4 0 6 0;
%     0 1 0 0 0 6 2 0 7;
%     0 0 6 0 0 9 0 0 4;
%     3 4 1 0 0 0 9 5 8;
%     9 0 0 4 0 0 6 0 0;
%     6 0 2 3 0 0 0 9 0;
%     0 3 0 2 9 1 0 0 0;
%     0 9 0 0 6 0 0 4 0
%     ];

InitialValues=[
    0 0 6 0 8 0 4 7 3;
    0 0 5 0 0 6 9 0 0;
    0 1 7 0 0 3 0 6 8;
    0 3 0 0 0 9 0 4 0;
    0 0 0 8 0 1 0 0 0;
    0 7 0 4 0 0 0 3 0;
    7 2 0 3 0 0 1 8 0;
    0 0 8 6 0 0 3 0 0;
    5 6 3 0 1 0 7 0 0
    ];

fprintf(fid,'S=intvar(9,9,''full'');\n');

for row=1:9
    for col=1:9
        fprintf(fid,'Constraints=[Constraints,S(%1.0f,%1.0f)<=9];\n',row,col);
        fprintf(fid,'Constraints=[Constraints,S(%1.0f,%1.0f)>=1];\n',row,col);

        if (InitialValues(row,col)>0)
            fprintf(fid,'Constraints=[Constraints,S(%1.0f,%1.0f)==%1.0f];\n',row,col,InitialValues(row,col));
        end
    end
end
    
for ind=1:9
fprintf(fid,'Constraints=[Constraints,sum(S(%1.0f,:))==45];\n',ind);
fprintf(fid,'Constraints=[Constraints,sum(S(:,%1.0f))==45];\n',ind);
end

for row=[1 4 7]
    for col=[1 4 7]
        fprintf(fid,'Constraints=[Constraints,sum(sum(S(%1.0f:(%1.0f+2),%1.0f:(%1.0f+2))))==45];\n',row,row,col,col);
    end
end

for row=1:9
    for col=1:9
        for ind=1:9
            if(col~=ind)
                fprintf(fid,'Constraints=[Constraints,S(%1.0f,%1.f)~=S(%1.0f,%1.f)];\n',row,col,row,ind);
            end
            if(row~=ind)
                fprintf(fid,'Constraints=[Constraints,S(%1.0f,%1.f)~=S(%1.0f,%1.f)];\n',row,col,ind,col);
            end
        end
        
        rb=floor((row-1)/3);
        cb=floor((col-1)/3);
        for ind1=(3*(rb)+1):(3*(rb)+3)
            for ind2=(3*(cb)+1):(3*(cb)+3)
                if (row~=ind1)&&(col~=ind2)
                    fprintf(fid,'Constraints=[Constraints,S(%1.0f,%1.f)~=S(%1.0f,%1.f)];\n',row,col,ind1,ind2);
                end
            end
        end
    end
end


fprintf(fid,'Objective=0');
for row=1:9
    for col=1:9
        fprintf(fid,'-S(%1.0f,%1.0f)',row,col);
    end
end
fprintf(fid,';\n');
fprintf(fid,'ops=sdpsettings(''solver'',''gurobi'',''verbose'', 4, ''debug'', 1);\n');
fprintf(fid,'sol=optimize(Constraints,Objective,ops);\n');
fclose(fid);
Code