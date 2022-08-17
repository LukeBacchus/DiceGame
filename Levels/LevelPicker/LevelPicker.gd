extends Control

export (PackedScene) var LevelButton

var level_container: GridContainer = null


func _enter_tree() -> void:
	level_container = $MarginContainer/VBoxContainer/MarginContainer/LevelContainer
	
	for level_name in WorldVariables.levels:
		var level_button = LevelButton.instance()
		level_button.set_text(level_name)
		level_button.connect("button_up", self, "_load_level", [level_name])
		level_container.add_child(level_button)


func _load_level(var level_name: String) -> void:
	WorldVariables.load_level(level_name)
	self.set_visible(false)
