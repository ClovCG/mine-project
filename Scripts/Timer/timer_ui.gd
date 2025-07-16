class_name TimerUI extends Control

@onready var minutes: Label = $Minutes
@onready var seconds: Label = $Seconds

func update(str_mins: String, str_secs: String) -> void:
	minutes.text = str_mins
	seconds.text = str_secs
