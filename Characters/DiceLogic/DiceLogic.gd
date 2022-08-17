extends Control

onready var Die_Face_Icon = $"HBoxContainer/VBoxContainer2/Die/Icon".texture
onready var Left_Side_Icon = $"HBoxContainer/VBoxContainer/Left/Icon".texture
onready var Up_Side_Icon = $"HBoxContainer/VBoxContainer2/Up/Icon".texture
onready var Down_Side_Icon = $"HBoxContainer/VBoxContainer2/Down/Icon".texture
onready var Right_Side_Icon = $"HBoxContainer/VBoxContainer3/Right/Icon".texture

export (Texture) var Mine_texture
export (Texture) var Shotgun_texture
export (Texture) var Dash_texture
export (Texture) var Fear_texture
export (Texture) var Snare_texture
export (Texture) var Blank_texture

var icons

var die_Face = 0

var left_Side = 0
var up_Side = 0
var down_Side = 0
var right_Side = 0

var one = [5,3,2,4]
var two = [6,3,1,4]
var three = [5,1,2,6]

var ability_number: int = 0
var abilities = null

#===================================================

func _enter_tree():
	abilities = WorldVariables.abilities
	
	icons = [Mine_texture, Shotgun_texture, Dash_texture, Fear_texture, Snare_texture, Blank_texture]
	
	set_die_face(1)
	set_left_side(4)
	set_up_side(5)
	set_down_side(2)
	set_right_side(3)

#===================================================

func set_die_face(value):
	die_Face = value
	$"HBoxContainer/VBoxContainer2/Die/Icon".texture = icons[get_ability_icon(abilities[value-1])]

func set_left_side(value):
	left_Side = value
	$"HBoxContainer/VBoxContainer/Left/Icon".texture = icons[get_ability_icon(abilities[value-1])]

func set_up_side(value):
	up_Side = value
	$"HBoxContainer/VBoxContainer2/Up/Icon".texture = icons[get_ability_icon(abilities[value-1])]

func set_down_side(value):
	down_Side = value
	$"HBoxContainer/VBoxContainer2/Down/Icon".texture = icons[get_ability_icon(abilities[value-1])]

func set_right_side(value):
	right_Side = value
	$"HBoxContainer/VBoxContainer3/Right/Icon".texture = icons[get_ability_icon(abilities[value-1])]

#===================================================

func get_ability_icon(ability):
	
	var texture
	
	match ability:
		"Mine":
			texture = 0
		"Shotgun":
			texture = 1
		"Dash":
			texture = 2
		"Fear":
			texture = 3
		"Snare":
			texture = 4
		"Nothing":
			texture = 5

	return texture

#===================================================

func right() -> void:
	ability_number = die_Face
	set_left_side(die_Face)
	set_die_face(right_Side)
	set_right_side((7 - left_Side))

func left() -> void:
	ability_number = die_Face
	set_right_side(die_Face)
	set_die_face(left_Side)
	set_left_side((7 - right_Side))

func down() -> void:
	ability_number = die_Face
	set_up_side(die_Face)
	set_die_face(down_Side)
	set_down_side((7 - up_Side))

func up() -> void:
	ability_number = die_Face
	set_down_side(die_Face)
	set_die_face(up_Side)
	set_up_side((7 - down_Side))

#===================================================

func get_ability_number() -> int:
	return ability_number

#===================================================

#	if die_Face == 1 or die_Face == 6:
#		set_left_side(one[3])
#		set_up_side(one[0])
#		set_down_side(one[2])
#		set_right_side(one[1])
#
#	if die_Face == 2 or die_Face == 5:
#		set_left_side(two[3])
#		set_up_side(two[0])
#		set_down_side(two[2])
#		set_right_side(two[1])
#
#	if die_Face == 3 or die_Face == 4:
#		set_left_side(three[3])
#		set_up_side(three[0])
#		set_down_side(three[2])
#		set_right_side(three[1])

func print_die():
	print("  " + str(up_Side))
	print(str(left_Side) + " "  + str(die_Face) + " " + str(right_Side))
	print("  " + str(down_Side))
	print("\n=====\n")
