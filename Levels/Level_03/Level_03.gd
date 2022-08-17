extends "../BaseLevel.gd"

func _enter_tree():
	WorldVariables.abilities = [WorldVariables.Abilities.SHOTGUN, #face
				WorldVariables.Abilities.DASH, #down
				WorldVariables.Abilities.DASH, #right
				WorldVariables.Abilities.SHOTGUN, #left
				WorldVariables.Abilities.BLANK, #up
				WorldVariables.Abilities.BLANK] #behind
