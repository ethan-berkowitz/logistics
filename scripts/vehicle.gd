extends RefCounted
class_name Vehicle

var type: String
var price: int
var value: int
var duration: float
var amount: int
var staff: int
var orders: int
var status: float
var disabled: bool
var label: Label
var status_bar: ProgressBar
var purchase_button: Button
var staff_control: Control


func _init(t: String, p: int, v: int, d: float,
			a: int, s: int, o: int, st: float,
			db: bool, l: Label, sb: ProgressBar,
			pb: Button, sc: Control):
	type = t
	price = p
	value = v
	duration = d
	amount = a
	staff = s
	orders = o
	status = st
	disabled = db
	label = l
	status_bar = sb
	purchase_button = pb
	staff_control = sc
	
	if (disabled):
		update_disabled(true)

func purchase(buy_mult: int):
	var fp := float(price)
	var new = fp * 1.135
	price = int(new)
	amount += buy_mult
	update_purchase_text(buy_mult)

func update_purchase_text(buy_mult: int):
	label.text = str(type) + " x " + str(amount)
	purchase_button.text = "Buy " + str(buy_mult) + "\n$" + str(price)
	
func update_staff_text():
	staff_control.staff_amount_label.text = str(staff)
	
func update_value_label():
	status_bar.update_value_label("$" + str(value))
	
func update_per_second_label():
	var perSec = 0
	if amount > 0:
		perSec = value / (duration / amount)
	status_bar.update_per_second_label("$" + str(perSec) + "/sec")
	
func update_disabled(state: bool):
	if state == true:
		disabled = true
		purchase_button.visible = false
		label.visible = false
		status_bar.visible = false
	else:
		disabled = false
		purchase_button.visible = true
		label.visible = true
		status_bar.visible = true
	
