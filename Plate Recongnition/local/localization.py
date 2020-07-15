from skimage.transform import rotate, resize
from skimage.io import imread
from skimage.filters import threshold_otsu, gaussian

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

from PIL import Image
import numpy as np

from skimage.morphology import binary_dilation
from skimage import feature


from skimage.segmentation import clear_border
from skimage.measure import label, regionprops

import utils
import predict


car_image = imread("./assets/car_image_1.jpg",
                   as_gray=True)

# it should be a 2 dimensional array
print(car_image.shape)

# image from esp32 need to be rotated
#car_image = rotate(car_image, -90)

gray_car_image = car_image * 255

# # denoise using gaussian
gaussian_image = gaussian(gray_car_image, 0.2)

# image thresholding
threshold_value = threshold_otsu(gaussian_image)
binary_car_image = gray_car_image > threshold_value

fig, (ax1, ax2,) = plt.subplots(1, 2, figsize=(8, 3))


ax1.imshow(gaussian_image, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('gaussian filter', fontsize=16)

ax2.imshow(binary_car_image, cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('binary image', fontsize=16)


plt.show()


# canny Edge Detection
edges = feature.canny(binary_car_image, 1.0)

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 3))

ax1.imshow(binary_car_image, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('binary image', fontsize=16)

ax2.imshow(edges, cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('edge Detection', fontsize=16)

plt.show()

# image Dilation Loop
binary_dilation_image = binary_dilation(edges)

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 3))

ax1.imshow(edges, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('edge Detection', fontsize=16)

ax2.imshow(binary_dilation_image, cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('Dilatation', fontsize=16)

plt.show()


# remove artifacts connected to image border
#cleared = clear_border(binary_dilation_image)

# label image regions
label_image = label(binary_car_image)

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 3))

ax1.imshow(binary_dilation_image, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('Dilated image', fontsize=16)

ax2.imshow(label_image, cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('Object Detection', fontsize=16)


plate_object = 0
plate_coordinate = 0

for region in regionprops(label_image):
    # take regions with large enough areas
    if region.area >= 100:
        # draw rectangle around segmented areas
        min_row, min_col, max_row, max_col = region.bbox

        ratio = 0

        if(min_col != 0):
            ratio = max_col/min_col

        if ratio > 2.5 and ratio < 4:

            rect = mpatches.Rectangle((min_col, min_row), max_col - min_col, max_row - min_row,
                                      fill=False, edgecolor='red', linewidth=2)
            ax2.add_patch(rect)

            plate_object = (binary_car_image[min_row:max_row,
                                             min_col:max_col])

            plate_coordinate = ((min_row, min_col,
                                 max_row, max_col))

print(plate_coordinate)

# save the object plate as jpg image
file_plate_path = "./plate.jpg"

utils.object_to_image(plate_object, file_plate_path)

content = utils.read_tmp(file_plate_path)

print(predict.predict_text(content))

plt.show()
