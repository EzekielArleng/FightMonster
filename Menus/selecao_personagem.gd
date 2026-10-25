extends Control

const CENA_MENU := "res://Menus/menu_inicial.tscn"
const CENA_JOGO := "res://main.tscn"

const JOGADORES: Array[int] = [1, 2]

const COR_P1 := Color(0.35, 0.65, 1.0)
const COR_P2 := Color(1.0, 0.4, 0.4)
const COR_AMBOS := Color(1.0, 0.85, 0.3)
const COR_NEUTRA := Color(0.3, 0.3, 0.38)

@onready var grade: GridContainer = $Margem/Coluna/CentroGrade/Grade
@onready var info_p1: Label = $Margem/Coluna/Jogadores/InfoP1
@onready var info_p2: Label = $Margem/Coluna/Jogadores/InfoP2
@onready var status: Label = $Margem/Coluna/Status
@onready var botao_voltar: Button = $Margem/Coluna/Voltar

# Elementos de cada card (na mesma ordem de Partida.PERSONAGENS)
var cards: Array[PanelContainer] = []
var fotos: Array[TextureRect] = []
var estados: Array[Label] = []

# Em qual card cada jogador está com o cursor
var cursor: Dictionary[int, int] = {1: 0, 2: 0}

# Personagem já confirmado por cada jogador (-1 = ainda não confirmou)
var escolha: Dictionary[int, int] = {1: -1, 2: -1}


func _ready() -> void:
	for dados in Partida.PERSONAGENS:
		_criar_card(dados)

	# O jogador 2 começa no segundo card (se existir) para os cursores não nascerem juntos
	cursor[2] = mini(1, cards.size() - 1)

	botao_voltar.pressed.connect(voltar_ao_menu)
	_atualizar_visual()


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel")):
		voltar_ao_menu()
		return

	for jogador in JOGADORES:
		if (event.is_action_pressed(_acao("Mov_esquerda", jogador))):
			_mover_cursor(jogador, -1, 0)
		elif (event.is_action_pressed(_acao("Mov_direita", jogador))):
			_mover_cursor(jogador, 1, 0)
		elif (event.is_action_pressed(_acao("Mov_cima", jogador))):
			_mover_cursor(jogador, 0, -1)
		elif (event.is_action_pressed(_acao("Mov_baixo", jogador))):
			_mover_cursor(jogador, 0, 1)
		elif (event.is_action_pressed(_acao("Ataque_neutro", jogador))):
			_confirmar(jogador)
		elif (event.is_action_pressed(_acao("Block_evasao", jogador))):
			_cancelar(jogador)


# ------------------------------------------------ Ações dos jogadores

func _mover_cursor(jogador: int, dx: int, dy: int) -> void:
	# Quem já confirmou fica "travado" até cancelar
	if (escolha[jogador] != -1):
		return

	var total: int = cards.size()
	var atual: int = cursor[jogador]
	var novo: int = atual

	if (dx != 0):
		novo = posmod(atual + dx, total)
	elif (dy != 0):
		var candidato: int = atual + dy * grade.columns
		if (candidato >= 0 and candidato < total):
			novo = candidato

	cursor[jogador] = novo
	_atualizar_visual()


func _confirmar(jogador: int) -> void:
	# Com os dois prontos, qualquer confirmação inicia a luta
	if (_ambos_prontos()):
		_iniciar_luta()
		return

	if (escolha[jogador] != -1):
		return

	var indice: int = cursor[jogador]
	var dono: int = _dono_do_personagem(indice)

	# REGRA PRINCIPAL: um personagem não pode ser escolhido pelos dois jogadores
	if (dono != 0):
		status.text = "Esse personagem já foi escolhido pelo Jogador %d!" % dono
		return

	escolha[jogador] = indice
	_atualizar_visual()


func _cancelar(jogador: int) -> void:
	if (escolha[jogador] == -1):
		return

	escolha[jogador] = -1
	_atualizar_visual()


func _iniciar_luta() -> void:
	for jogador in JOGADORES:
		Partida.definir_escolha(jogador, escolha[jogador])

	get_tree().change_scene_to_file(CENA_JOGO)


func voltar_ao_menu() -> void:
	get_tree().change_scene_to_file(CENA_MENU)


# ------------------------------------------------ Consultas

# Retorna qual jogador (1 ou 2) já confirmou esse personagem; 0 se ele está livre
func _dono_do_personagem(indice: int) -> int:
	for jogador in JOGADORES:
		if (escolha[jogador] == indice):
			return jogador
	return 0


