extends Control

@onready var closeButton: Button = $CloseButton

func _ready() -> void:
	closeButton.pressed.connect(self._on_close_button_pressed)

func _on_close_button_pressed() -> void:
	queue_free()
