extends Node2D

enum GAME_STATE {
	LOADING,
	IN_PROGRESS,
	PAUSED,
	CLEARED,
	LOST
}

@export_range(0, 99) var flags: int = 10

var level: int = 1
var game_state: GAME_STATE = GAME_STATE.LOADING
var flags_used: int = 0
var prev_focused_tile: MineTile

# Restarts the game/scene
func restart() -> void:
	level = level + 1 if Game.game_state == Game.GAME_STATE.CLEARED else 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func update_game_state(new_game_state: GAME_STATE) -> void:
	self.game_state = new_game_state
