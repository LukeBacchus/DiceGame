extends Area2D

signal finished_level


func _on_FinishLevelBlock_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("finished_level")
