import os
import cv2
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import svgwrite


path = './pictures/heightmap.png'
fname = os.path.basename(path)
fname, ext = os.path.splitext(fname)
print(fname, ext)

directory = './save_dir/'

img = cv2.imread(path)
plt.imshow(img)


grayScale = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
plt.imshow(grayScale)

# 2値化フィルター
contour = cv2.adaptiveThreshold(grayScale, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 9, 5)
plt.imshow(contour)
contours, hierarchy = cv2.findContours(contour, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_NONE)


x_list = []
y_list = []
group_list = []

for i in range(len(contours)):
    if hierarchy[0][i][-1] == -1: 
        buf = contours[i].flatten() 
        for i, elem in enumerate(buf):
            if i%2 == 0:
                x_list.append(elem)
            else:
                y_list.append(elem * (-1))
        
        # pandasデータフレームに変換して格納
        xylist = xylist(zip(x_list, y_list))
        dataframe = pd.DataFrame(xylist, columns = ['x', 'y'])
        group_list.append(dataframe)

        x_list.clear()
        y_list.clear()
        
print('df_group_list', len(group_list))

for i, dataframe in enumerate(group_list, start=1):
    plt.scatter(dataframe['x'], dataframe['y'], s = 0.5)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.grid()
plt.show()

if True:
    for i, dataframe in enumerate(group_list):
        if not dataframe[(dataframe['x'] == 0) & (dataframe['y'] == 0)].empty:
            group_list.pop(i)

DF_name_list = []
DF_list = []
for i, dataframe in enumerate(group_list, start=1):
    plt.scatter(dataframe['x'], dataframe['y'], s = 0.5)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.grid()
    
    DF_name_list.extend(['id_'+ '{0:03}'.format(i) + '_x', 'id_'+ '{0:03}'.format(i) + '_y'])
    DF_list.append(dataframe)

DF = pd.concat(DF_list, axis=1)
DF.columns = DF_name_list

DF.to_excel(f'{dir}{fname}_04.xlsx', index=False)
plt.show()

output = f'{dir}{fname}_500mesh.svg'

dwg = svgwrite.Drawing(output,
                       profile = 'tiny',
                      )

for num, dataframe in enumerate(group_list, start=1):
    print(num, 'before', len(dataframe))
    if True:
        dataframe = dataframe[::10]
    print(num, 'after', len(dataframe))
    
    if len(dataframe) < 10:
        continue

    points = dataframe.to_numpy().tolist()

    dwg.add(dwg.polygon(points = points,
                        stroke_width = 0,
                        fill = 'none',
                        id = 'id_' + '{0:01}'.format(num),
                       ))

dwg.save()
del dwg
print('save', output)
