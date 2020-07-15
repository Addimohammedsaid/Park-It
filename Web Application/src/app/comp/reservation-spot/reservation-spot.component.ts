import { ReservationModel } from "./../../models/reservation.model";
import { ImageModel } from "./../../models/image.model";
import { DatabaseService } from "./../../services/database.service";
import { Component, OnInit, Input } from "@angular/core";
import { map } from "rxjs/operators";

@Component({
  selector: "app-reservation-spot",
  templateUrl: "./reservation-spot.component.html",
  styleUrls: ["./reservation-spot.component.css"],
})
export class ReservationSpotComponent implements OnInit {
  @Input() spots: [];

  result: any;

  reservations: any;

  constructor(private databaseService: DatabaseService) {}

  ngOnInit() {
    this.result = Object.keys(this.spots).map((e) => this.spots[e]);
    this.getReservationsSpot();
  }

  getReservationsSpot() {
    this.databaseService
      .getReservationsList()
      .snapshotChanges()
      .pipe(
        map((changes) =>
          changes.map((c) => ({ key: c.payload.key, ...c.payload.val() }))
        )
      )
      .subscribe((reservation) => {
        this.reservations = reservation;
        console.log(this.reservations[3].images.car_image);
      });
  }
}
