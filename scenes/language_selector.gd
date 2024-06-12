extends Node


@onready var _anim_player = $AnimationPlayer


func _ready() -> void:
	TranslationServer.set_locale("es")
	_anim_player.play("init_animation")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right") and TranslationServer.get_locale() == "es":
		_anim_player.play_backwards("change_option")
		TranslationServer.set_locale("gl")
	elif event.is_action_pressed("ui_left") and TranslationServer.get_locale() == "gl":
		_anim_player.play("change_option")
		TranslationServer.set_locale("es")
	elif event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
