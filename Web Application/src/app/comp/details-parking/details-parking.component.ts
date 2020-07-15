import { Parking } from "src/app/models/parking.model";
import { Component, OnInit, Input } from "@angular/core";

@Component({
  selector: "app-details-parking",
  templateUrl: "./details-parking.component.html",
  styleUrls: ["./details-parking.component.css"],
})
export class DetailsParkingComponent implements OnInit {
  @Input() parking: Parking;

  constructor() {}

  ngOnInit() {}
}
