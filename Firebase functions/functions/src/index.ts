// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// init before use
admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();
const ref = admin.database().ref();

const payloadTimeEnded: admin.messaging.MessagingPayload = {
  notification: {
    title: "Time Has Ended",
    body: "Your reservation is out some charges will be applied",
    clickAction: "FLUTTER_NOTIFICATION_CLICK"
  }
};

const payloadTimeLeft: admin.messaging.MessagingPayload = {
  notification: {
    title: "Reservation will be Expired",
    body:
      "less then 5 min or more left for your reservation some charges will be applied",
    clickAction: "FLUTTER_NOTIFICATION_CLICK"
  }
};

// google scheduler timing routine
export const updateEmpty = functions.pubsub
  .topic("incEmpty")
  .onPublish(async function (event) {
    // this is a ref to the database
    const now = new Date().getTime();
    const penaltyCoefficeint: number = 2;

    // this is for getting a value from firebase database
    await ref.once("value", async function (snapshot) {
      const jsonObject = snapshot.val();
      for (const k in jsonObject["reservations"]) {
        const to: number = jsonObject["reservations"][k]["to"];
        const from: number = jsonObject["reservations"][k]["from"];
        const spot: string = jsonObject["reservations"][k]["spot"];
        const parking: string = jsonObject["reservations"][k]["parking"];

        const userId: string = jsonObject["reservations"][k]["userId"];
        const wallet: number = jsonObject["users"][userId]["wallet"];

        const userToken: string =
          jsonObject["users"][userId]["tokens"]["token"];

        if (
          jsonObject["parkings"][parking]["spots"][spot]["reserved"] == false &&
          jsonObject["parkings"][parking]["spots"][spot]["occupied"] == true
        ) {
          await ref
            .child("users")
            .child(userId)
            .update({
              wallet: wallet + (penaltyCoefficeint * (to - now)) / 10000
            });
        }

        // check if it's already reserved
        if (
          jsonObject["parkings"][parking]["spots"][spot]["reserved"] == true ||
          jsonObject["parkings"][parking]["spots"][spot]["occupied"] == true
        ) {
          // check if 5 min send notification
          if (to - now <= 340000 && to - now >= 270000) {
            fcm.sendToDevice(userToken, payloadTimeLeft).catch(er => {
              console.log(er);
              return er;
            });
          }

          // if that has been true then check if the date is not over
          if (to - now < 0) {
            await ref
              .child("parkings")
              .child(parking)
              .child("spots")
              .child(spot)
              .update({
                reserved: false
              });

            fcm.sendToDevice(userToken, payloadTimeEnded).catch(er => {
              console.log(er);
              return er;
            });

            if (
              jsonObject["parkings"][parking]["spots"][spot]["occupied"] ==
              false
            ) {
              ref
                .child("reservations")
                .child(k)
                .remove()
                .catch(er => {
                  console.log(er);
                  return er;
                });

              ref
                .child("users")
                .child(userId)
                .child("reservation")
                .remove()
                .catch(er => {
                  console.log(er);
                  return er;
                });
            }
          }
        }
        // // otherwise we check if the date of reservation has been attend
        // else if (from - now < 0 && to - now > 0) {
        //   // true then we update database that the spot is now in the reserved period
        //   await ref
        //     .child("parkings")
        //     .child(parking)
        //     .child("spots")
        //     .child(spot)
        //     .update({
        //       reserved: true
        //     });
        // }
      }
    });
  });
