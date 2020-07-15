import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ListParkingsComponent } from './list-parkings.component';

describe('ListParkingsComponent', () => {
  let component: ListParkingsComponent;
  let fixture: ComponentFixture<ListParkingsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ListParkingsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ListParkingsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
