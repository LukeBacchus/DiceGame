extends "../BaseLevel.gd"

func _enter_tree():
	WorldVariables.abilities = [WorldVariables.Abilities.BLANK, #face
				WorldVariables.Abilities.BLANK, #down
				WorldVariables.Abilities.DASH, #right
				WorldVariables.Abilities.DASH, #left
				WorldVariables.Abilities.BLANK, #up
				WorldVariables.Abilities.BLANK] #behind
