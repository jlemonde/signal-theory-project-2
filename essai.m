clear;

%%%%%%%%%%% DÉCODAGE ET ENCODAGE, PRÉSENTATION DES DEUX FONCTIONS
%%%%%%%%%%% RÉCIPROQUES.
% pic = imread('kth.jpg');
% [key, cPic] = encoder(pic);
% dPic = decoder(key, cPic);
% image(dPic);



load("spydata.mat");
load("training.mat");
rKey = received;
key = training;

%%%%%%%%%%% RECONSTRUCTION DU SIGNAL : EQUALISER.
% PARAMÈTRES
L = 7; % il y aura L+1 paramètres w. Et on perd L valeurs parmi les N
N = 32;
% CONSTRUCTION DE LA MATRICE R
R = zeros(N-L, L+1);
for ligne = 1:N-L
    for colonne = 1:L+1
        R(ligne, colonne) = rKey(L+ligne-colonne+1);
    end
end
% CONSTRUCTION DU VECTEUR D'ENTRAINEMENT (CELUI QUI EST CONNU)
b = zeros(N-L, 1);
for colonne = 1:N-L
    b(colonne) = key(L+colonne);
end
% RÉSOLUTION DES ÉQUATIONS POUR OBTENIR LES COEFFICIENTS w
w = R\b;
% EXTRAPOLATION DES RÉSULTATS OBTENUS SUR LES VALEURS SUIVANTES DE rKey
eKey = zeros(size(rKey));
for k = 1:L % on pourrait aussi aller jusqu'à N, car on les connaît
   eKey(k) = key(k); 
end
for k = L+1:length(rKey)
    for i = 1:L+1
        eKey(k) = eKey(k) + w(i)*rKey(k-i+1);
    end
    
     eKey(k) = sign(eKey(k));
     if eKey(k) == 0
         eKey(k) = -1;
     end
end

% errCheck = (eKey-key)/2;
% MSE = 0;
% for i = 1:N %length(errCheck)        % we only know key from 1 to N !!!!
%    MSE = MSE + errCheck(i)^2;
% end
% MSE;


% return



%%%%%%%%%%% DÉCODAGE DE L'IMAGE ET AFFICHAGE DE CELLE-CI
dPic = decoder(eKey, cPic);
image(dPic);








                                                                            % PERMET DE RAJOUTER DES ERREURS À key POUR DES ESSAIS
                                                                            % j = randperm(20542, 555); 
                                                                            % for i = 1:length(j)
                                                                            %     key(j(i)) = key(j(i)) * (-1);
                                                                            % end




