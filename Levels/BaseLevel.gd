extends Node2D


func _enter_tree() -> void:
	$Camera2D.current = true


func finish_level() -> void:
	var next_level = WorldVariables.get_next_level()
	remove_units_from_turn_order()
	TurnOrder.turn_counter = 0
	WorldVariables.load_level(next_level)
	self.queue_free()


func remove_units_from_turn_order() -> void:
	TurnOrder.remove_self(get_node("Player"))
	for enemy in $Enemies.get_children():
		TurnOrder.remove_self(enemy)
