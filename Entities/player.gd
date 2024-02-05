class_name Player extends CharacterBody2D

@export var speed: float = 200.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree

var direction: Vector2 = Vector2(0,0)

func _ready():
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x != 0:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if direction.y != 0:
		velocity.y = direction.y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	#update_animation()
	update_facing_direction()

#func update_animation():
#	animation_tree.set("parameters/Move/blend_position", direction.x)
	
func update_facing_direction():
	var is_new_direction: bool = false
	if direction.x > 0:
		is_new_direction = sprite.flip_h != false
		sprite.flip_h = false
	elif direction.x < 0:
		is_new_direction = sprite.flip_h != true
		sprite.flip_h = true
