extends Node3D

# Referência à SpotLight3D que queremos controlar
@onready var dynamic_light: SpotLight3D = $DynamicLight

# Função auxiliar para gerar uma cor aleatória vibrante
func generate_random_color():
	var h = randf()
	var s = randf_range(0.7, 1.0)
	var v = randf_range(0.7, 1.0)
	return Color.from_hsv(h, s, v)

# Função para lidar com a entrada do usuário (cliques)
func _input(event):
	# Verifica se o evento é um clique do botão esquerdo do mouse
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 1. Gera uma nova cor aleatória
		var new_color = generate_random_color()
		
		# 2. Aplica a nova cor à luz
		# A cor da luz é definida na propriedade 'light_color'
		dynamic_light.light_color = new_color
		
		# Opcional: Você pode também mudar a cor da luz de fundo (DirectionalLight3D)
		# $DirectionalLight3D.light_color = new_color.darkened(0.5)

# Opcional: Para garantir que o input funcione mesmo sem o cubo se mover
func _ready():
	set_process_input(true)
