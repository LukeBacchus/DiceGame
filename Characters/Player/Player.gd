extends KinematicBody2D

signal finished_moving

export (float) var speed = 3
export (float) var max_health = 3
export (int) var dash_num = 2
export (int) var shotgun_pushback_amount = 1
export (int) var num_of_pellets = 3
export (int) var num_of_fear_projectiles = 5

export (PackedScene) var Mine
export (PackedScene) var Shotgun
export (PackedScene) var Snare
export (PackedScene) var Fear

export (int) var max_actions_left = 1

var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

var dice_logic = null
var health = null
var abilities = null
var animation_player = null
var sprite = null

var actions_left = max_actions_left

var conditions = {}

onready var collider = $SameSquareCollider
onready var ray = $RayCast2D
onready var tween = $Tween

func _enter_tree() -> void:
	WorldVariables.player = self
	health = $Health
	dice_logic = $DiceLogic
	abilities = WorldVariables.abilities
	animation_player = $AnimationPlayer
	sprite = $Sprite


func _unhandled_input(event) -> void:
	if tween.is_active(): return
	for direction in inputs.keys():
		if event.is_action_pressed(direction) and actions_left > 0:
			actions_left -= 1
			move(inputs[direction])


func do_turn():
	actions_left = max_actions_left
	for node in self.get_children():
		if node.is_in_group("timed"):
			node.increment_timer()


func move(direction) -> void:
	roll_dice(direction)
	ray.cast_to = direction * WorldVariables.tile_size
	ray.force_raycast_update()
	use_ability(dice_logic.get_ability_number(), direction)


func roll_dice(direction) -> void:
	match direction:
		Vector2.LEFT:
			dice_logic.left()
		Vector2.RIGHT:
			dice_logic.right()
		Vector2.UP:
			dice_logic.up()
		Vector2.DOWN:
			dice_logic.down()
#	dice_logic.print_die()


func move_tween(direction) -> void:
	match direction:
		Vector2.RIGHT:
			sprite.set_rotation_degrees(0)
		Vector2.DOWN:
			sprite.set_rotation_degrees(90)
		Vector2.LEFT:
			sprite.set_rotation_degrees(180)
		Vector2.UP:
			sprite.set_rotation_degrees(270)
	animation_player.play("Roll")
	
	ray.cast_to = direction * WorldVariables.tile_size
	ray.force_raycast_update()
	
	if ray.is_colliding():
		yield(get_tree().create_timer(1.0/speed), "timeout")
		emit_signal("finished_moving")
		end_turn()
		return
	
	tween.interpolate_property(self, "position",
		position, position + direction * WorldVariables.tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	end_turn()
	emit_signal("finished_moving")


func use_ability(var ability_number: int, direction: Vector2) -> void:
	match abilities[ability_number - 1]:
		WorldVariables.Abilities.MINE:
			place_mine()
			move_tween(direction)
		WorldVariables.Abilities.SHOTGUN:
			move_tween(direction)
			shotgun(direction)
			$Gun.play()
			yield(self, "finished_moving")
			$Shotgun.queue_free()
		WorldVariables.Abilities.DASH:
			dash(direction)
			$Dash.play()
		WorldVariables.Abilities.FEAR:
			move_tween(direction)
			fear(direction)
			$Fear.play()
		WorldVariables.Abilities.SNARE:
			for i in 2:
				for j in 2:
					var x_pos = (i * 2 - 1) * WorldVariables.tile_size
					var y_pos = (j * 2 - 1) * WorldVariables.tile_size
					var location = self.global_position - Vector2(x_pos, y_pos)
					snare(location)
			for location in inputs.values():
				var set_location = self.global_position + location * WorldVariables.tile_size
				snare(set_location)
			move_tween(direction)
			$Freeze.play()
		WorldVariables.Abilities.BLANK:
			move_tween(direction)


func place_mine() -> void:
	var mine = Mine.instance()
	mine.global_position = self.global_position
	mine.set_as_toplevel(true)
	self.add_child(mine)


func shotgun(direction: Vector2) -> void:
	var shotgun = Shotgun.instance()
	shotgun.global_position = self.global_position + direction * WorldVariables.tile_size
	shotgun.set_as_toplevel(true)
	self.add_child(shotgun)
	shotgun.shoot(direction, num_of_pellets)


func dash(direction: Vector2):
	match direction:
		Vector2.RIGHT:
			sprite.set_rotation_degrees(0)
		Vector2.DOWN:
			sprite.set_rotation_degrees(90)
		Vector2.LEFT:
			sprite.set_rotation_degrees(180)
		Vector2.UP:
			sprite.set_rotation_degrees(270)
	animation_player.play("Roll")

	for _count in range(dash_num):
		ray.force_raycast_update()
		if !ray.is_colliding():
			tween.interpolate_property(self, "position",
			position, position + direction * WorldVariables.tile_size,
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()
			yield(tween, "tween_all_completed")
	end_turn()
	
	ray.force_raycast_update()

func end_turn():
	for body in collider.get_overlapping_bodies():
		if body.is_in_group("dashable"):
			die()
			print("Fell in hole")
			
	TurnOrder.end_turn(self)
			

func fear(direction: Vector2) -> void:
	var fear = Fear.instance()
	fear.global_position = self.global_position
	fear.set_as_toplevel(true)
	self.add_child(fear)
	fear.blast(direction, num_of_fear_projectiles)


func snare(location: Vector2) -> void:
	var snare = Snare.instance()
	snare.global_position = location
	snare.set_as_toplevel(true)
	self.add_child(snare)


#func pushback_tween(direction: Vector2, distance) -> void:
#	ray.cast_to = direction * WorldVariables.tile_size
#	for _count in range(distance):
#		ray.force_raycast_update()
#		if !ray.is_colliding():
#			tween.interpolate_property(self, "position",
#			position, position + direction * WorldVariables.tile_size,
#			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			tween.start()
#		yield(tween, "tween_all_completed")
#	$Shotgun.queue_free()


func die():
	self.queue_free()


func take_damage(damage_taken: float) -> void:
	health.set_current_hp(health.current_hp - damage_taken)


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Roll":
		dice_logic.set_visible(false)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Roll":
		dice_logic.set_visible(true)
