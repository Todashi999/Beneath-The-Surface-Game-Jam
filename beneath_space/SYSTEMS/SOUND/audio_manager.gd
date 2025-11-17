extends Node2D


@onready var blackhole: AudioStreamPlayer = $Blackhole
@onready var dash: AudioStreamPlayer = $Dash
@onready var death: AudioStreamPlayer = $Death
@onready var door_opened: AudioStreamPlayer = $DoorOpened
@onready var door_open_2: AudioStreamPlayer = $DoorOpen2
@onready var end_sound: AudioStreamPlayer = $EndSound
@onready var hit_hurt: AudioStreamPlayer = $HitHurt
@onready var idk: AudioStreamPlayer = $Idk
@onready var jump: AudioStreamPlayer = $Jump
@onready var select: AudioStreamPlayer = $Select
@onready var star_pickup: AudioStreamPlayer = $StarPickup
@onready var star_sound_default: AudioStreamPlayer = $StarSoundDefault
@onready var swim_jump: AudioStreamPlayer = $SwimJump
@onready var main_song_1: AudioStreamPlayer = $MainSong1
@onready var water_entered: AudioStreamPlayer = $Water
@onready var exit_water: AudioStreamPlayer = $ExitWater
@onready var main_song_2: AudioStreamPlayer = $MainSong2
@onready var swim_jump_2: AudioStreamPlayer = $SwimJump2
@onready var wall_jump_2: AudioStreamPlayer = $WallJump2
@onready var main_song_3: AudioStreamPlayer = $MainSong3
@onready var credits_song: AudioStreamPlayer = $CreditsSong


func _play(player: AudioStreamPlayer, volume: int) -> void:
	player.volume_db = volume
	player.play()


func play_sound(sound: String) -> void:
	match sound:
		"blackhole":
			_play(blackhole, -25)
		"dash":
			_play(dash, -20)
		"death":
			_play(death, -20)
		"door_opened":
			_play(door_opened, -20)
		"door_opened_2":
			_play(door_open_2, -20)
		"end_sound":
			_play(end_sound, -10)
		"hit_hurt":
			_play(hit_hurt, -10)
		"idk":
			_play(idk, -20)
		"jump":
			_play(jump, -20)
		"wall_jump_2":
			_play(wall_jump_2, -20)
		"swim_jump_2":
			_play(swim_jump_2, -20)
		"select":
			_play(select, -20)
		"star_pickup":
			_play(star_pickup, -20)
		"star_sound_default":
			_play(star_sound_default, -20)
		"swim_jump":
			_play(swim_jump, -20)
		"main_song_1":
			_play(main_song_1, -10)
		"main_song_2":
			_play(main_song_2, -15)
		"main_song_3":
			_play(main_song_3, -15)
		"credits":
			_play(credits_song, -15)
		"water_entered":
			_play(water_entered, -25)
		"exit_water":
			_play(exit_water, -10)


func stop_sound(sound: String) -> void:
	var player: AudioStreamPlayer = null
	
	match sound:
		"dash":
			player = dash
		"death":
			player = death
		"door_opened":
			player = door_opened
		"door_opened_2":
			player = door_open_2
		"end_sound":
			player = end_sound
		"hit_hurt":
			player = hit_hurt
		"idk":
			player = idk
		"jump":
			player = jump
		"wall_jump_2":
			player = wall_jump_2
		"swim_jump_2":
			player = swim_jump_2
		"select":
			player = select
		"star_pickup":
			player = star_pickup
		"star_sound_default":
			player = star_sound_default
		"swim_jump":
			player = swim_jump
		"main_song_1":
			player = main_song_1
		"main_song_2":
			player = main_song_2
		"main_song_3":
			player = main_song_3
		"credits":
			player = credits_song
		"water_entered":
			player = water_entered
		"exit_water":
			player = exit_water
	
	if player:
		var tween := create_tween()
		tween.tween_property(player, "volume_db", -60, 1.0)
		tween.tween_callback(func(): player.stop())
