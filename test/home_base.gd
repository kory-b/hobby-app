# home_base.gd
extends Node2D

@export var player_scene: PackedScene

func _ready():
    var spawn_point = $PlayerSpawn
    var player = player_scene.instantiate()
    player.position = spawn_point.global_position
    add_child(player)
