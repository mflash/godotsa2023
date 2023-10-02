extends Node

export (PackedScene) var mob_scene
var score = 0

func _ready() -> void:
	randomize()

func new_game():
	score = 0
	$Player.position = $StartPosition.position
	$Player.show()
	$HUD.update_score(0)
	
	get_tree().call_group("mobs", "queue_free")
	
	$HUD.show_message("Get ready!")
	$StartTimer.start()
	yield($StartTimer, "timeout")
	$ScoreTimer.start()
	$MobTimer.start()
	
	$Music.play()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()

func _on_ScoreTimer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
func _on_MobTimer_timeout() -> void:
	
	var mob_spawn_location := $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf() # sorteia uma posição no caminho
	
	var mob = mob_scene.instance() # cria o inimigo
	
	mob.position = mob_spawn_location.position # usa a posição do caminho
	
	var direction = mob_spawn_location.rotation + PI/2 # gira 90 graus para dentro da tela
	direction += rand_range(-PI/4, PI/4) # adiciona pequena aleatoriedade na direção
	mob.rotation = direction # usa direction como rotação do inimigo

	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)	 # sorteia velocidade no invervalo
	mob.linear_velocity = velocity.rotated(direction) # ajusta velocidade do inimigo

	add_child(mob) # adiciona inimigo na cena