func _ambos_prontos() -> bool:
	return escolha[1] != -1 and escolha[2] != -1


func _acao(nome: String, jogador: int) -> String:
	return nome + "_p" + str(jogador)


func _cor_do_jogador(jogador: int) -> Color:
	return COR_P1 if jogador == 1 else COR_P2


# ------------------------------------------------ Visual

func _criar_card(dados: Dictionary) -> void:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(200, 250)

	var coluna := VBoxContainer.new()
	coluna.add_theme_constant_override("separation", 8)
	card.add_child(coluna)

	var foto := TextureRect.new()
	foto.texture = load(dados["imagem"]) as Texture2D
	foto.custom_minimum_size = Vector2(180, 160)
	foto.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	foto.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	coluna.add_child(foto)

	var nome := Label.new()
	nome.text = dados["nome"]
	nome.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nome.add_theme_font_size_override("font_size", 24)
	coluna.add_child(nome)

	var estado := Label.new()
	estado.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coluna.add_child(estado)

	grade.add_child(card)
	cards.append(card)
	fotos.append(foto)
	estados.append(estado)


func _criar_estilo(cor_borda: Color, largura: int) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.16, 0.16, 0.22)
	estilo.border_color = cor_borda
	estilo.set_border_width_all(largura)
	estilo.set_corner_radius_all(8)
	estilo.set_content_margin_all(10)
	return estilo


func _atualizar_visual() -> void:
	for i in cards.size():
		var dono: int = _dono_do_personagem(i)
		var p1_aqui: bool = cursor[1] == i
		var p2_aqui: bool = cursor[2] == i

		# Cor da borda: dono (se já escolhido) > cursores > neutra
		var cor: Color = COR_NEUTRA
		var largura: int = 2
		if (dono != 0):
			cor = _cor_do_jogador(dono)
			largura = 6
		elif (p1_aqui and p2_aqui):
			cor = COR_AMBOS
			largura = 6
		elif (p1_aqui):
			cor = COR_P1
			largura = 6
		elif (p2_aqui):
			cor = COR_P2
			largura = 6

		cards[i].add_theme_stylebox_override("panel", _criar_estilo(cor, largura))

		# Personagem já escolhido fica escurecido (indisponível para o outro jogador)
		fotos[i].modulate = Color(0.45, 0.45, 0.45) if dono != 0 else Color.WHITE

		var partes := PackedStringArray()
		for jogador in JOGADORES:
			if (escolha[jogador] == i):
				partes.append("P%d PRONTO" % jogador)
			elif (cursor[jogador] == i):
				partes.append("P%d" % jogador)
		estados[i].text = "  ".join(partes)

	info_p1.text = _texto_jogador(1)
	info_p2.text = _texto_jogador(2)

	if (_ambos_prontos()):
		status.text = "Os dois estão prontos! Aperte CONFIRMAR para lutar (ou CANCELAR para trocar)."
	else:
		status.text = "Cada personagem só pode ser escolhido por um jogador."


func _texto_jogador(jogador: int) -> String:
	var situacao: String = "escolhendo..."
	if (escolha[jogador] != -1):
		var dados: Dictionary = Partida.PERSONAGENS[escolha[jogador]]
		situacao = "%s (pronto)" % dados["nome"]

	var mover: String = " ".join([
		_nome_tecla(_acao("Mov_cima", jogador)),
		_nome_tecla(_acao("Mov_esquerda", jogador)),
		_nome_tecla(_acao("Mov_baixo", jogador)),
		_nome_tecla(_acao("Mov_direita", jogador)),
	])

	return "JOGADOR %d: %s\nMover: %s | Confirmar: %s | Cancelar: %s" % [
		jogador,
		situacao,
		mover,
		_nome_tecla(_acao("Ataque_neutro", jogador)),
		_nome_tecla(_acao("Block_evasao", jogador)),
	]


# Nome da tecla de uma ação, do jeito que aparece no teclado de quem está jogando
func _nome_tecla(acao: String) -> String:
	for evento in InputMap.action_get_events(acao):
		var tecla_evento := evento as InputEventKey
		if (tecla_evento == null):
			continue

		var tecla: Key = DisplayServer.keyboard_get_keycode_from_physical(tecla_evento.physical_keycode)
		if (tecla == KEY_NONE):
			tecla = tecla_evento.physical_keycode
		return OS.get_keycode_string(tecla)

	return "?"
