extends "../BaseLevel.gd"

func _enter_tree():
	WorldVariables.abilities = [WorldVariables.Abilities.DASH,
								WorldVariables.Abilities.DASH,
								WorldVariables.Abilities.BLANK,
								WorldVariables.Abilities.FEAR,
								WorldVariables.Abilities.FEAR,
								WorldVariables.Abilities.BLANK]
