function [C,lim]=geometryInterface2D(longueur,largeur,b,bz,x0,z0)

% geometrysample - Computes a sample geometry 
%
% FILE NAME: geometryInterface2D.m
% AUTHOR: N Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2020/07/19
% VERSION: Final
%
%geometryInterface2D(longueur,largeur,b,bz,option,x0,z0)
% 
% 
% TO DO:  integrate within geometrysample.m after debuging



%% Initialisation

larg=2*largeur+1;
long=2*longueur+1;
C=1.68*ones(larg,larg,long);


%% Interface2D

    lim=x0+100*z0;
    
    for m=-largeur:largeur
        for n=-largeur:largeur
            for p=-longueur:longueur
                if ((b*m)<x0)&((bz*p)<z0)
                    C(largeur+1+m,largeur+1+n,longueur+1+p)=0;
                end
            end
        end
    end
    



