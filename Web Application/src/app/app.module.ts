import { BrowserModule } from "@angular/platform-browser";
import { NgModule } from "@angular/core";

import { AppComponent } from "./app.component";
import { EditParkingComponent } from "./comp/edit-parking/edit-parking.component";
import { AddParkingComponent } from "./comp/add-parking/add-parking.component";
import { LoginComponent } from "./comp/login/login.component";
import { RegisterComponent } from "./comp/register/register.component";
import { RouterModule } from "@angular/router";
import { NavBarComponent } from "./comp/nav-bar/nav-bar.component";
import { FooterComponent } from "./comp/footer/footer.component";

import { AngularFireModule } from "@angular/fire";
import { AngularFireDatabaseModule } from "@angular/fire/database";
import { environment } from "../environments/environment";
import { FormsModule } from "@angular/forms";
import { DetailsParkingComponent } from "./comp/details-parking/details-parking.component";
import { ListParkingsComponent } from "./comp/list-parkings/list-parkings.component";
import { ReservationSpotComponent } from "./comp/reservation-spot/reservation-spot.component";

@NgModule({
  declarations: [
    AppComponent,
    EditParkingComponent,
    AddParkingComponent,
    LoginComponent,
    RegisterComponent,
    NavBarComponent,
    FooterComponent,
    DetailsParkingComponent,
    ListParkingsComponent,
    ReservationSpotComponent,
  ],
  imports: [
    BrowserModule,
    FormsModule,
    AngularFireModule.initializeApp(environment.firebase),
    AngularFireDatabaseModule, // for database
    RouterModule.forRoot([
      { path: "", component: ListParkingsComponent },
      { path: "add/parking", component: AddParkingComponent },
      { path: "edit/parking", component: EditParkingComponent },
      { path: "details/parking", component: DetailsParkingComponent },
      {
        path: "details/parking/reservations",
        component: ReservationSpotComponent,
      },
      { path: "user/login", component: LoginComponent },
      { path: "user/register", component: RegisterComponent },
      { path: "**", component: LoginComponent },
    ]),
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
