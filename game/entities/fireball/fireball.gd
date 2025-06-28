extends Area2D

var acceleration = 900
var speed = 100
var direction = Vector2.ZERO
var rotation_speed = 10

func _ready():
	$GPUParticles2D.emitting = true


func _physics_process(delta):
	speed += acceleration * delta
	position += direction * speed * delta
	rotation += rotation_speed * delta


func _on_body_entered(_body):
	print("Fireball hit something")
	#$GPUParticles2D.emitting = false
	#$Polygon2D.hide()
	#await get_tree().create_timer($GPUParticles2D.lifetime + 1).timeout
	queue_free()
