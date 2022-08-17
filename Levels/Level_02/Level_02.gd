extends "../BaseLevel.gd"

func _enter_tree():
	WorldVariables.abilities = [WorldVariables.Abilities.BLANK, #face
				WorldVariables.Abilities.SNARE, #down
				WorldVariables.Abilities.BLANK, #right
				WorldVariables.Abilities.BLANK, #left
				WorldVariables.Abilities.BLANK, #up
				WorldVariables.Abilities.FEAR] #behind
