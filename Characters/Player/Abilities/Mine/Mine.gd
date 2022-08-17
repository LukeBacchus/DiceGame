extends StaticBody2D

const cardinal_directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]

export (PackedScene) var Explosion

var current_time = 0
var detonate_timer = 3
var lifetime_timer = null


func increment_timer() -> void:
	current_time += 1
	if current_time == detonate_timer:
		detonate()


func detonate() -> void:
	for direction in cardinal_directions:
		var explosion = Explosion.instance()
		explosion.global_position = self.global_position + direction * WorldVariables.tile_size
		explosion.set_as_toplevel(true)
		self.add_child(explosion)
	$Mine.play()
	$LifetimeTimer.start()


func _on_LifetimeTimer_timeout():
	self.queue_free()
