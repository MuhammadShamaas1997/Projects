function [R1_line,R2_line]=calcommSINR2(G,h1,h2,R,Ru)
    H=[G'*diag(h1),h2]';
    R1_line=H*R*H';
    R2_line=H*Ru*H';    
end