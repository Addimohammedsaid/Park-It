import { DatabaseService } from "./../../services/database.service";
import { Component, OnInit } from "@angular/core";
import { Parking } from "src/app/models/parking.model";

@Component({
  selector: "app-add-parking",
  templateUrl: "./add-parking.component.html",
  styleUrls: ["./add-parking.component.css"],
})
export class AddParkingComponent implements OnInit {
  parking: Parking = new Parking();
  submitted = false;

  constructor(private databaseService: DatabaseService) {}

  ngOnInit() {}

  newParking(): void {
    this.submitted = false;
    this.parking = new Parking();
  }

  save() {
    this.databaseService.createParking(this.parking);
    this.parking = new Parking();
  }

  onSubmit() {
    this.submitted = true;
    this.save();
  }
}
