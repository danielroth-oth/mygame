class_name Player extends CharacterBody2D


signal direction_changed(new_direction: Vector2)
signal player_damaged( hurt_box : HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT , Vector2.UP ]

var cadinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO  # Neue Variable zum Vergleich

var invulnerable : bool = false
@export var hp : int = 6
@export var max_hp : int = 6

var level : int = 1
var xp : int = 0



var attack : int = 1 : 
	set( v ) :
		attack = v
		update_damage_values()
var defense : int = 1

@onready var reflection = $Reflection
@onready var interactions: PlayerInteractionsHost = $Interactions
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box : HitBox = $HitBox



func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	update_damage_values()
	PlayerManager.player_leveled_up.connect( _on_player_leveld_up )
	pass


func _process(_delta):
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	
	pass


func _physics_process(_delta):
	move_and_slide()



func _unhandled_input(event) -> void:
	if event.is_action_pressed("test"):
		update_hp(-99)
		player_damaged.emit( %AttackHurtBox )
	pass


func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( (direction + cadinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cadinal_direction:
		return false
	
	cadinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cadinal_direction == Vector2.LEFT else 1
	return true



func UpdateAnimation(state : String) -> void:
	animation_player.play( state + "_" + AnimDirection())
	pass

func AnimDirection() -> String:
	if cadinal_direction == Vector2.DOWN:
		return "down"
	elif cadinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		


func update_sprite_direction(input: Vector2 ) -> void:
	if input != last_direction:
		last_direction = input
		direction_changed.emit(input)


func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true :
		return
	if hp > 0:
		var dmg : int = hurt_box.damage
		#defense math
		if dmg > 0:
			dmg = clampi( dmg - defense, 1, dmg )
		
		update_hp( - dmg )
		player_damaged.emit( hurt_box )
		
	pass


func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		PlayerManager.interact()


func revive_player() -> void:
	update_hp(99)
	state_machine.ChangeState( $StateMachine/Idle )


func update_damage_values() ->void:
	%AttackHurtBox.damage = attack
	#other attacks maybe .damage = attack * x( maybe 1.5 or 2)


func _on_player_leveld_up() -> void:
	effect_animation_player.play("level_up")
	update_hp( max_hp )
	pass
