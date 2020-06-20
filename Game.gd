extends Node2D


const LEVEL_PATH = "res://Levels/Level%d.tscn"

var level_num:int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("init")
	

func init():
	load_level(level_num)


func load_level(num:int):
	var root = get_tree().root
	if root.has_node("Level"):
		root.remove_child($Level)
	
	#todo: check if level actually exists
	var level = load(LEVEL_PATH % num).instance()
	root.add_child(level)
	return true
