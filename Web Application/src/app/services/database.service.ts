import { ReservationModel } from "./../models/reservation.model";
import { Parking } from "./../models/parking.model";
import { Injectable } from "@angular/core";
import { AngularFireDatabase, AngularFireList } from "@angular/fire/database";

@Injectable({
  providedIn: "root",
})
export class DatabaseService {
  private dbPath = "/parkings";
  private dbPathReservation = "/reservations";

  parkingRef: AngularFireList<Parking> = null;

  ReservationRef: AngularFireList<ReservationModel> = null;

  constructor(private db: AngularFireDatabase) {
    this.parkingRef = db.list(this.dbPath);
    this.ReservationRef = db.list(this.dbPathReservation);
  }

  createParking(parking: Parking): void {
    this.parkingRef.push(parking);
  }

  updateParking(key: string, value: any): Promise<void> {
    return this.parkingRef.update(key, value);
  }

  deleteParking(key: string): Promise<void> {
    return this.parkingRef.remove(key);
  }

  getParkingsList(): AngularFireList<Parking> {
    return this.parkingRef;
  }

  getReservationsList(): AngularFireList<ReservationModel> {
    return this.ReservationRef;
  }

  deleteAll(): Promise<void> {
    return this.parkingRef.remove();
  }
}
