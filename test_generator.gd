# Simple test script to verify the ProceduralRoomGenerator works
extends SceneTree

func _init():
	print("Testing ProceduralRoomGenerator...")
	
	# Create a mock TileMapLayer class for testing
	var MockTileMapLayer = preload("res://test_mock_tilemap.gd")
	
	var floor_layer = MockTileMapLayer.new()
	var wall_layer = MockTileMapLayer.new()
	
	# Create and configure the generator
	var generator = ProceduralRoomGenerator.new()
	generator.room_size = 25
	generator.num_rooms = 5
	generator.world_size = Vector2i(200, 200)
	generator.dungeon_seed = 12345
	
	# Generate the dungeon
	generator.generate(floor_layer, wall_layer)
	
	print("Generation complete!")
	print("Number of rooms generated: ", generator.rooms.size())
	print("Player spawn: ", generator.player_spawn)
	print("Exit spawn: ", generator.exit_spawn)
	
	# Print room details
	for i in range(generator.rooms.size()):
		var room = generator.rooms[i]
		print("Room ", i, ": Position=", room.position, " Size=", room.size)
	
	quit()
