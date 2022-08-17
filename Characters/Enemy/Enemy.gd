extends KinematicBody2D

enum EnemyLogic{RANDOM, AI, PRESET}

var speed = 8
export (int) var max_enemy_actions = 1
var remaining_enemy_actions = max_enemy_actions

export (EnemyLogic) var ai_type = EnemyLogic.RANDOM
export (Array) var preset_moves = [0,1,2,3]
var current_move = 0

var random = RandomNumberGenerator.new()

var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

var directions = [
				Vector2.UP, #0
				Vector2.LEFT, #1
				Vector2.DOWN, #2
				Vector2.RIGHT #3
				]

var health = null
var freeze = null
var fear = null

var conditions = {}

var counter = 0

var path

onready var ray = $RayCast2D
onready var tween = $Tween


func _enter_tree() -> void:
	TurnOrder.add_self(self)
	random.randomize()
	health = $Health
	freeze = $Freeze
	fear = $FearParticles


func do_turn():
	remaining_enemy_actions -= 1
	if conditions.size() >= 1:
		for condition in conditions:
			match condition:
				"Snare": 
					print(self.name + " : Got Snared for " + str(conditions[condition]["Duration"]) + " Turn(s)!")
					snare_condition(conditions[condition]["Duration"])
				"Fear":
					if not conditions.has("Snare"):
						print(self.name + " : Got Feared for " + str(conditions[condition]["Duration"]) + " Turn(s)!")
						fear_condition(conditions[condition]["Duration"])
	else:
		if not is_instance_valid(WorldVariables.player):
			end_turn()
		else:
			match(ai_type):
				EnemyLogic.AI:
					calculate_path()
					if path.size() <= 1:
						var direction = (WorldVariables.player.position - self.position).normalized()
#						print("Player Pos: " + str(WorldVariables.player.position))
#						print("Enemy Pos: " + str(self.position))
#						print("Normalized Vector: " + str(direction))
						
						if abs(direction.x) > abs(direction.y):
							if direction.x < 0:
								direction.x = -1
							if direction.x >= 0:
								direction.x = 1
							direction.y = 0
						if abs(direction.y) > abs(direction.x):
							if direction.y < 0:
								direction.y = -1
							if direction.y >= 0:
								direction.y = 1
							direction.x = 0
						
						move(direction)
					else:
						move((path[1] - path[0]).normalized())
				EnemyLogic.RANDOM:
					move(directions[random.randf_range(0, 3)])
				EnemyLogic.PRESET:
					move(directions[preset_moves[current_move]])
					current_move = current_move + 1
					
					if current_move >= preset_moves.size():
						current_move = 0

func calculate_path():
	path = WorldVariables.env.find_path(self.position, WorldVariables.player.position)

func move(direction):
	ray.cast_to = direction * WorldVariables.tile_size
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		move_tween(direction)
	else:
		var colliding_node = ray.get_collider()
		if colliding_node.is_in_group("Player"):
			if WorldVariables.player.health.current_hp - 1 == 0:
				move_tween((WorldVariables.player.position - self.position).normalized())
			colliding_node.take_damage(1)
		end_turn()


func move_tween(direction):
	tween.interpolate_property(self, "position",
		position, position + direction * WorldVariables.tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	counter += 1
	yield(tween, "tween_all_completed")
	end_turn()


func take_damage(damage_taken) -> void:
	health.set_current_hp(health.current_hp - damage_taken)

#===================================================

func snare_condition(duration):
	if duration <= 0:
		freeze.set_visible(false)
		conditions.erase("Snare")
	
	if duration > 0:
		freeze.set_visible(true)
		duration -= (1.0 / float(max_enemy_actions))
		conditions["Snare"]["Duration"] = duration
	
	if conditions.has("Snare"):
		end_turn()
	else:
		do_turn()


func fear_condition(duration):
	if duration <= 0:
		fear.set_visible(false)
		conditions.erase("Fear")
	
	if duration > 0:
		fear.set_visible(true)
		duration -= (1.0 / float(max_enemy_actions))
		conditions["Fear"]["Duration"] = duration
	
	if conditions.has("Fear"):
		calculate_path()
		if path.size() <= 1:
			move((self.position - WorldVariables.player.position).normalized())
		else:
			move((path[0] - path[1]).normalized())
	else:
		do_turn()

#===================================================


func end_turn():
	if remaining_enemy_actions > 0:
		do_turn()
	else:
		TurnOrder.end_turn(self)
		remaining_enemy_actions = max_enemy_actions
		
func die():
	TurnOrder.remove_self(self)
	self.queue_free()
