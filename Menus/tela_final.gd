class_name TelaFinal
extends Control

const CENA_MENU := "res://Menus/menu_inicial.tscn"
const CENA_SELECAO := "res://Menus/selecao_personagem.tscn"

const COR_P1 := Color(0.35, 0.65, 1.0)
const COR_P2 := Color(1.0, 0.4, 0.4)

@onready var titulo: Label = $CenterContainer/VBoxContainer/Titulo
@onready var botao_menu: Button = $CenterContainer/VBoxContainer/MenuPrincipal
@onready var botao_reiniciar: Button = $CenterContainer/VBoxContainer/Reiniciar
@onready var botao_selecao: Button = $CenterContainer/VBoxContainer/Selecao


func _ready() -> void:
	hide()  # só aparece quando alguém vencer

	botao_menu.pressed.connect(ir_para_menu)
	botao_reiniciar.pressed.connect(reiniciar_luta)
	botao_selecao.pressed.connect(ir_para_selecao)


func mostrar(vencedor: int) -> void:
	titulo.text = "JOGADOR %d VENCEU" % vencedor
	titulo.add_theme_color_override("font_color", COR_P1 if vencedor == 1 else COR_P2)

	show()
	botao_reiniciar.grab_focus()  # já deixa um botão selecionado para navegar com o teclado


func ir_para_menu() -> void:
	get_tree().change_scene_to_file(CENA_MENU)


func reiniciar_luta() -> void:
	# Recarrega o main.tscn; os personagens escolhidos continuam guardados no Partida
	get_tree().reload_current_scene()


func ir_para_selecao() -> void:
	get_tree().change_scene_to_file(CENA_SELECAO)
