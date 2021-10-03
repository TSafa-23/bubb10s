extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start;
signal pause;

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer.visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$VBoxContainer.visible = !$VBoxContainer.visible;
		emit_signal("pause");



func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	$VBoxContainer.visible = !$VBoxContainer.visible;
	$VBoxContainer/Start.text = "Continue";
	emit_signal("start");
