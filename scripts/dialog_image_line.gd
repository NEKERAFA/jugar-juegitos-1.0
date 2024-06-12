extends DialogLine
class_name DialogImageLine

@export var preserve_image: bool = false
@export var image: Texture2D = null

func _init(message_id: String = "", preserve_image: bool = false, image: Texture2D = null) -> void:
	super(message_id)
	self.preserve_image = preserve_image
	self.image = image
	self.resource_name = "DialogImageLine"
