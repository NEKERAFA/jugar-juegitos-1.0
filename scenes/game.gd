extends Node


@export var story: Dialog
@export var stop_texture: Texture2D


@onready var _dialog = $DialogController
@onready var _next_btn = $NextLineButton
@onready var _exit_lbl = $ExitLabel
@onready var _current_screen = get_window().current_screen


func next_line() -> void:
	if GameState.current_line < story.lines.size():
		_next_btn.hide()
		var line = story.lines[GameState.current_line]
		if line.resource_name == 'DialogImageLine':
			_dialog.new_dialog(line.message_id, line.preserve_image, line.image)
		else:
			_dialog.new_dialog(line.message_id)
		GameState.current_line += 1


func _ready() -> void:
	if story != null:
		next_line()


func _process(_delta: float) -> void:
	var window_pos = get_window().position
	var window_size = get_window().size
	var window_rect = Rect2i(window_pos, window_size)
	var screen = get_window().current_screen
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)

	var rect_id = 0
	for s in range(DisplayServer.get_screen_count()):
		if s != _current_screen:
			var rect = DisplayServer.screen_get_usable_rect(s)
			if window_rect.intersects(rect) and rect_id < 3:
				var intersection = rect.intersection(window_rect)
				var color_rect: ColorRect = get_node("ChangeScreen" + str(rect_id))
				color_rect.show()
				color_rect.position = intersection.position - window_pos
				color_rect.size = intersection.size
				rect_id += 1

	for id in range(rect_id, 3):
		var color_rect: ColorRect = get_node("ChangeScreen" + str(id))
		if color_rect.visible:
			color_rect.hide()

	if _current_screen != screen:
		if screen_rect.encloses(window_rect):
			get_tree().change_scene_to_file("res://scenes/change_story.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if _dialog.is_animating():
			_dialog.complete_animation()
		elif not OS.has_feature("web") and GameState.current_line == story.lines.size():
			get_tree().quit(0)
		else:
			next_line()


func _on_dialog_animation_completed() -> void:
	if GameState.current_line < story.lines.size():
		_next_btn.show()
	elif OS.has_feature("web"):
		_next_btn.show()
		_next_btn.texture_normal = stop_texture
	else:
		_exit_lbl.show()


func _on_next_pressed() -> void:
	next_line()


func _on_exit_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pressed"):
		get_tree().quit(0)
