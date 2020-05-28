#!/usr/bin/python3
import cv2
import matplotlib.pyplot as plt
import numpy as np
from bitstring import Bits
import math

width = 8

def plot_dat(img_name: str):

    img = open(img_name, "r")
    img = img.readlines()

    img_length = math.sqrt(len(img))
    print('img length:', img_length)
    img_length = int(img_length)

    img_res = np.zeros((img_length, img_length), dtype=np.float)
    img_i = 0
    img_j = 0

    for line in img:
        img_res[img_j][img_i] = int(line, 2)

        if img_i >= img_length-1:
            img_i = 0
            img_j += 1
        else:
            img_i += 1

    plt.imshow(img_res, cmap='gray')
    plt.show()
    cv2.imwrite("result.png", img_res)

import glob
files = [f for f in glob.glob("*.dat", recursive=True)]
for i, f in enumerate(files):
    print(str(i)+")", f)
sel = int(input("Choose a file: "))
plot_dat(files[sel])
