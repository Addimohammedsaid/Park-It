import os
import io
import png
import numpy as np
import random
import string


def randomString(stringLength=8):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))


def object_to_image(obj, file_path):
    # from binary to jpg or png image
    png.from_array(obj, 'L').save(file_path)


def read_tmp(file_path):
    # The name of the image file to annotate
    file_name = os.path.abspath(file_path)
    # Loads the image into memory
    with io.open(file_name, 'rb') as image_file:
        content = image_file.read()

    return content


def write_tmp(content, file_path):
    #  make sure dir exist or create one
    os.makedirs(os.path.dirname(file_path), exist_ok=True)

    newFile = open(file_path, "wb")

    print('writing.......')

    newFile.write(content)
