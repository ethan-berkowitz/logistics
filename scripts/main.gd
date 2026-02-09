extends Node2D

@onready var money_label: Label = $OtherLabels/MoneyLabel

@onready var unassigned_staff_label: Label = $Staff/UnassignedStaff
@onready var total_staff_label: Label = $Staff/TotalStaff
@onready var recruit_status_bar = $Staff/RecruitStatusBar
@onready var hire_staff_button = $Staff/HireStaffButton

@onready var x1_button = $x1_button
@onready var x10_button = $x10_button
@onready var max_button = $max_button

@onready var bike_label: Label = $VehicleLabels/BikeLabel
@onready var bike_purchase: Button = $Buttons/BikePurchase
@onready var bike_status_bar: ProgressBar = $Status/BikeStatusBar
@onready var bike_staff = $Staff/BikeStaff

@onready var van_purchase: Button = $Buttons/VanPurchase
@onready var van_label: Label = $VehicleLabels/VanLabel
@onready var van_status_bar: ProgressBar = $Status/VanStatusBar
@onready var van_staff = $Staff/VanStaff

@onready var truck_purchase: Button = $Buttons/TruckPurchase
@onready var truck_label: Label = $VehicleLabels/TruckLabel
@onready var truck_status_bar: ProgressBar = $Status/TruckStatusBar
@onready var truck_staff = $Staff/TruckStaff

@onready var plane_purchase = $Buttons/PlanePurchase
@onready var plane_label = $VehicleLabels/PlaneLabel
@onready var plane_status_bar = $Status/PlaneStatusBar
@onready var plane_staff = $Staff/PlaneStaff

@onready var boat_purchase = $Buttons/BoatPurchase
@onready var boat_label = $VehicleLabels/BoatLabel
@onready var boat_status_bar = $Status/BoatStatusBar
@onready var boat_staff = $Staff/BoatStaff

@onready var train_purchase = $Buttons/TrainPurchase
@onready var train_label = $VehicleLabels/TrainLabel
@onready var train_status_bar = $Status/TrainStatusBar
@onready var train_staff = $Staff/TrainStaff

@onready var portal_purchase = $Buttons/PortalPurchase
@onready var portal_label = $VehicleLabels/PortalLabel
@onready var portal_status_bar = $Status/PortalStatusBar
@onready var portal_staff = $Staff/PortalStaff

var money := 100000
var buy_mult := 1
var all_vehicles: Array[Vehicle]

var bike: Vehicle
var van: Vehicle
var truck: Vehicle
var plane: Vehicle
var boat: Vehicle
var train: Vehicle
var portal: Vehicle

var unassigned_staff := 5
var total_staff := 5
var recruit_status := 0.0
var recruit_duration := 20.0
var recruit_duration_inc := 1.13
var hire_staff_price := 100
var hire_staff_price_inc := 1.25

func _ready():
	# price, value, duration
	bike = Vehicle.new("Bike", 10, 5, 5.0, 0, 0, 0, 0.0, false, bike_label, bike_status_bar, bike_purchase, bike_staff)
	all_vehicles.append(bike)
	
	van = Vehicle.new("Van", 20, 50, 25.0, 0, 0, 0, 0.0, true, van_label, van_status_bar, van_purchase, van_staff)
	all_vehicles.append(van)

	truck = Vehicle.new("Truck", 50, 200, 50.0, 0, 0, 0, 0.0, true, truck_label, truck_status_bar, truck_purchase, truck_staff)
	all_vehicles.append(truck)
	
	plane = Vehicle.new("Plane", 200, 500, 100.0, 0, 0, 0, 0.0, true, plane_label, plane_status_bar, plane_purchase, plane_staff)
	all_vehicles.append(plane)
	
	boat = Vehicle.new("Boat", 500, 1500, 150.0, 0, 0, 0, 0.0, true, boat_label, boat_status_bar, boat_purchase, boat_staff)
	all_vehicles.append(boat)
	
	train = Vehicle.new("Train", 1000, 3000, 200, 0, 0, 0, 0.0, true, train_label, train_status_bar, train_purchase, train_staff)
	all_vehicles.append(train)
	
	portal = Vehicle.new("Portal", 2000, 10000, 500, 0, 0, 0, 0.0, true, portal_label, portal_status_bar, portal_purchase, portal_staff)
	all_vehicles.append(portal)
	
	hire_staff_button.pressed.connect(hire_staff)
	
	# Mult Buttons
	x1_button.button_pressed = true
	x1_button.pressed.connect(update_multiplier.bind(1))
	x10_button.pressed.connect(update_multiplier.bind(10))
	max_button.pressed.connect(update_multiplier.bind(100))
	
	connect_all_vehicle_buttons()
	update_money(0)
	update_all_vehicle_purchase_text()
	update_all_value_labels()
	update_hire_staff_text()

