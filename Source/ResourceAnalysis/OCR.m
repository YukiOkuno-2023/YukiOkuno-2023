clear all;
close all;

cd C:\Users\okuno\Documents\MATLAB\OCR

% 画像をリードする
I = imread('test.JPG');    % 画像を読み込む
I = imrotate(I,90);        % 画像を90°回転
I = rgb2gray(I);           % 前景処理のコントラスト増大を行うためにRGBからグレースケールへと変換しておく

% 自動レイアウト解析にかけた後の画像を表示
% BW = imbinarize(I);
% figure; 
% imshowpair(I,BW,'montage');

% 前景処理
radius = 17;                          % この値によって画像の不要部分の状態が変化する  14でボイジョウが読み取れた
se = strel('disk',radius);
background = imopen(I,se);
% imshow(background)
I2 = I - background;
% imshow(I2)

I3 = imadjust(I2);   % I2のコントラストを増大させる
imshow(I3)

% % OCRの結果を画像の上に表示
% figure;
% Iname = insertObjectAnnotation(I,'rectangle',wordBBox,word);   % 元の画像の読み取った座標に読み取った結果を重ねて表示
% imshow(Iname);   % 画像を表示

% 精度の低い部分を削除して表示
% highConfidenceIdx = results.CharacterConfidences > 0.5;   % 精度の低い部分を削除して格納
% highConfBBoxes = results.CharacterBoundingBoxes(highConfidenceIdx, :);
% highConfVal = results.CharacterConfidences(highConfidenceIdx);
% str      = sprintf('confidence = %f', highConfVal);
% Ihighconf = insertObjectAnnotation(I,'rectangle',highConfBBoxes,str);
% figure;
% imshow(Ihighconf);

% 画像認識
% ocr関数の'TextLayout'の内容(次の配列要素)を'Auto'にすると文字の塊を自動認識する
% 'Block'とすると自動レイアウト解析が無効化される
% results = ocr(I3,'Language','Japanese','TextLayout','Block');   % 日本語でOCR icr関数は文字と認識された座標と認識の信頼度を返す

results = ocr(I3,'Language','C:\Users\okuno\Documents\MATLAB\myLang\tessdata\myLang.traineddata','TextLayout','Block');

% 読み取った文字ブロックの1つだけを表示
number = 40;
word = results.Words{number}   % 読み取った結果
wordBBox = results.WordBoundingBoxes(number,:)   % 読み取った座標

% 読み取った結果をファイルに保存
writematrix(results.Text,'Text.txt')
writematrix(results.CharacterBoundingBoxes,'CharacterBoundingBoxes.txt')
writematrix(results.CharacterConfidences,'CharacterConfidences.txt')
writecell(results.Words,'Words.txt')
writematrix(results.WordBoundingBoxes,'WordBoundingBoxes.txt')
writematrix(results.WordConfidences,'WordConfidences.txt')

cd C:\Users\okuno\Documents\MATLAB
