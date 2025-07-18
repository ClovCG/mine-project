extends Node2D

enum GAME_STATE {
	LOADING,
	IN_PROGRESS,
	CLEARED,
	LOST
}

@export_range(0, 99) var flags: int = 10

var level: int = 0
var game_state: GAME_STATE = GAME_STATE.LOADING
var flags_used: int = 0

# TODO: Add a pause menu -> Continue - Restart - Quit

# Restarts the game/scene
func restart() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
