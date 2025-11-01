extends ProgressBar

#attach current health to value and max health to max value

@onready var unit : Unit = get_parent()

func _ready() -> void:
	max_value = unit.max_hp
	value = max_value
	visible = false
	unit.OnTakeDamage.connect(_update_value)
	unit.HealthRegeneration.connect(_update_value)
	
func _update_value (health : int):
	value = health
	visible = value < max_value
