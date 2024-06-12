extends Node


@onready var _selector = $Selector
@onready var _question_lbl = $Selector/Question
@onready var _anim_player = $SelectorAnimatorPlayer
@onready var _dialog = $DialogController
@onready var _next_btn = $NextLineButton


var _change_screen: bool = false
var _option: int


func _ready() -> void:
	_anim_player.play("init_animation")
	_option = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right") and _option == 0:
		_anim_player.play_backwards("change_selection")
		_option = 1
	elif event.is_action_pressed("ui_left") and _option == 1:
		_anim_player.play("change_selection")
		_option = 0
	elif event.is_action_pressed("ui_accept"):
		if not _dialog.visible:
			match _option:
				0 when not _change_screen:
					_question_lbl.text = "Are you sure?"
					_change_screen = true
				0 when _change_screen:
					_selector.hide()
					_dialog.show()
					_dialog.new_dialog("Ok, Where was I going?", false, null)
				1:
					get_tree().change_scene_to_file("res://scenes/secret_story.tscn")
		else:
			if _dialog.is_animating():
				_dialog.complete_animation()
			else:
				get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_dialog_animation_completed() -> void:
	_next_btn.show()


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
