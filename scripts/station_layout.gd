extends RefCounted
class_name StationLayout

# All placement/layout constants for station_additions.tscn / station_builder.gd
# Units are metres (1 unit = 1 metre). Adjust values here to fine-tune placement.

# --- Asset paths (new GLB assets; do not rename/move assets) ---
const ASSET_POWER_SCREEN := "res://assets/power_screen_slim_tv.glb"
const ASSET_TANK_ASSEMBLY := "res://assets/oxygen_tank_station.glb"
const ASSET_CABINET := "res://assets/cabinet.glb"
const ASSET_BED := "res://assets/small_bed.glb"
const ASSET_STORAGE_CONTAINER := "res://assets/storage_container.glb"
const ASSET_GREEN_PIPE := "res://assets/green_pipe_segment.glb"
const ASSET_BLUE_CABLE := "res://assets/blue_cable_segment.glb"
const ASSET_LIGHT_FIXTURE := "res://assets/light_fixture.glb"

# --- Measured AABB sizes from GLB JSON (accessor min/max), units/metres (ESTIMATED from file data) ---
# power_screen_slim_tv.glb: size (0.0879, 0.5176, 0.998)
# oxygen_tank_station.glb (chosen two-tank assembly): size (0.498, 0.998, 0.5605)
# cabinet.glb: size (0.5059, 0.998, 0.7598)
# small_bed.glb: size (0.998, 0.3496, 0.502)
# storage_container.glb: size (0.998, 0.5332, 0.8223)
# light_fixture.glb: size (0.4082, 0.8496, 0.998)
# green_pipe_segment.glb: size (0.377, 0.1465, 0.998) (length axis Z, cross ~X/Y)
# blue_cable_segment.glb: size (0.8418, 0.9355, 0.998) (length axis Z, cross ~X/Y)

# --- Uniform scales applied to fit target real-world sizes ---
# Assumes glTF forward = +Z by default. FRONT_YAW_OFFSET adjusts facing per asset.
const POWER_SCREEN_SCALE := Vector3(2.0, 2.0, 2.0) # ~2.0m wide (Z axis) keeping aspect (ESTIMATED axis mapping)
const POWER_SCREEN_FRONT_YAW_OFFSET := 0.0
const TANK_ASSEMBLY_SCALE := Vector3(1.8, 1.8, 1.8) # height ~1.796m (target 1.6-2.0)
const TANK_ASSEMBLY_FRONT_YAW_OFFSET := 0.0
const CABINET_SCALE := Vector3(2.37, 2.37, 2.37) # width ~1.199m (target ~1.2m)
const CABINET_FRONT_YAW_OFFSET := 0.0
const STORAGE_SCALE := Vector3(1.0, 1.5, 1.0) # width ~0.998m, height ~0.8m (uniform-ish fit; see report)
const STORAGE_FRONT_YAW_OFFSET := 0.0
const BED_SCALE := Vector3(2.0, 2.0, 2.0) # length ~1.996m, width ~1.004m (target 2.0x1.0)
const BED_FRONT_YAW_OFFSET := 0.0
const FIXTURE_SCALE := Vector3(0.25, 0.25, 0.25) # ~0.212m height-ish (target 0.15-0.3m)
const FIXTURE_FRONT_YAW_OFFSET := 0.0
# Pipe/cable: uniform base scale to reach target diameter on cross-section; length scaled per-segment in builder
const GREEN_PIPE_BASE_SCALE := Vector3(0.265, 0.68, 1.0) # cross ~0.1m (ESTIMATED), length axis Z kept for segment scaling
const GREEN_PIPE_FRONT_YAW_OFFSET := 0.0
const GREEN_PIPE_DIAMETER := 0.1
const GREEN_PIPE_SEGMENT_LENGTH := 0.998 # base mesh length along Z before length scaling
const BLUE_CABLE_BASE_SCALE := Vector3(0.036, 0.032, 1.0) # cross ~0.03m (ESTIMATED), length axis Z
const BLUE_CABLE_FRONT_YAW_OFFSET := 0.0
const BLUE_CABLE_DIAMETER := 0.03
const BLUE_CABLE_SEGMENT_LENGTH := 0.998

