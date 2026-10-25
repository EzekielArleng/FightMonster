extends Control

const CENA_SELECAO := "res://Menus/selecao_personagem.tscn"

@onready var botao_jogar: Button = $CenterContainer/VBoxContainer/Jogar
@onready var botao_sair: Button = $CenterContainer/VBoxContainer/Sair

func _ready() -> void:
	botao_jogar.pressed.connect(ir_para_selecao)
	botao_sair.pressed.connect(sair_do_jogo)
	botao_jogar.grab_focus()  # deixa o botão selecionado para navegar com teclado

func ir_para_selecao() -> void:
	get_tree().change_scene_to_file(CENA_SELECAO)

func sair_do_jogo() -> void:
	get_tree().quit()
