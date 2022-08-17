extends Area2D


func _on_Explosion_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(1)
