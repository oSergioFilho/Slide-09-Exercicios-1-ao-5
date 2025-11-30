extends CharacterBody3D

# Variáveis de Configuração (Exportadas para o Inspetor)
@export var move_speed: float = 6.0
@export var jump_speed: float = 6.5
@export var accel: float = 12.0
@export var air_control: float = 3.5
@export var camera_sensitivity: float = 2.0 # Velocidade de rotação da câmera

var gravity: float

func _ready() -> void:
	# Obtém a gravidade padrão do projeto
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	# Trava o cursor no centro da tela para melhor controle de câmera
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# 1) Gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2) Direção de movimento no plano XZ (Input)
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
	)

	var wish_dir = Vector3.ZERO
	if input_dir.length() > 0.0:
		input_dir = input_dir.normalized()
		
		# --- MOVIMENTO RELATIVO À CÂMERA ---
		wish_dir = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
		# -----------------------------------

	# 3) Aceleração / desaceleração
	var target_vel = wish_dir * move_speed
	var lerp_factor = accel * delta if is_on_floor() else air_control * delta

	velocity.x = lerp(velocity.x, target_vel.x, clamp(lerp_factor, 0.0, 1.0))
	velocity.z = lerp(velocity.z, target_vel.z, clamp(lerp_factor, 0.0, 1.0))

	# 4) Pulo (Space/Enter = "ui_accept")
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_speed

	# 5) Move com colisões
	move_and_slide()

	# 6) ROTAÇÃO DA CÂMERA (COM SETAS ESQUERDA/DIREITA)
	var rotation_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if rotation_input != 0.0:
		rotate_y(deg_to_rad(-rotation_input * camera_sensitivity * delta * 60.0))
