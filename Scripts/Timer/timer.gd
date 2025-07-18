# Based on the In-Game Time tutorial by MakerTech on YouTube: https://www.youtube.com/watch?v=PbWtdMQO5jc
class_name IngameTimer extends Node

var secs: int = 0
var mins: int = 0
var str_secs: String = "0"
var str_mins: String = "0"
var delta_time: float = 0.0
var stopped: bool = false

@onready var timer_ui: TimerUI = $"../TimerUI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not stopped:
		increase_delta(delta)

func increase_delta(delta: float) -> void:
	delta_time += delta
	
	if delta_time >= 1:
		var delta_int: int = int(delta_time)
		delta_time -= delta_int
		
		secs += delta_int
		mins += secs / 60
		secs = secs % 60
		
		str_secs = str(secs) if secs >= 10 else "0" + str(secs)
		str_mins = str(mins) if mins >= 10 else "0" + str(mins) 
		timer_ui.update(str_mins, str_secs)

func reset() -> void:
	secs = 0
	mins = 0
	str_secs = "0"
	str_mins = "0"
	delta_time = 0.0

func stop() -> void:
	stopped = true
