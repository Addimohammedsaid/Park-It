from flask import escape
import utils
import localization
import database
import predict


def hello_http(requests):

    print("function start")

    try:

        # # save data to firebase barrier
        # database.write_to_barrier()

        file_car_path = "/tmp/car.jpg"

        # write the image to an temporary folder
        utils.write_tmp(requests.data, file_car_path)

        fileSavePath = utils.randomString()

        fileSavePath = "images/-MB9f1lIglsLw2hpA4a9/"+fileSavePath+"jpg"

        print(fileSavePath)

        # save image to bucket
        car_image = database.saveImageToBucket(
            fileLocationPath=file_car_path, fileSavePath=fileSavePath)

        # save data to firebase barrier
        database.write_to_barrier(
            car_image=car_image)

        # return a binary image filtered
        car_image_binary = localization.ImageToBinary(file_car_path)

        # return the located plate
        licensePlateObject = localization.cca2(car_image_binary)

        # save the object plate as jpg image
        file_plate_path = "/tmp/plate.jpg"

        utils.object_to_image(licensePlateObject, file_plate_path)

        fileSavePath = ""

        fileSavePath = "images/-MB9f1lIglsLw2hpA4a9/"+fileSavePath+"jpg"

        # save image to bucket
        car_plate = database.saveImageToBucket(
            fileLocationPath=file_plate_path, fileSavePath=fileSavePath)

        # save data to firebase barrier
        database.write_to_barrier(
            car_image=car_image, car_plate=car_plate)

        # read plate image
        plate_image_binary = utils.read_tmp(file_plate_path)

        # call vision api
        result = predict.predict_text(plate_image_binary)

        # save data to firebase barrier
        database.write_to_barrier(
            car_image=car_image, car_plate=car_plate, car_number=result)

        # check if license plate exist in reservations
        response = database.read_reservation(result)

        print(response)

        return response

    except:

        return 'Not Found', 404
