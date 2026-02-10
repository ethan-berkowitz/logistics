extends Node2D

@onready var money_label: Label = $OtherLabels/MoneyLabel

@onready var unassigned_staff_label: Label = $Staff/UnassignedStaff
@onready var total_staff_label: Label = $Staff/TotalStaff
@onready var recruit_status_bar = $Staff/RecruitStatusBar
@onready var hire_staff_button = $Staff/HireStaffButton

@onready var x1_button = $MultiplierButtons/x1_button
@onready var x10_button = $MultiplierButtons/x10_button
@onready var max_button = $MultiplierButtons/max_button

@onready var research_menu = $Menus/ResearchMenu
@onready var research_button = $Menus/ResearchButton

@onready var bike_label: Label = $VehicleLabels/BikeLabel
@onready var bike_purchase: Button = $Buttons/BikePurchase
@onready var bike_status_bar: ProgressBar = $Status/BikeStatusBar
@onready var bike_staff = $Staff/BikeStaff
@onready var bike_orders = $OrderLabels/BikeOrdersLabel

@onready var van_purchase: Button = $Buttons/VanPurchase
@onready var van_label: Label = $VehicleLabels/VanLabel
@onready var van_status_bar: ProgressBar = $Status/VanStatusBar
@onready var van_staff = $Staff/VanStaff
@onready var van_orders = $OrderLabels/VanOrdersLabel

@onready var truck_purchase: Button = $Buttons/TruckPurchase
@onready var truck_label: Label = $VehicleLabels/TruckLabel
@onready var truck_status_bar: ProgressBar = $Status/TruckStatusBar
@onready var truck_staff = $Staff/TruckStaff
@onready var truck_orders = $OrderLabels/TruckOrdersLabel

@onready var plane_purchase = $Buttons/PlanePurchase
@onready var plane_label = $VehicleLabels/PlaneLabel
@onready var plane_status_bar = $Status/PlaneStatusBar
@onready var plane_staff = $Staff/PlaneStaff
@onready var plane_orders = $OrderLabels/PlaneOrdersLabel

@onready var boat_purchase = $Buttons/BoatPurchase
@onready var boat_label = $VehicleLabels/BoatLabel
@onready var boat_status_bar = $Status/BoatStatusBar
@onready var boat_staff = $Staff/BoatStaff
@onready var boat_orders = $OrderLabels/BoatOrdersLabel

@onready var train_purchase = $Buttons/TrainPurchase
@onready var train_label = $VehicleLabels/TrainLabel
@onready var train_status_bar = $Status/TrainStatusBar
@onready var train_staff = $Staff/TrainStaff
@onready var train_orders = $OrderLabels/TrainOrdersLabel

@onready var portal_purchase = $Buttons/PortalPurchase
@onready var portal_label = $VehicleLabels/PortalLabel
@onready var portal_status_bar = $Status/PortalStatusBar
@onready var portal_staff = $Staff/PortalStaff
@onready var portal_orders = $OrderLabels/PortalOrdersLabel

var money := 100000
var active_multiplier := 1
var all_vehicles: Array[Vehicle]

var bike: Vehicle
var van: Vehicle
var truck: Vehicle
var plane: Vehicle
var boat: Vehicle
var train: Vehicle
var portal: Vehicle

var unassigned_staff := 50
var total_staff := 50
var recruit_status := 0.0
var recruit_duration := 20.0
var recruit_duration_inc := 1.13
var hire_staff_price := 100
var hire_staff_price_inc := 1.25
var recruit_unlocked = false

func _ready():
	init_vehicles()
	init_other_buttons()
	connect_all_vehicle_buttons()
	update_money(0)
	update_all_vehicle_purchase_text()
	update_all_value_labels()
	update_hire_staff_text()
	connect_research_menu_nodes()
	connect_research_menu_unary()

func connect_research_menu_nodes():
	for node in research_menu.all_research_nodes:
		node.sig_complete.connect(research_complete.bind(node))

func research_complete(type):
	if type == research_menu.hr:
		recruit_unlocked = true
	if type == research_menu.marketing:
		pass
	if type == research_menu.contractors:
		hire_staff_button.visible = true
	pass

func _process(delta):
	update_all_vehicle_status(delta)
	if recruit_unlocked:
		update_recruitment(delta)

