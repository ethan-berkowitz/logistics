@tool
extends Control

@onready var button: Button = $Button
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label

var staff := 0
var status := 0.0
var duration := 10.0
var active := false
var complete := false

func _ready():
	button.pressed.connect(on_button_pressed)

func _process(delta):
	if active:
		status += delta * staff
		var progress = status / duration
		progress_bar.value = progress
		if progress >= 1:
			complete = true
			active = false

func on_button_pressed():
	print("pressed")
	if !complete:
		active = true
		
func update_text(text : String):
	label.text = text
		

