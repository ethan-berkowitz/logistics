extends Node2D

@onready var money_label: Label = $OtherLabels/MoneyLabel

@onready var bike_label: Label = $VehicleLabels/BikeLabel
@onready var bike_purchase: Button = $Buttons/BikePurchase
@onready var bike_status_bar: ProgressBar = $Status/BikeStatusBar
@onready var bike_staff = $Staff/BikeStaff
@onready var van_purchase: Button = $Buttons/VanPurchase
@onready var van_label: Label = $VehicleLabels/VanLabel
@onready var van_status_bar: ProgressBar = $Status/VanStatusBar
@onready var truck_purchase: Button = $Buttons/TruckPurchase
@onready var truck_label: Label = $VehicleLabels/TruckLabel
@onready var truck_status_bar: ProgressBar = $Status/TruckStatusBar

var money := 10
var buy_mult := 1
var bike: Vehicle
var van: Vehicle
var truck: Vehicle
var all_vehicles: Array[Vehicle]
var staff := 5

func _ready():

	#bike_staff.unary_operators.increment.pressed.connect(bike_staff_pressed)
	
	# price, value, duration
	bike = Vehicle.new("Bike", 10, 5, 1.0, 0, 0, 0, 0.0, false, bike_label, bike_status_bar, bike_purchase)
	bike_purchase.pressed.connect(bike_pressed)
	all_vehicles.append(bike)
	
	van = Vehicle.new("Van", 20, 100, 30.0, 0, 0, 0, 0.0, true, van_label, van_status_bar, van_purchase)
	van_purchase.pressed.connect(van_pressed)
	all_vehicles.append(van)

	truck = Vehicle.new("Truck", 50, 300, 40.0, 0, 0, 0, 0.0, true, truck_label, truck_status_bar, truck_purchase)
	truck_purchase.pressed.connect(truck_pressed)
	all_vehicles.append(truck)

	update_money(0)
	update_all_vehicle_text(all_vehicles)
	update_all_value_labels()

#func bike_staff_pressed():
#	staff += 1
#	print("staff = " + str(staff))

func _process(delta):
		
	update_all_vehicle_status(delta)

func bike_pressed():
	if money >= bike.price * buy_mult:
		update_money(-bike.price * buy_mult)
		bike.purchase(buy_mult)
		unlock_vehicles()
		
func van_pressed():
	if money >= van.price * buy_mult:
		update_money(-van.price * buy_mult)
		van.purchase(buy_mult)
		unlock_vehicles()
		
func truck_pressed():
	if money >= truck.price * buy_mult:
		update_money(-truck.price * buy_mult)
		truck.purchase(buy_mult)
		unlock_vehicles()

func update_money(change: int):
	money += change
	money_label.text = "$" + str(money)
	
func update_all_vehicle_text(all_vehicles: Array[Vehicle]):
	for vehicle in all_vehicles:
		vehicle.update_text(buy_mult)
		
func update_all_value_labels():
	for vehicle in all_vehicles:
		vehicle.update_value_label()
		
func update_all_vehicle_status(delta):
	for vehicle in all_vehicles:
		vehicle.update_per_second_label()
		if vehicle.amount > 0:
			vehicle.status += delta * vehicle.amount
			vehicle.status_bar.value = vehicle.status / vehicle.duration
			if vehicle.status >= vehicle.duration:
				vehicle.status = 0.0
				update_money(vehicle.value)
				
func unlock_vehicles():
	if bike.amount >= 5:
		van.update_disabled(false)
	if van.amount >= 5:
		truck.update_disabled(false)
