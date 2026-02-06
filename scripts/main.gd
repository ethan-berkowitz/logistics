extends Node2D

@onready var money_label: Label = $OtherLabels/MoneyLabel

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
	bike = Vehicle.new("Bike", 10, 5, 1.0, 0, 0, 0, 0.0, false, bike_label, bike_status_bar, bike_purchase, bike_staff)
	#bike_purchase.pressed.connect(vehicle_purchase_pressed.bind(bike))
	all_vehicles.append(bike)
	
	van = Vehicle.new("Van", 20, 100, 30.0, 0, 0, 0, 0.0, true, van_label, van_status_bar, van_purchase, van_staff)
	#van_purchase.pressed.connect(vehicle_purchase_pressed.bind(van))
	all_vehicles.append(van)

	truck = Vehicle.new("Truck", 50, 300, 40.0, 0, 0, 0, 0.0, true, truck_label, truck_status_bar, truck_purchase, truck_staff)
	##truck_purchase.pressed.connect(vehicle_purchase_pressed.bind(truck))
	all_vehicles.append(truck)
	
	connect_all_vehicle_buttons()
	update_money(0)
	update_all_vehicle_text()
	update_all_value_labels()


func connect_all_vehicle_buttons():
	for vehicle in all_vehicles:
		vehicle.purchase_button.pressed.connect(vehicle_purchase_pressed.bind(vehicle))
		vehicle.staff_control.unary_operators.increment.pressed.connect(vehicle_staff_pressed.bind(vehicle, 1))
		vehicle.staff_control.unary_operators.decrement.pressed.connect(vehicle_staff_pressed.bind(vehicle, -1))

func vehicle_staff_pressed(vehicle: Vehicle, value: int):
	vehicle.staff += value
	print(str(vehicle.type) + " staff = " + str(vehicle.staff))

func _process(delta):
	update_all_vehicle_status(delta)

func vehicle_purchase_pressed(vehicle: Vehicle):
	if money >= vehicle.price * buy_mult:
		update_money(-vehicle.price * buy_mult)
		vehicle.purchase(buy_mult)
		unlock_vehicles()

func update_money(change: int):
	money += change
	money_label.text = "$" + str(money)
	
func update_all_vehicle_text():
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
