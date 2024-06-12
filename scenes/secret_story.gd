extends Node


@export var story: Dialog


@onready var _dialog = $DialogController
@onready var _next_btn = $NextLineButton


var _current_line = 0


func next_line() -> void:
	if _current_line < story.lines.size():
		_next_btn.hide()
		var line = story.lines[_current_line]
		if line.resource_name == 'DialogImageLine':
			_dialog.new_dialog(line.message_id, line.preserve_image, line.image)
		else:
			_dialog.new_dialog(line.message_id)
		_current_line += 1


func _ready() -> void:
	if story != null:
		next_line()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if _dialog.is_animating():
			_dialog.complete_animation()
		elif _current_line == story.lines.size():
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		else:
			next_line()


func _on_dialog_animation_completed() -> void:
	_next_btn.show()


func _on_next_pressed() -> void:
	next_line()
