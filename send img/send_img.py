import serial
import io
import time
import numpy as np
import cv2
from PIL import Image

ser =serial.Serial()
print(ser.name)
ser.baudrate = 9600
ser.port = 'COM10'
ser.open()

img = cv2.imread('img.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#calculate the padding
F = 3
S = 1
W = gray.shape[0]
P = ((S-1)*W-S+F)/2
'''
#recreate the new image with padding
image_with_padding = []

zeros_row = []

for i in range(W+2*int(P)):
  zeros_row.append(0)

for p in range(int(P)):
  image_with_padding.append(zeros_row)

for row in gray:
  new_row = []

  for p in range(int(P)):
    new_row.append(0)
  
  for i in row:
    new_row.append(i)
  
  for p in range(int(P)):
    new_row.append(0)
  
  image_with_padding.append(new_row)

for p in range(int(P)):
  image_with_padding.append(zeros_row)

image_oneD = []

for row in image_with_padding:
  image_oneD += row

for i in range(len(image_oneD)):
    print(i , image_oneD[i])
    ser.write(bytes([image_oneD[i]]))'''

arr = []

for i in range(int(P)):
    
    cur_byte=ser.read(1)
    print (str(cur_byte))
    arr.append(int.from_bytes(cur_byte , "big"))

arr = np.array(arr)
arr = np.resize(arr, (25 , 25))
im = Image.fromarray(arr)
im.show()
