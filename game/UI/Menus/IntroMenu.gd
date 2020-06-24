extends Node2D

###INTRO MENU 

const section_time := 2.0
const line_time := 0.8
const base_speed := 40
const speed_up_multiplier := 10.0
const title_color := Color8(203, 202, 202)
const description_color := Color8(203, 202, 202)

var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []
var color_line = false

var credits = [
	[
		"Años antes de que la gran rebelión humana fuera reprimida por las",
		 "inteligencias artificiales, un grupo insurgente de cientificos", 
		 "trabajaba dia y noche en la creación de un 'arma definitiva'",
		 "su misión era desconocida pero primordial para la raza humana."
	],[
		"Por razones indeterminadas el grupo de cientificos se disolvio",
		 "y no se supo mas de ellos ni de su proyecto",
		 "La historia se transimitio entre generaciones",
		 "como un misterio del cual nadie sabia mucho mas."
		
	],[
		"100 años han pasado desde aquel momento en el cual los humanos",
		"fueron subyugados por las maquinas. Los sistemas de la rebelion",
		"captaron anomalias en el sector de 'La ciudad inteligente',", 
		"el fuerte impenetrable de las maquinas."
		
	],[
		"Los sistemas determinaron que la anomalia se debe a un androide",
		"rebelde que no pertenece al registro de las inteligencias artificiales", 
		"ha penetrado todas las barreras para ingresar a la ciudad.",
		"Todo indica que este androide es el arma definitiva de los cientificos.",
		"Activado por si solo por alguna extraña razon."
	],[
		"No tenemos ningún información adicional…",
		"solo su nombre"
	
	],[
		"",
		"",
		"",
		"",
	],

]

func _ready() -> void:
	GlobalMusic.play_music(GlobalMusic.musics.intro)

func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
				
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		get_tree().change_scene("res://game/Levels/LevelOne_v2.tscn")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	elif curr_line != 0:
	 new_line.add_color_override("font_color", description_color)
	
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
