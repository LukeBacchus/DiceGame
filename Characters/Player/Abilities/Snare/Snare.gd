extends StaticBody2D


func _on_LifetimeTimer_timeout():
	self.queue_free()


func _on_Detector_body_entered(body):
	if "conditions" in body:
		body.conditions["Snare"] = {"Duration" : 2.0}

