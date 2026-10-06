extends Control

@onready var botao_continuar: Button = $CenterContainer/VBoxContainer/Continuar
@onready var botao_sair: Button = $CenterContainer/VBoxContainer/Sair


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	botao_continuar.pressed.connect(continuar_jogo)
	botao_sair.pressed.connect(sair_do_jogo)

	hide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			
			if get_tree().paused:
				continuar_jogo()
			else:
				pausar_jogo()

			get_viewport().set_input_as_handled()


func pausar_jogo() -> void:
	get_tree().paused = true
	show()
	botao_continuar.grab_focus()


func continuar_jogo() -> void:
	get_tree().paused = false
	hide()


func sair_do_jogo() -> void:
	get_tree().paused = false
	get_tree().quit()
