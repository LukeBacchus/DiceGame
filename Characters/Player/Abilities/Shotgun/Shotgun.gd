extends Node2D

export (PackedScene) var Pellet
export (float) var projectile_spread_timer = 0.05


func shoot(direction: Vector2, num_of_projectiles: int) -> void:
	shoot_sides(direction)
	shoot_straight(direction, num_of_projectiles)


func shoot_sides(direction: Vector2) -> void:
	var left_side = Vector2(-direction.y, direction.x)
	var right_side = Vector2(direction.y, -direction.x)
	
	var left_side_position = self.global_position + left_side * WorldVariables.tile_size
	var right_side_position = self.global_position + right_side * WorldVariables.tile_size
	
	fire_pellet(left_side_position)
	fire_pellet(right_side_position)


func shoot_straight(direction: Vector2, num_of_projectiles) -> void:
	for distance in range(num_of_projectiles + 1):
		var pellet_position =  self.global_position + direction * WorldVariables.tile_size * distance
		fire_pellet(pellet_position)


func fire_pellet(pellet_position: Vector2) -> void:
	var pellet = Pellet.instance()
	pellet.global_position = pellet_position
	pellet.set_as_toplevel(true)
	self.add_child(pellet)
