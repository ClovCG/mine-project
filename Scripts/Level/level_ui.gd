class_name LevelUI extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "Level " + str(Game.level + 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
