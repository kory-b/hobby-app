# ProceduralRoomGenerator Documentation

## Overview
The `ProceduralRoomGenerator` is a new dungeon generator for your roguelike game that creates procedurally generated dungeons with configurable room sizes and counts.

## Features
- **Configurable room size**: Default 25x25 tiles, but can be adjusted
- **Configurable number of rooms**: Default 8 rooms, but can be set to any number
- **Different wall tiles**: Uses different tiles for top, bottom, left, and right walls
- **Player spawn**: Placed in the center of the first room
- **Exit ladder**: Placed in the center of the last room
- **Procedural layout**: Rooms are placed using directional branching with collision detection
- **Room connections**: Rooms are connected with corridors for navigation

## Configuration Properties
```gdscript
@export var room_size: int = 25        # Size of each room (configurable)
@export var num_rooms: int = 8          # Number of rooms to generate (configurable)
@export var world_size: Vector2i = Vector2i(500, 500)  # World bounds
@export var dungeon_seed: int = 0       # Seed for reproducible generation
```

## How It Works

### 1. Room Layout Generation
- Starts with the first room at a reasonable position in the world
- For each subsequent room, picks a random existing room to branch from
- Chooses a random direction (including diagonals) to place the new room
- Calculates distance (1-3 room sizes apart) to maintain spacing

### 2. Collision Resolution
- Checks world bounds to ensure rooms fit within the dungeon
- Prevents room overlaps by checking intersections with padding
- Retries placement up to 100 times per room to find valid positions

### 3. Room Connections
- Creates a linear connection path through all rooms
- Adds occasional extra connections for more interesting layouts
- May connect first and last room directly (30% chance)

### 4. Tile Generation
- Fills the world with wall tiles initially
- Carves out room floors and applies different wall tiles per side:
  - Top walls: `TOP_WALL_ATLAS_COORDS`
  - Bottom walls: `BOTTOM_WALL_ATLAS_COORDS`
  - Left walls: `LEFT_WALL_ATLAS_COORDS`
  - Right walls: `RIGHT_WALL_ATLAS_COORDS`
- Creates 3-tile wide corridors between connected rooms

### 5. Spawn Point Placement
- Player spawn: Center of the first generated room
- Exit spawn: Center of the last generated room

## Usage in DungeonManager
The generator is automatically configured by the `DungeonManager` using the existing export variables:

```gdscript
# Configure the generator with our settings
if dungeon_generator is ProceduralRoomGenerator:
    var proc_gen = dungeon_generator as ProceduralRoomGenerator
    proc_gen.room_size = min_room_size # Use configurable room size
    proc_gen.num_rooms = _rng.randi_range(min_rooms, max_rooms) # Random number of rooms
    proc_gen.world_size = world_size
    proc_gen.dungeon_seed = dungeon_seed
```

## Customization
You can easily customize the generator by:
- Adjusting `room_size` for larger/smaller rooms
- Changing `num_rooms` for more/fewer rooms
- Modifying the wall tile coordinates for different visual styles
- Adjusting corridor width in `_carve_corridor()`
- Changing room spacing by modifying the distance calculation

## Integration
The generator extends the base `Generator` class and implements the required interface:
- `generate(floor_layer: TileMapLayer, wall_layer: TileMapLayer)`
- `get_player_spawn() -> Vector2i`
- Provides `player_spawn`, `exit_spawn`, and `rooms` properties

This makes it a drop-in replacement for the existing `RoomCarvingGenerator`.
