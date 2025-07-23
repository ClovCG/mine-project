extends Node

## Fetch a range of adjacent tile positions inside the given boundaries inside the grid.
func get_inbounds_adjacent_ranges(x: int, y: int, rows: int, columns: int) -> Dictionary:
	var x_min: int = x - 1 if x - 1 >= 0 else 0
	var x_max: int = x + 1 if x + 1 <= columns-1 else columns-1
	var y_min: int = y - 1 if y - 1 >= 0 else 0
	var y_max: int = y + 1 if y + 1 <= rows-1 else rows-1
	
	return {
		"x_min": x_min,
		"x_max": x_max,
		"y_min": y_min,
		"y_max": y_max
	}

## Prints the grid values on console (for debugging purposes).
func print_tiles(tiles: Array[Array], rows: int) -> void:
	for row in range(rows):
		print(tiles[row])

## Gets a list of custom actions from the Input Map.
func get_custom_actions() -> Array[StringName]:
	return InputMap.get_actions().filter(func(action): return !action.contains("ui_"))
