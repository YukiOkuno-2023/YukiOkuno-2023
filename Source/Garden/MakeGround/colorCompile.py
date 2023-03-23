import sys
import numpy
import cv2
import matplotlib.pyplot as plt


line = input("BaseTexture:")
model = line + ".png"
img = cv2.imread(model)
size = img.shape[0]


fName = []
i = 0
while(i<4):
    if i==0:
        line = input("height(B):")
    elif i ==1:
        line = input("Ambient Occlusion(G):")
    elif i==2:
        line = input("Metallic(R):")
    elif i==3:
        line = input("Glossiness(A):")
    fName.append(line + ".png")
    i = i + 1


'''
line = "Sand__Base_Color___id___basecolor_"
model = line + ".png"
model_img = cv2.imread(model)
size = model_img.shape[0]
fName = []
fName.append("Sand__Height___id___height_.png")     # B入力
fName.append("Sand__Ambient_Occlusion___id___ambientocclusion_.png")     # G入力
fName.append("Null")     # R入力
fName.append("Null")     # A入力
'''

color = numpy.zeros((size, size, 4))

for roop in range(4):
    if fName[roop] != "Null.png":
        img = cv2.imread(fName[roop])
        size = img.shape[0]
        size_check = img.shape[1]
        
        if (size != size_check):
            print("WARNING: The image was resized because it was not suitable as a texture.")
            img = cv2.resize(img, (size, size))
        
        for i in range(size):
            for j in range(size):
                if roop < 3:
                    color[i][j][roop] = img[i][j][0]
                else:
                    color[i][j][roop] = 255 - img[i][j][0]
                
                if (img[i][j][0] != img[i][j][1]) or (img[i][j][0] != img[i][j][2]) or (img[i][j][1] != img[i][j][2]):
                    print("Error: The texture does not represent physical properties.")
                    sys.exit()
                
    else:
        if(roop == 3):
            num = 255
        else:
            num = 0
        
        for i in range(size):
            for j in range(size):
                color[i][j][roop] = num
                

cv2.imwrite("./output.PNG", color)

for i in range(size):
    for j in range(size):
        temp = color[i][j][0]
        color[i][j][0] = color[i][j][2]
        color[i][j][2] = temp
plt.imshow(color/255)
plt.show()
