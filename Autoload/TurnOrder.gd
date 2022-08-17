extends Node

enum TURN{PLAYER, ENEMY}

var turn_timer = 0.1
var turn_counter = 2

var current_turn

var enemy_group = []
var enemy_counter = 0
var max_enemy_counter = 0

#===================================================

func add_self(character):
	enemy_group.append(character)
	max_enemy_counter += 1

func remove_self(character):
	enemy_group.erase(character)
	max_enemy_counter -= 1

#===================================================

func start_turn(character):
	if character == TURN.ENEMY:
		for enemy in enemy_group:
			enemy.do_turn()
	else:
		enemy_counter = max_enemy_counter
		if is_instance_valid(WorldVariables.player):
			WorldVariables.player.do_turn()
		else:
			WorldVariables.death_screen.set_is_paused(true)

func end_turn(character):
	if enemy_counter > 0:
		enemy_counter -= 1

	yield(get_tree().create_timer(turn_timer), "timeout")

	if enemy_group.has(character) or enemy_group.size() == 0:
		if  enemy_counter == 0:
			current_turn = TURN.PLAYER
			start_turn(TURN.PLAYER)
	else:
		enemy_counter = enemy_group.size()
		current_turn = TURN.ENEMY
		start_turn(TURN.ENEMY)


#===================================================
