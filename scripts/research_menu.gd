extends Sprite2D

@onready var hr = $ResearchTypes/HR
@onready var marketing = $ResearchTypes/Marketing
@onready var maintenence = $ResearchTypes/Maintenence
@onready var contractors = $ResearchTypes/Contractors
@onready var marketing_power = $ResearchTypes/MarketingPower
@onready var railway_management = $ResearchTypes/RailwayManagement
@onready var efficiency = $ResearchTypes/Efficiency
@onready var synergies = $ResearchTypes/Synergies
@onready var advanced_r_d = $"ResearchTypes/Advanced R&D"

@onready var close_menu = $CloseMenu
@onready var staff_control = $StaffControl

var all_research_nodes = []
var staff := 0

func _ready():
	all_research_nodes = [
		hr,
		marketing,
		maintenence,
		contractors,
		marketing_power,
		railway_management,
		efficiency,
		synergies,
		advanced_r_d
	]
	for node in all_research_nodes:
		node.button.pressed.connect(on_research_node_pressed.bind(node))
	close_menu.pressed.connect(on_close_menu_pressed)
	
	update_all_research_nodes_text()

func update_all_research_nodes_text():
	hr.update_text("HR")
	marketing.update_text("Marketing")
	maintenence.update_text("Maintenence")
	contractors.update_text("Contractors")
	marketing_power.update_text("Marketing Power")
	railway_management.update_text("Railway Management")
	efficiency.update_text("Efficiency")
	synergies.update_text("Synergies")
	advanced_r_d.update_text("Advanced R&D")

func on_close_menu_pressed():
	visible = false

func on_research_node_pressed(node):
	node.staff = staff
	if node.active:
		for other in all_research_nodes:
			if other != node:
				other.active = false

func update_all_research_node_staff():
	for node in all_research_nodes:
		node.staff = staff
				
func update_staff_text():
	staff_control.staff_amount_label.text = str(staff)
