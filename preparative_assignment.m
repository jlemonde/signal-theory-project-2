clear;

%%%%%%%%%%% DÉCODAGE ET ENCODAGE, PRÉSENTATION DES DEUX FONCTIONS
%%%%%%%%%%% RÉCIPROQUES.
% pic = imread('kth.jpg');
% [key, cPic] = encoder(pic);
% dPic = decoder(key, cPic);
% image(dPic);






%%%%%%%%%%% ENCODAGE DE L'IMAGE
pic = imread('bond.jpg');
[key, cPic] = encoder(pic);



%%%%%%%%%%% DISTORTION DU SIGNAL : CONVOLUTION
h = [1, 0.7, 0.7, 0];
% rKey = zeros(size(key));
% for k = 1:length(key)
%     for l = 0:3
%         if k-l >= 1
%             rKey(k) = rKey(k) + h(l+1)*key(k-l);
%         end
%     end
% end
rKey = filter(h, 1, key); % this line does the same as the comment before

%%%%%%%%%%% DISTORTION DU SIGNAL, SUITE : ON APPLIQUE LA FONCTION SIGNE
%%%%% NE PAS FAIRE CE PARAGRAPHE !!! J'AVAIS MAL COMPRIS LA DONNÉE !!!
% pKey = zeros(size(rKey));
% for k = 1:length(pKey)
%    pKey(k) = sign(rKey(k));
%    if pKey(k) == 0
%        pKey(k) = -1;
%    end
% end
% rKey = pKey;



%%%%%%%%%%% RECONSTRUCTION DU SIGNAL : EQUALISER.
% PARAMÈTRES
L = 12; % il y aura L+1 paramètres w. Et on perd L valeurs parmi les N
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
for k = 1:N % on pourrait aussi aller jusqu'à N, car on les connaît
   eKey(k) = key(k); 
end
for k = N+1:length(rKey)
    for i = 1:L+1
        eKey(k) = eKey(k) + w(i)*rKey(k-i+1);
    end
    
     eKey(k) = sign(eKey(k));
     if eKey(k) == 0
         eKey(k) = -1;
     end
end

errCheck = (eKey-key)/2;
MSE = 0;
for i = 1:N %length(errCheck)        % we only know key from 1 to N !!!!
   MSE = MSE + errCheck(i)^2;
end
MSE;


                                                                            % PERMET DE RAJOUTER DES ERREURS À key POUR DES ESSAIS
                                                                            nombre_d_erreurs_a_inserer = 0;
                                                                            j = randperm(length(eKey), nombre_d_erreurs_a_inserer); 
                                                                            for i = 1:length(j)
                                                                               eKey(j(i)) = eKey(j(i)) * (-1);
                                                                            end


%%%%%%%%%%% DÉCODAGE DE L'IMAGE ET AFFICHAGE DE CELLE-CI
dPic = decoder(eKey, cPic);
image(dPic);
axis square;








                                                                            % PERMET DE RAJOUTER DES ERREURS À key POUR DES ESSAIS
                                                                            % j = randperm(20542, 555); 
                                                                            % for i = 1:length(j)
                                                                            %     key(j(i)) = key(j(i)) * (-1);
                                                                            % end




