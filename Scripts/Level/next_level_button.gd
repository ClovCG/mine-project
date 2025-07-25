class_name NextLevelButton extends Button


# SIGNAL METHODS #
func _on_next_level_pressed() -> void:
	Game.restart()

func _on_next_level_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		Game.restart()
