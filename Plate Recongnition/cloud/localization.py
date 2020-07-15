from skimage.io import imread
from skimage.transform import rotate, resize
from skimage.filters import threshold_otsu
# cca2
from skimage import measure
from skimage.measure import regionprops


def ImageToBinary(filePath):
    car_image = imread(filePath, as_gray=True)

    # image from esp32 need to be rotated
    # car_image = rotate(car_image, -90)

    gray_car_image = car_image * 255

    threshold_value = threshold_otsu(gray_car_image)
    # image from phone threshold = 80
    binary_car_image = gray_car_image > threshold_value

    return binary_car_image


def cca2(binary_image):

    print(binary_image)

    # this gets all the connected regions and groups them together
    label_image = measure.label(binary_image)

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

            if ratio > 2 and ratio < 4:

                plate_object = (binary_image[min_row:max_row,
                                             min_col:max_col])

                plate_coordinate = ((min_row, min_col,
                                     max_row, max_col))

    return plate_object
