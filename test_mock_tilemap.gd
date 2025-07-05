# Mock TileMapLayer class for testing
extends RefCounted
class_name MockTileMapLayer

var tiles = {}

func set_cell(pos: Vector2i, source_id: int, atlas_coords: Vector2i):
	tiles[pos] = {"source_id": source_id, "atlas_coords": atlas_coords}

func erase_cell(pos: Vector2i):
	if tiles.has(pos):
		tiles.erase(pos)

func clear():
	tiles.clear()

func get_cell_count() -> int:
	return tiles.size()
