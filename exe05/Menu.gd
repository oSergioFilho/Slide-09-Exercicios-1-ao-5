extends Control

const LEVEL_SCENE = preload("res://Level.tscn")

# A função de callback deve ser declarada com 'func' e, idealmente, '-> void'
func _on_button_pressed() -> void:
	# A maneira mais segura e recomendada de trocar de cena no Godot
	var error = get_tree().change_scene_to_packed(LEVEL_SCENE)
	
	if error != OK:
		print("ERRO ao carregar a cena 3D: ", error)
