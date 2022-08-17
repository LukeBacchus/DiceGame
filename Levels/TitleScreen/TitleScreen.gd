extends Control

export (PackedScene) var LevelPicker


func _on_Play_button_up():
	var level_picker = LevelPicker.instance()
	get_parent().add_child(level_picker)
	self.call_deferred("queue_free")


func _on_Quit_button_up():
	get_tree().quit()



func _on_Credits_button_up():
	self.set_visible(false)
	get_parent().get_node("Credits").set_visible(true)
