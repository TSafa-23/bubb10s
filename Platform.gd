extends Area2D


var is_bad = false;
var platform_point = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open_door():
	$AnimatedSprite.play("OPEN");
	$Door.play();
	$Whistle.play();

func _physics_process(delta):
	var areas = get_overlapping_areas();
	if areas.size() > 0:
		if is_bad && areas[0].IS_JUMPING == false:
			open_door();
			areas[0].respawn();

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("CLOSED");
