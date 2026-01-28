class_name State_Attack extends State

var attacking : bool = false
var can_combo : bool = false
var combo_queued : bool = false
var combo_triggered : bool = false

@export var attack_sound : AudioStream 
@export_range(1,20, 0.5) var decelerate_speed : float = 5.0

@onready var walk : State = $"../Walk"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../Idle"
@onready var attack_2: State = $"../Attack2"
@onready var attack_anim = $"../../Sprite2D/Attack/AnimationPlayer"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox



func _ready():
	pass

##What Happens when the player enters this Sate
func Enter() -> void:
	if attacking == false :
		player.UpdateAnimation("attack")
		#attack_anim.play("attack_" + player.AnimDirection())
		animation_player.animation_finished.connect( EndAttack )
		
		audio.stream = attack_sound
		audio.pitch_scale = randf_range(0.9, 1.1)
		audio.play()
		
		attacking = true
		
		
		await get_tree().create_timer( 0.075 ).timeout
		
		if attacking:
			hurt_box.monitoring = true
		
			# --- Öffne das Kombofenster nach einem kurzen Moment ---
		#await get_tree().create_timer(0.3).timeout  # Zeitpunkt anpassen
		can_combo = true

		# --- Und schließe es nach z. B. 0.4 Sekunden ---
		await get_tree().create_timer(0.5).timeout
		can_combo = false
		
	pass

##What Happens when the player exits this Sate
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	hurt_box.monitoring = false
	ResetCombo()
	pass


func Process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta 
	
	if attacking == false :
		if combo_queued and not combo_triggered:
			combo_triggered = true  # <--- verhindert Doppeltrigger
			return attack_2
		
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


func Physics( _delta : float ) -> State:
	return null


func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack") and can_combo and attacking:
		combo_queued = true
		attacking = true
	return null


func EndAttack( _newAnimName : String ) -> void:
	attacking = false


func ResetCombo() -> void:
	combo_queued = false
	combo_triggered = false
	can_combo = false
