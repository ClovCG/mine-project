class_name PauseButton extends Button

@onready var pause_menu: PauseMenu = $"../../PauseMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called on UI button pressed (Mouse)
func _on_pause_button_pressed() -> void:
	pause_menu.show_pause_menu()

func _on_pause_button_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		pause_menu.show_pause_menu()
