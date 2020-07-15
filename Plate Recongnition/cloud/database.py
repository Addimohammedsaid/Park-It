import firebase_admin
from firebase_admin import db
from firebase_admin import storage

firebase_admin.initialize_app(options={
    'storageBucket': "iot-parking-8b09e.appspot.com",
    'databaseURL': 'https://iot-parking-8b09e.firebaseio.com',
})


dbReference = db.reference()


def read_reservation(key):
    print(key)
    reserved = dbReference.child("reservations").child(key).get()
    print(reserved)
    if not reserved:
        return 'Resource not found', 404
    return "Found"


def write_to_barrier(car_image=" ", car_plate=" ", car_number="not found"):
    dbReference.child("parkings").child("-MB9f1lIglsLw2hpA4a9").child("barrier").update({
        "car_image": car_image,
        "car_plate": car_plate,
        "car_number": car_number,
    })


def saveImageToBucket(fileSavePath, fileLocationPath):
    # save image to bucket
    bucket = storage.bucket()
    b = bucket.blob(fileSavePath)
    b.upload_from_filename(fileLocationPath, content_type='image/jpg')
    b.make_public()
    print('model uploaded!')
    return b.public_url
