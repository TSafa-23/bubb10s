extends Area2D

### Variables

var scene = preload("res://Platform.tscn")

signal score_change;

var GAME_START = false;
var IS_JUMPING = true;
var on_platform = false;
var score = 0;
var default_platforms = 5;
var key_pressed = false;

const default_velocity = [0.5, 0.5, 0.25, 0.15, 1.5, 1.5, 1];
var player_velocity;
var anim_frame = 0;
var offset = 0;

var spawn = Vector2(0, -110);

var trapdoor_center = Vector2(16, 50);
var trapdoor_offset = Vector2(32, 60);

### Functions

func respawn():
	$CollisionShape2D/AnimatedSprite.play("DIE");

func place_map(levels, offset):
	randomize();
	for i in levels:
		var rand = randi()%2;
		for j in 2:
			var node = scene.instance();
			
			if j == 1:
				node.is_bad = !(rand);
				node.scale.x = -1
			else:
				node.is_bad = (rand);
			
			node.position = Vector2(trapdoor_center.x - (j*trapdoor_offset.x), trapdoor_center.y + ((offset+i)*trapdoor_offset.y));
			
			add_child(node);

### Godot Functions

func _ready():
	$CollisionShape2D/ScoreLabel.text = "SCORE = " + str(score);
	$StartMenu.connect("start", self, "_on_game_start");
	$StartMenu.connect("pause", self, "_on_game_pause");
	connect("score_change", self, "_on_score_change");
	$CollisionShape2D.position = spawn;
	$CollisionShape2D/AnimatedSprite/Camera2D.make_current();
	$CollisionShape2D/AnimatedSprite.play("MOVE");
	place_map(default_platforms, 0);

func _process(delta):
	
	### Input Handler
	
	if GAME_START == true:
		
		player_velocity = default_velocity[anim_frame];
		
		if anim_frame >= 3 && anim_frame <= 6:
			IS_JUMPING = true;
		else:
			IS_JUMPING = false;
		
		if IS_JUMPING == false && on_platform == false:
			respawn();
		
		key_pressed = false;
	
		if Input.is_action_pressed("ui_right"):
			$CollisionShape2D.position.x += player_velocity;
			key_pressed = true;
		if Input.is_action_pressed("ui_left"):
			$CollisionShape2D.position.x -= player_velocity;
			key_pressed = true;
		if Input.is_action_pressed("ui_down"):
			$CollisionShape2D.position.y += player_velocity;
			key_pressed = true;
		if Input.is_action_pressed("ui_up"):
			$CollisionShape2D.position.y -= player_velocity;
			key_pressed = true;
		
		### Menu Handling
		
		if $StartMenu/VBoxContainer.visible:
			$Camera2D2.make_current();
		else:
			$CollisionShape2D/AnimatedSprite/Camera2D.make_current();

func _physics_process(delta):
	var areas = get_overlapping_areas();
	if areas.size() > 0:
		if IS_JUMPING == false:
			on_platform = true;
			
			if areas[0].name != "Area2D1":
				if areas[0].platform_point == false && !areas[0].is_bad:
					areas[0].platform_point = true;
					score += 1;
					emit_signal("score_change");
	else:
		if IS_JUMPING == false:
			on_platform = false;

func _on_AnimatedSprite_frame_changed():
	anim_frame = $CollisionShape2D/AnimatedSprite.frame;
	if anim_frame == 4 && GAME_START && key_pressed:
		$Jump.play();

func _on_AnimatedSprite_animation_finished():
	if $CollisionShape2D/AnimatedSprite.animation == "DIE":
		$CollisionShape2D/AnimatedSprite.play("MOVE");
		$CollisionShape2D.position = spawn;
		$Explode.play();

func _on_game_start():
	GAME_START = true;
	$Music.play();

func _on_game_pause():
	GAME_START = !GAME_START;

func _on_score_change():
	place_map(1, score+default_platforms-1);
	$CollisionShape2D/ScoreLabel.text = "SCORE = " + str(score);
	$Instructions.visible = false;
