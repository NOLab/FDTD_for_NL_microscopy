function [C,lim]=geometrysample(longueur,largeur,b,bz,option,oy,geometry)

% geometrysample - Computes a sample geometry 
%
% FILE NAME: geometrysample.m
% AUTHOR: N Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2006
% UPDATED: 2016/09/19
% VERSION: Final
%
%geometrysample(longueur,largeur,b,bz,option,oy,geometry)
% 
% REQUIRES constantesbessel.m
% REQUIRES  subfunction (after the main function)



%% Initialisation

larg=2*largeur+1;
long=2*longueur+1;
C=zeros(larg,larg,long);

%% Milieu homogene

if (strcmp(option,'homogene')==1)
    C=1;
    lim=1;
end

%% Sphere

if strcmp(option,'sphere')
    rayon=(oy-1)*largeur*b/geometry;
    lim=rayon;
    
    for m=-largeur:largeur
        for n=-largeur:largeur
            for p=-longueur:longueur
                if(sqrt(b*b*m*m+b*b*n*n+bz*bz*p*p)<rayon)
                    C(largeur+1+m,largeur+1+n,longueur+1+p)=1;
                end
            end
        end
    end
    
end

%% HalfSphere z

if strcmp(option,'halfspherez')
    rayon=(oy-1)*largeur*b/geometry;
    lim=rayon;
    
    for m=-largeur:largeur
        for n=-largeur:largeur
            for p=-longueur:longueur
                if(sqrt(b*b*m*m+b*b*n*n+bz*bz*p*p)<rayon)
                    if (p>0)
                        C(largeur+1+m,largeur+1+n,longueur+1+p)=1;
                    end
                end
            end
        end
    end
    
end


%% HalfSphere y

if strcmp(option,'halfspherey')
    rayon=(oy-1)*largeur*b/geometry;
    lim=rayon;
    
    for m=-largeur:largeur
        for n=-largeur:largeur
            for p=-longueur:longueur
                if(sqrt(b*b*m*m+b*b*n*n+bz*bz*p*p)<rayon)
                    if (n>0)
                        C(largeur+1+m,largeur+1+n,longueur+1+p)=1;
                    end
                end
            end
        end
    end
    
end

%% HalfSphere x

if strcmp(option,'halfspherex')
    rayon=(oy-1)*largeur*b/geometry;
    lim=rayon;
    
    for m=-largeur:largeur
        for n=-largeur:largeur
            for p=-longueur:longueur
                if(sqrt(b*b*m*m+b*b*n*n+bz*bz*p*p)<rayon)
                    if (m>0)
                        C(largeur+1+m,largeur+1+n,longueur+1+p)=1;
                    end
                end
            end
        end
    end
    
end



%% Interface x

if (strcmp(option,'interfacex')==1)
    
    lim=(oy-1)*floor((2*largeur+1)/geometry);
    
    for k=1:lim
        for l=1:larg
            for c=1:long
                C(k,l,c)=1;
            end
        end
    end
    
end

%% Interface y

if (strcmp(option,'interfacey')==1)
    
    lim=(oy-1)*floor((2*largeur+1)/geometry);
    
    for k=1:larg
        for l=1:lim
            for c=1:long
                C(k,l,c)=1;
            end
        end
    end
end

%% Interface z

if (strcmp(option,'interfacez')==1)
    
    lim=(oy-1)*floor((2*longueur+1)/geometry);
    
    for k=1:lim
        C(:,:,k)=ones(larg,larg);
    end
end

%% Slab z

if (strcmp(option,'slabz')==1)
    lim=(oy-1)*floor(longueur/geometry);
    epaisseur=lim;
    lim=2*bz*epaisseur;
    for c=longueur+1-epaisseur:longueur+1+epaisseur
        C(:,:,c)=ones(larg,larg);
    end
end

%% Slab x

if (strcmp(option,'slabx')==1)
    lim0=(oy-1)*floor(largeur/geometry);
    lim=2*b*lim0;
    for k=largeur+1-lim0:largeur+1+lim0
        for l=1:larg
            for c=1:long
                C(k,l,c)=1;
            end
        end
    end
end

%% Slab y

if (strcmp(option,'slaby')==1)
    lim0=(oy-1)*floor(largeur/geometry);
    lim=2*b*lim0;
    for k=1:larg
        for l=largeur+1-lim0:largeur+1+lim0
            for c=1:long
                C(k,l,c)=1;
            end
        end
    end
end


%% Slabx centre

if (strcmp(option,'slabxc')==1)
    
    lim0=(oy-1)*floor(largeur/geometry);
    lim=b*lim0;
    
    for k=largeur+1:largeur+1+lim0
        for l=1:larg
            for c=1:long
                C(k,l,c)=1;
            end
        end
    end
end

%% Slabz centre

if (strcmp(option,'slabzc')==1)
    
    lim0=(oy-1)*floor(largeur/geometry);
    lim=b*lim0;
    
    for c=longueur+1:longueur+1+lim0
        C(:,:,c)=ones(larg,larg);
    end
end


%% Slaby centre

if (strcmp(option,'slabyc')==1)
    lim0=(oy-1)*floor(largeur/geometry);
    lim=b*lim0;
    
    for k=1:larg
        for l=largeur+1:largeurr+1+lim0
            for c=1:long
                C(k,l,c)=1;
            end
        end
    end
end


%% Interface Angle

if (strcmp(option,'angle')==1)
    alpha=(oy-1)*floor(180/geometry)*pi/180;
    lim=alpha;
    C=interfaceangle2(alpha+0.01,longueur,largeur);
end

if (strcmp(option,'angle2d')==1)
    alpha=(oy-1)*floor(180/geometry)*pi/180;
    lim=alpha;
    C=interfaceangle3(alpha,longueur,largeur);
end

if (strcmp(option,'angle3')==1)
    alpha=(oy-1)*floor(180/geometry)*pi/180;
    lim=alpha;
    C=interfaceangle4(alpha,longueur,largeur);
end



end



function [D] = interfaceangle(alpha,largeur,longueur)
larg=2*largeur+1;
long=2*longueur+1;
D=ones(larg,long);
for x=1:larg
    for y=1:long
        if ((x-largeur-1)<=(y-longueur-1)*tan(alpha))
            D(x,y)=0;
        end
    end
end

end

function [C] = interfaceangle2(alpha,longueur,largeur)
larg=2*largeur+1;
long=2*longueur+1;
C=ones(larg,larg,long);

for z=1:long
    C(:,:,z)=interfaceangle(alpha,largeur,largeur);
end

end

function [C] = interfaceangle3(alpha,longueur,largeur)
%permute x et z

D=interfaceangle2(alpha,longueur,largeur);
C=permute(D,[3,2,1]);

end

function [C] = interfaceangle4(alpha,longueur,largeur)
%permute y et z

D=interfaceangle2(alpha,largeur,longueur);
C=permute(D,[1,3,2]);

end


