function [C,lim]=geometrysphere2D(longueur,largeur,b,bz,option,param)

%% Initialisation

larg=2*largeur+1;
long=2*longueur+1;
C=1.68*ones(larg,larg,long); %water everywhere

cx=param(1)*(200e-9)/b; %in pixel of 200nm needs to be translated to units of b
cy=param(2)*(200e-9)/b;
rayon=16e-6;
    
%% Milieu homogene

if (strcmp(option,'homogene')==1)
    C=1;
    lim=1;
end

%% Sphere

if strcmp(option,'Sphere2d')
    lim=rayon;
    
    for m=-largeur:largeur
        for n=-largeur:largeur
            for p=-longueur:longueur
                if(sqrt(b*b*(m-cx)*(m-cx)+b*b*(n-cy)*(n-cy)+bz*bz*p*p)<rayon)
                    C(largeur+1+m,largeur+1+n,longueur+1+p)=2.7;
                end
            end
        end
    end
    
end

