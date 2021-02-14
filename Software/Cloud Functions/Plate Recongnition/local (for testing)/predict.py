import io
import os
import png
from google.cloud.vision import types
from google.cloud import vision

# Instantiates a client
client = vision.ImageAnnotatorClient()


def predict_text(content):
    image = types.Image(content=content)
    # Performs label detection on the image file
    response = client.text_detection(image=image)
    # Labels
    labels = response.text_annotations
    # Take out 1st Label
    result = labels[0].description
    # Remove any white space
    result = result.replace(" ", "")
    result = result[0:10]

    return result
