import os
from flask import escape
# localization
from skimage.io import imread
from skimage.filters import threshold_otsu
# cca2
from skimage import measure
from skimage.measure import regionprops
# segmentation
from skimage.transform import resize
from skimage import measure
from skimage.measure import regionprops
import numpy as np

# import base64
# import json
# import pandas as pd

# import googleapiclient.discovery
# import google.auth

from google.cloud import storage
from sklearn.externals import joblib
from tempfile import TemporaryFile


def hello_http(requests):
    print("start")
    write_tmp(requests.data)
    car_image = imread("/tmp/car.jpg", as_gray=True)
    # it should be a 2 dimensional array

    print(car_image.shape)

    gray_car_image = car_image * 255

    threshold_value = threshold_otsu(gray_car_image)

    binary_car_image = gray_car_image > threshold_value

    # this gets all the connected regions and groups them together
    label_image = measure.label(binary_car_image)

    plate_dimensions = (0.08*label_image.shape[0], 0.2*label_image.shape[0],
                        0.15*label_image.shape[1], 0.4*label_image.shape[1])

    min_height, max_height, min_width, max_width = plate_dimensions
    plate_objects_cordinates = []
    plate_like_objects = []

    # regionprops creates a list of properties of all the labelled regions
    for region in regionprops(label_image):
        if region.area < 50:
            # if the region is so small then it's likely not a license plate
            continue

        # the bounding box coordinates
        min_row, min_col, max_row, max_col = region.bbox
        region_height = max_row - min_row
        region_width = max_col - min_col

        # ensuring that the region identified satisfies the condition of a typical license plate
        if region_height >= min_height and region_height <= max_height and region_width >= min_width and region_width <= max_width and region_width > region_height:

            plate_like_objects.append(binary_car_image[min_row:max_row,
                                                       min_col:max_col])

    print(plate_like_objects[0])

    # The invert was done so as to convert the black pixel to white pixel and vice versa
    license_plate = np.invert(plate_like_objects[0])

    labelled_plate = measure.label(license_plate)

    character_dimensions = (0.35*license_plate.shape[0], 0.60*license_plate.shape[0],
                            0.02*license_plate.shape[1], 0.15*license_plate.shape[1])

    min_height, max_height, min_width, max_width = character_dimensions

    characters = []
    counter = 0
    column_list = []

    for regions in regionprops(labelled_plate):
        y0, x0, y1, x1 = regions.bbox
        region_height = y1 - y0
        region_width = x1 - x0

        if region_height > min_height and region_height < max_height and region_width > min_width and region_width < max_width:
            roi = license_plate[y0:y1, x0:x1]

            # resize the characters to 20X20 and then append each character into the characters list
            resized_char = resize(roi, (20, 20))
            characters.append(resized_char)

            # this is just to keep track of the arrangement of the characters
            column_list.append(x0)

    # credentials, project_id = google.auth.default()

    print("init service")

    #credentials, project = google.auth.default()

    #credentials = app_engine.Credentials()

    #version = "prediction_number_v1"

    # service = googleapiclient.discovery.build(
    #     'ml', 'v1', cache_discovery=False)

    # name = 'projects/{}/models/{}'.format(
    #     "iot-parking-8b09e ", "prediction_number_v1")

    # numpyData = {"instances": characters[0]}

    # if version is not None:
    #     name += '/versions/{}'.format(version)

    each_character = characters[1]

    each_character = each_character.reshape(1, -1)

    print(each_character)

    storage_client = storage.Client()
    bucket_name = "iot-parking-8b09e.appspot.com"
    model_bucket = '/number-v1/model.joblib'

    bucket = storage_client.get_bucket(bucket_name)
    # select bucket file
    blob = bucket.blob(model_bucket)

    with TemporaryFile() as temp_file:
        # download blob into temp file
        blob.download_to_file(temp_file)
        temp_file.seek(0)
        # load into joblib
        model = joblib.load(temp_file)

    result = model.predict(each_character)

    print(result)

# encodedNumpyData = pd.Series(each_character).to_json(orient='values')

# response = service.projects().predict(
#     name=name,
#     body={"instances": encodedNumpyData}
# ).execute()

# if 'error' in response:
#     raise RuntimeError(response['error'])

# # print(response['predictions'])

    return "response"


def write_tmp(content):
    file_path = '/tmp/car.jpg'
    print('writing.......')

    #  make sure dir exist or create one
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    newFile = open(file_path, "wb")
    newFile.write(content)
