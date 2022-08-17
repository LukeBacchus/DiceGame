extends "../BaseLevel.gd"

func _enter_tree():
	WorldVariables.abilities = [WorldVariables.Abilities.MINE, #face
				WorldVariables.Abilities.SHOTGUN, #down
				WorldVariables.Abilities.DASH, #right
				WorldVariables.Abilities.FEAR, #left
				WorldVariables.Abilities.SNARE, #up
				WorldVariables.Abilities.BLANK] #behind
