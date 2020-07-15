import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReservationSpotComponent } from './reservation-spot.component';

describe('ReservationSpotComponent', () => {
  let component: ReservationSpotComponent;
  let fixture: ComponentFixture<ReservationSpotComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReservationSpotComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReservationSpotComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
