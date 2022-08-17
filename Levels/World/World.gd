extends Node2D

export (int) var tile_size = 32

const Abilities = {
	MINE = "Mine",
	SHOTGUN = "Shotgun",
	DASH = "Dash",
	FEAR = "Fear",
	SNARE = "Snare",
	BLANK = "Nothing",
}

var player
var abilities
var env
var death_screen
var levels = ["Level_01", "Level_02",  "Level_03", "Level_04"]
var current_level


func get_next_level() -> String:
	var level_index = levels.find(current_level)
	return levels[(level_index + 1) % len(levels)]


func load_level(var level_name: String) -> void:
	var level = load("res://Levels/%s/%s.tscn" % [level_name, level_name]).instance()
	self.call_deferred("add_child", level)
	current_level = level_name
