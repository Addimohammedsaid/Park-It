import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import storage


cred = credentials.Certificate("./firebase.json")
firebase_admin.initialize_app(cred, options={
    'storageBucket': "iot-parking-8b09e.appspot.com",
    'databaseURL': 'https://iot-parking-8b09e.firebaseio.com',
})


reservations = db.reference()


def read_reservation(k):
    print(reservations)
    print(k)
    reserved = reservations.child('reservations').child(k).get()
    print(reserved)
    if not reserved:
        return 'Resource not found', 404
    return "Found"

    # save image to bucket
    bucket = storage.bucket()
    b = bucket.blob('images/licence_plate/car3.jpg')
    b.upload_from_filename('car.jpg', content_type='image/jpg')
    b.make_public()
    print('model uploaded!')
    print(b.public_url)
