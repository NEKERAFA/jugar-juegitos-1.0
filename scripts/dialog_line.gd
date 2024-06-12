extends Resource
class_name DialogLine

@export var message_id: String = ""


func _init(message_id: String = "") -> void:
	self.message_id = message_id
	self.resource_name = "DialogLine"
