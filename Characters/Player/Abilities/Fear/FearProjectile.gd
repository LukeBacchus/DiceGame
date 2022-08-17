extends StaticBody2D


func _on_Detector_body_entered(body):
	if "conditions" in body:
		body.conditions["Fear"] = {"Duration" : 1.0}