func update_multiplier(value: int):
	if value == 1:
		x10_button.button_pressed = false
		max_button.button_pressed = false
	elif value == 10:
		x1_button.button_pressed = false
		max_button.button_pressed = false
	else:
		x1_button.button_pressed = false
		x10_button.button_pressed = false
	buy_mult = value
	update_all_vehice_price_with_mult(buy_mult)
	update_all_vehicle_purchase_text()

func update_all_vehice_price_with_mult(buy_mult):
	for vehicle in all_vehicles:
		vehicle.update_price_with_mult(buy_mult)

func hire_staff():
	if money >= hire_staff_price:
		update_money(-hire_staff_price)
		hire_staff_price *= hire_staff_price_inc
		unassigned_staff += 1
		total_staff += 1
		update_staff_text()
		update_hire_staff_text()

func update_hire_staff_text():
	hire_staff_button.text = "Hire Staff\n$" + str(hire_staff_price)

func _process(delta):
	update_all_vehicle_status(delta)
	update_recruitment(delta)

func update_recruitment(delta):
	recruit_status += delta
	recruit_status_bar.value = recruit_status / recruit_duration
	if recruit_status >= recruit_duration:
		recruit_status = 0.0
		recruit_duration *= recruit_duration_inc
		unassigned_staff += 1
		total_staff += 1
		update_staff_text()

func connect_all_vehicle_buttons():
	for vehicle in all_vehicles:
		vehicle.purchase_button.pressed.connect(vehicle_purchase_pressed.bind(vehicle))
		vehicle.staff_control.unary_operators.increment.pressed.connect(vehicle_staff_pressed.bind(vehicle, 1))
		vehicle.staff_control.unary_operators.decrement.pressed.connect(vehicle_staff_pressed.bind(vehicle, -1))

func vehicle_staff_pressed(vehicle: Vehicle, value: int):
	if (value > 0 and unassigned_staff > 0) or (value < 0 and vehicle.staff > 0):
		vehicle.staff += value
		unassigned_staff -= value
		vehicle.update_per_second_label()
		update_staff_text()
		update_all_vehicle_staff_text()

func vehicle_purchase_pressed(vehicle: Vehicle):
	if money >= vehicle.price_with_mult:
		update_money(-vehicle.price_with_mult)
		vehicle.purchase(buy_mult)
		unlock_vehicles()

func update_money(change: int):
	money += change
	money_label.text = "$" + str(money)
	
func update_staff_text():
	total_staff_label.text = str(total_staff)
	unassigned_staff_label.text = str(unassigned_staff)
	
func update_all_vehicle_purchase_text():
	for vehicle in all_vehicles:
		vehicle.update_purchase_text(buy_mult)
		
func update_all_vehicle_staff_text():
	for vehicle in all_vehicles:
		vehicle.update_staff_text()
		
func update_all_value_labels():
	for vehicle in all_vehicles:
		vehicle.update_value_label()
		
func update_all_vehicle_status(delta):
	for vehicle in all_vehicles:
		vehicle.update_per_second_label()
		if vehicle.amount > 0 and vehicle.staff > 0:
			vehicle.status += delta * min(vehicle.amount, vehicle.staff)
			vehicle.status_bar.value = vehicle.status / vehicle.duration
			if vehicle.status >= vehicle.duration:
				vehicle.status = 0.0
				update_money(vehicle.value)
				
func unlock_vehicles():
	if bike.amount >= 5:
		van.update_disabled(false)
	if van.amount >= 5:
		truck.update_disabled(false)
	if truck.amount >= 5:
		plane.update_disabled(false)
	if plane.amount >= 5:
		boat.update_disabled(false)
	if boat.amount >= 5:
		train.update_disabled(false)
	if train.amount >= 5:
		portal.update_disabled(false)