# --- Room geometry (ESTIMATED from room GLB AABBs; inner faces ~0.5m inside AABB) ---
const CEILING_HEIGHT := 4.25
const CEILING_UNDERSIDE := 4.25
const CEILING_THICKNESS := 0.3
# RoomLarge at (0,0,0), AABB X -10..10 Z -10..10
const LARGE_INNER := Rect2(-9.5, -9.5, 19.0, 19.0) # x,z,w,h (ESTIMATED)
const LARGE_CENTER := Vector3(0, 0, 0)
# Small rooms (12x12 AABB centered)
const SMALL1_CENTER := Vector3(12, 0, 0)  # SmallRoom1
const SMALL1_INNER := Rect2(6.5, -5.5, 11.0, 11.0) # ESTIMATED
const SMALL2_CENTER := Vector3(-12, 0, 0) # SmallRoom2 (rotated 180Y in scene)
const SMALL2_INNER := Rect2(-17.5, -5.5, 11.0, 11.0) # ESTIMATED in world
const SMALL3_CENTER := Vector3(0, 0, -12) # SmallRoom3 (rotated 90Y)
const SMALL3_INNER := Rect2(-5.5, -17.5, 11.0, 11.0) # ESTIMATED in world
# Doorways/openings: UNKNOWN/ESTIMATED (not measurable without Godot/mesh internals). Assumed openings near room connections; placements avoid likely doorway zones.

# --- Fixture/light layout ---
const FIXTURE_SPACING := 4.0 # metres (raise if >60 lights would be created)
const FIXTURE_WALL_GAP := 0.01
const FIXTURE_TOP_BELOW_CEILING := 0.01
const FIXTURE_DOORWAY_CLEARANCE := 1.0
const FIXTURE_OBSTACLE_CLEARANCE := 0.5
const FIXTURE_LIGHT_COLOR := Color(1.0, 0.886, 0.69) # #FFE2B0
const FIXTURE_LIGHT_ENERGY := 0.8
const FIXTURE_LIGHT_RANGE := 6.0
const FIXTURE_LIGHT_FORWARD_OFFSET := 0.3

# --- Cable (blue) ---
const CABLE_WALL_GAP := 0.01
const CABLE_TOP_BELOW_CEILING := 0.005

# --- Pipe (green) ---
const PIPE_WALL_GAP := 0.01
const PIPE_BOTTOM_ABOVE_FLOOR := 0.005

# --- Item placements (world positions, yaw degrees around Y, and notes) ---
# Tank assemblies: back offset from wall = (GREEN_PIPE_DIAMETER + 0.03)
const TANK_BACK_OFFSET := GREEN_PIPE_DIAMETER + 0.03
# SmallRoom1: one assembly against far wall (opposite doorway). Doorway side ESTIMATED toward RoomLarge (-X side of small room footprint)
const TANK_SMALL1_POS := Vector3(17.0, 0.0, 0.0) # ESTIMATED on far (+X) inner wall side
const TANK_SMALL1_YAW := 180.0 # face into room (-X), plus FRONT_YAW_OFFSET
# RoomLarge: one per corner, 5cm gap from side wall, shifted if near doorway (ESTIMATED)
const TANK_LARGE_NW_POS := Vector3(-9.0, 0.0, -9.35) # ESTIMATED
const TANK_LARGE_NW_YAW := 0.0
const TANK_LARGE_NE_POS := Vector3(9.0, 0.0, -9.35) # ESTIMATED
const TANK_LARGE_NE_YAW := 0.0
const TANK_LARGE_SW_POS := Vector3(-9.0, 0.0, 9.35) # ESTIMATED
const TANK_LARGE_SW_YAW := 180.0
const TANK_LARGE_SE_POS := Vector3(9.0, 0.0, 9.35) # ESTIMATED
const TANK_LARGE_SE_YAW := 180.0
const TANK_SIDE_GAP := 0.05

# Power screen: RoomLarge +Z (south) wall centered, centre y=2.0, back flush (ESTIMATED)
const POWER_SCREEN_POS := Vector3(0.0, 2.0, 9.45) # ESTIMATED
const POWER_SCREEN_YAW := 180.0 # face into room (-Z)

# SmallRoom3 bed: headboard against wall, away from doorway, >=0.8m walkway on open sides (ESTIMATED)
const BED_POS := Vector3(0.0, 0.0, -15.5) # ESTIMATED
const BED_YAW := 0.0

# SmallRoom2 storage + cabinet on same wall (ESTIMATED)
const STORAGE_POS := Vector3(-15.5, 0.0, -2.0) # on floor against wall (ESTIMATED)
const STORAGE_YAW := 90.0
const CABINET_GAP_ABOVE_STORAGE := 0.15
const CABINET_POS := Vector3(-15.5, 0.95, -2.0) # bottom at container top + 0.15 (ESTIMATED; builder may refine)
const CABINET_YAW := 90.0
