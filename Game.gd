extends Node2D

var scene = preload("res://Platform.tscn")
var player = preload("res://Player.tscn")

func place_map(levels):
	randomize();
	for i in levels:
		var rand = randi()%2;
		for j in 2:
			var node = scene.instance();
			
			if j == 2:
				node.is_bad = !rand;
			else:
				node.is_bad = rand;
			
			add_child(node);


# Called when the node enters the scene tree for the first time.
func _ready():
	var newplayer = player.instance();
	add_child(newplayer);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