func init_vehicles():
	bike = Vehicle.new("Bike", 10, 5, 5.0, 0, 0, 50, 0.0, false, bike_label, bike_status_bar, bike_purchase, bike_staff)
	all_vehicles.append(bike)
	
	van = Vehicle.new("Van", 20, 50, 25.0, 0, 0, 50, 0.0, true, van_label, van_status_bar, van_purchase, van_staff)
	all_vehicles.append(van)

	truck = Vehicle.new("Truck", 50, 200, 50.0, 0, 0, 50, 0.0, true, truck_label, truck_status_bar, truck_purchase, truck_staff)
	all_vehicles.append(truck)
	
	plane = Vehicle.new("Plane", 200, 500, 100.0, 0, 0, 50, 0.0, true, plane_label, plane_status_bar, plane_purchase, plane_staff)
	all_vehicles.append(plane)
	
	boat = Vehicle.new("Boat", 500, 1500, 150.0, 0, 0, 50, 0.0, true, boat_label, boat_status_bar, boat_purchase, boat_staff)
	all_vehicles.append(boat)
	
	train = Vehicle.new("Train", 1000, 3000, 200, 0, 0, 50, 0.0, true, train_label, train_status_bar, train_purchase, train_staff)
	all_vehicles.append(train)
	
	portal = Vehicle.new("Portal", 2000, 10000, 500, 0, 0, 50, 0.0, true, portal_label, portal_status_bar, portal_purchase, portal_staff)
	all_vehicles.append(portal)

func init_other_buttons():
	hire_staff_button.pressed.connect(hire_staff)
	research_button.pressed.connect(open_research_menu)
	# Mult Buttons
	x1_button.button_pressed = true
	x1_button.pressed.connect(update_multiplier.bind(1))
	x10_button.pressed.connect(update_multiplier.bind(10))
	max_button.pressed.connect(update_multiplier.bind(100))
	
	hire_staff_button.visible = false

func connect_research_menu_unary():
	research_menu.staff_control.unary_operators.increment.pressed.connect(research_staff_pressed.bind(1))
	research_menu.staff_control.unary_operators.decrement.pressed.connect(research_staff_pressed.bind(-1))

func research_staff_pressed(value: int):
	print("staff pressed: " + str(value))
	if ((value == 1 and unassigned_staff >= value * active_multiplier)
		or (value == -1 and research_menu.staff >= active_multiplier)):
		research_menu.staff += value * active_multiplier
		unassigned_staff -= value * active_multiplier
	elif value == -1 and research_menu.staff > 0:
		unassigned_staff += research_menu.staff
		research_menu.staff = 0
	research_menu.update_staff_text()
	research_menu.update_all_research_node_staff()
	update_staff_text()
	

func connect_all_vehicle_buttons():
	for vehicle in all_vehicles:
		vehicle.purchase_button.pressed.connect(vehicle_purchase_pressed.bind(vehicle))
		vehicle.staff_control.unary_operators.increment.pressed.connect(vehicle_staff_pressed.bind(vehicle, 1))
		vehicle.staff_control.unary_operators.decrement.pressed.connect(vehicle_staff_pressed.bind(vehicle, -1))

func update_money(change: int):
	money += change
	money_label.text = "$" + str(money)

func update_all_vehicle_purchase_text():
	for vehicle in all_vehicles:
		vehicle.update_purchase_text(active_multiplier)
func open_research_menu():
	research_menu.visible = true

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
	active_multiplier = value
	update_all_vehice_price_with_mult(active_multiplier)
	update_all_vehicle_purchase_text()

func update_all_vehice_price_with_mult(active_multiplier):
	for vehicle in all_vehicles:
		vehicle.update_price_with_mult(active_multiplier)

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

func update_recruitment(delta):
	recruit_status += delta
	recruit_status_bar.value = recruit_status / recruit_duration
	if recruit_status >= recruit_duration:
		recruit_status = 0.0
		recruit_duration *= recruit_duration_inc
		unassigned_staff += 1
		total_staff += 1
		update_staff_text()

func vehicle_staff_pressed(vehicle: Vehicle, value: int):
	if ((value == 1 and unassigned_staff >= value * active_multiplier)
		or (value == -1 and vehicle.staff >= active_multiplier)):
		vehicle.staff += value * active_multiplier
		unassigned_staff -= value * active_multiplier
	elif value == -1 and vehicle.staff > 0:
		unassigned_staff += vehicle.staff
		vehicle.staff = 0
	vehicle.update_per_second_label()
	update_staff_text()
	update_all_vehicle_staff_text()

func vehicle_purchase_pressed(vehicle: Vehicle):
	if money >= vehicle.price_with_mult:
		update_money(-vehicle.price_with_mult)
		vehicle.purchase(active_multiplier)
		unlock_vehicles()
	
func update_staff_text():
	total_staff_label.text = str(total_staff)
	unassigned_staff_label.text = str(unassigned_staff)
		
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
