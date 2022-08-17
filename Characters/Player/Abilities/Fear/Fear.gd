extends Node2D

export (PackedScene) var FearProjectile
export (float) var projectile_spread_timer = 0.05


func blast(direction: Vector2, num_of_fear_projectiles: int) -> void:
	for distance in range(1, num_of_fear_projectiles + 1): 
		var fear_projectile = FearProjectile.instance()
		fear_projectile.global_position = self.global_position + direction * WorldVariables.tile_size * distance
		fear_projectile.set_as_toplevel(true)
		self.add_child(fear_projectile)
		yield(get_tree().create_timer(projectile_spread_timer), "timeout")


func _on_Timer_timeout():
	self.queue_free()

#fear they run for 1 turn
#snare they stun for 1 turn
