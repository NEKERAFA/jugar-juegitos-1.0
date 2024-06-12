extends Control


signal char_added
signal animation_completed


const CHARS_PER_SECOND = 20


enum State { NONE, TEXT, IMAGE }


var _image: Texture2D = null
var _preserve_image: bool = false
var _delta_char: float = 0
var _seconds_per_char = 1.0 / float(CHARS_PER_SECOND)
var _is_animating: bool = false
var _regex_ends_with = RegEx.new()
var _last_state: State = State.NONE


@onready var _label = $DialogLabel
@onready var _texture = $DialogTexture
@onready var _anim_player = $DialogAnimationPlayer
@onready var _audio_player = $KeyboardAudioPlayer


func new_dialog(text: String, preserve_image: bool = false, image: Texture2D = null) -> void:
	_label.text = tr(text)
	if _regex_ends_with.search(_label.text) == null:
		_label.text += "."

	_label.visible_ratio = 0
	_preserve_image = preserve_image
	_image = image
	hide_dialog()

func hide_dialog() -> void:
	if _last_state == State.NONE:
		show_dialog()
	else:
		match _last_state:
			State.TEXT:
				_anim_player.play("hide_text")
			State.IMAGE when _preserve_image:
				_anim_player.play("hide_text")
			State.IMAGE:
				_anim_player.play("hide_image")


func show_dialog() -> void:
	if _preserve_image:
		_anim_player.play("show_text_image")
	else:
		_texture.texture = _image
		if _image == null:
			_last_state = State.TEXT
			_anim_player.play("show_text")
		else:
			_last_state = State.IMAGE
			_anim_player.play("show_image")

	_is_animating = true


func complete_animation() -> void:
	if _is_animating:
		_label.visible_ratio = 1
		_is_animating = false
		char_added.emit()
		animation_completed.emit()


func is_animating() -> bool:
	return _is_animating


func _ready() -> void:
	_regex_ends_with.compile("[\\.!?]$")
	_anim_player.play("show_text")


func _process(delta: float) -> void:
	if _is_animating:
		_delta_char += delta

		if _delta_char >= _seconds_per_char:
			_delta_char -= _seconds_per_char
			_label.visible_characters += 1
			char_added.emit()

			if _label.text.length() == _label.visible_characters:
				animation_completed.emit()
				_is_animating = false


func _on_animation_player_finished(anim_name: StringName) -> void:
	match anim_name:
		"hide_text", "hide_image", "hide_text_image":
			show_dialog()


func _on_char_added() -> void:
	_audio_player.play(0)
