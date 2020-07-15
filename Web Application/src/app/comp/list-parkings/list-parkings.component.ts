import { DatabaseService } from "./../../services/database.service";
import { Component, OnInit } from "@angular/core";
import { map } from "rxjs/operators";

@Component({
  selector: "app-list-parkings",
  templateUrl: "./list-parkings.component.html",
  styleUrls: ["./list-parkings.component.css"],
})
export class ListParkingsComponent implements OnInit {
  parkings: any;

  constructor(private databaseService: DatabaseService) {}

  ngOnInit() {
    this.getParkingList();
  }

  getParkingList() {
    this.databaseService
      .getParkingsList()
      .snapshotChanges()
      .pipe(
        map((changes) =>
          changes.map((c) => ({ key: c.payload.key, ...c.payload.val() }))
        )
      )
      .subscribe((parkings) => {
        this.parkings = parkings;
      });
  }

  deleteParkings() {
    this.databaseService.deleteAll().catch((err) => console.log(err));
  }
}
