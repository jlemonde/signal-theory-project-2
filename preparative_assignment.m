clear;

% pic = imread('kth.jpg');
% [key, cPic] = encoder(pic);
% dPic = decoder(key, cPic);
% image(dPic);

pic = imread('kth.jpg');
[key, cPic] = encoder(pic);

h = [1, 0.7, 0.7, 0];
% rKey = zeros(size(key));
% for k = 1:length(key)
%     for l = 0:3
%         if k-l >= 1
%             rKey(k) = rKey(k) + h(l+1)*key(k-l);
%         end
%     end
% end
rKey = filter(h, 1, key); % this does the same as the comment before
pKey = zeros(size(rKey));
for k = 1:length(pKey)
    pKey(k) = sign(rKey(k));
    if pKey(k) == 0
        pKey(k) = -1;
    end
end

dPic = decoder(pKey, cPic);
image(dPic);