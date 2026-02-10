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

func on_close_menu_pressed():
	visible = false

func on_research_node_pressed(node):
	if node.active:
		for other in all_research_nodes:
			if other != node:
				other.active = false
	
