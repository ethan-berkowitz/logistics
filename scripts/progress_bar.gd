extends ProgressBar

@onready var value_label: Label = $ValueLabel
@onready var per_second_label = $PerSecondLabel

func update_value_label(string: String):
	value_label.text = string
func update_per_second_label(string: String):
	per_second_label.text = string
