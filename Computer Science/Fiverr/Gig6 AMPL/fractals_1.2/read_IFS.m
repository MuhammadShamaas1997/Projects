function [trans,pr] = read_IFS(file_name)
% read_IFS(file_name)
%
% function reads the IFS from a file
%
% file_name - name of the file with IFS
%
%
% example:
% [trans,pr] = read_IFS('ifs\dragon.ifs');

plik = fopen(file_name,'r');
d = fscanf(plik,'%d',1);
t = zeros(3);
t(3,3) = 1;
for i = 1:d
    t(1,1) = fscanf(plik,'%f',1);
    t(2,1) = fscanf(plik,'%f',1);
    t(1,2) = fscanf(plik,'%f',1);
    t(2,2) = fscanf(plik,'%f',1);
    t(3,1) = fscanf(plik,'%f',1);
    t(3,2) = fscanf(plik,'%f',1);
    p{i} = fscanf(plik,'%f',1);
    TT{i} = t;
end
fclose(plik);

trans = TT;
pr = p;