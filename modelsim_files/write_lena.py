#!/usr/bin/python3
import cv2
import numpy as np
import matplotlib.pyplot as plt
from bitstring import Bits

width = 8
img_name = "lena.png"
out_name = "img.dat"

def to_bin(val: int) -> str:
    b = Bits(int=val, length=width+1)
    return b.bin[1:]

img = cv2.imread(img_name, cv2.IMREAD_GRAYSCALE)
img = cv2.resize(img, (100, 100))
file = open(out_name, "w")

i = 0
j = 0
for line in img:
    for pix in line:
        file.write(to_bin(pix))
        file.write('\n')
    i = 0
    j+= 0

