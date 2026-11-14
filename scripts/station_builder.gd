extends Node3D

# Builds placed props, fixtures, and pipe/cable runs from StationLayout constants.
# Reuses meshes from GLB assets (no material overrides on new assets).

const L = preload("res://scripts/station_layout.gd")

var _counts := {"fixtures": 0, "real_lights": 0, "pipe_segments": 0, "cable_segments": 0}
var _report := []

func _ready() -> void:
	_build_all()
	print("[station_builder] counts=", _counts)
	for r in _report:
		print("[station_builder] ", r)

func _build_all() -> void:
	_add_tank_assemblies()
	_add_power_screen()
	_add_bed()
	_add_storage_and_cabinet()
	_add_roof()
	_add_fixtures()
	_add_green_pipes()
	_add_blue_cables()

func _get_group(nm: String) -> Node3D:
	var g = get_node_or_null(nm)
	if g == null:
		g = Node3D.new()
		g.name = nm
		add_child(g)
	return g

func _load_mesh_from_scene(path: String) -> Mesh:
	if not ResourceLoader.exists(path):
		_report.append("MISSING asset: %s" % path)
		return null
	var ps = load(path)
	if ps == null:
		_report.append("FAILED load: %s" % path)
		return null
	if ps is PackedScene:
		var inst = ps.instantiate()
		var mi = _find_mesh_instance(inst)
		var mesh = mi.mesh if mi else null
		inst.free()
		return mesh
	return null

func _find_mesh_instance(n: Node) -> MeshInstance3D:
	if n is MeshInstance3D:
		return n
	for c in n.get_children():
		var r = _find_mesh_instance(c)
		if r: return r
	return null

func _instance_asset(path: String, scale_v: Vector3, yaw_deg: float, yaw_offset: float) -> Node3D:
	if not ResourceLoader.exists(path):
		_report.append("MISSING asset: %s" % path)
		return Node3D.new()
	var ps = load(path)
	if ps == null:
		return Node3D.new()
	var inst = ps.instantiate()
	if inst is Node3D:
		inst.scale = scale_v
		inst.rotation_degrees.y = yaw_deg + yaw_offset
	return inst

func _add_box_collision(parent: Node3D, size: Vector3, pos: Vector3 = Vector3.ZERO) -> void:
	var sb = StaticBody3D.new()
	sb.name = "Collision"
	var cs = CollisionShape3D.new()
	var sh = BoxShape3D.new()
	sh.size = size
	cs.shape = sh
	cs.position = pos
	sb.add_child(cs)
	parent.add_child(sb)

func _add_tank_assemblies() -> void:
	var g = _get_group("TankAssemblies")
	var base_size = Vector3(0.498, 0.998, 0.5605) * L.TANK_ASSEMBLY_SCALE # ESTIMATED scaled bounds
	var placements = [
		{"pos": L.TANK_SMALL1_POS, "yaw": L.TANK_SMALL1_YAW, "name": "TankSmallRoom1"},
		{"pos": L.TANK_LARGE_NW_POS, "yaw": L.TANK_LARGE_NW_YAW, "name": "TankLargeNW"},
		{"pos": L.TANK_LARGE_NE_POS, "yaw": L.TANK_LARGE_NE_YAW, "name": "TankLargeNE"},
		{"pos": L.TANK_LARGE_SW_POS, "yaw": L.TANK_LARGE_SW_YAW, "name": "TankLargeSW"},
		{"pos": L.TANK_LARGE_SE_POS, "yaw": L.TANK_LARGE_SE_YAW, "name": "TankLargeSE"},
	]
	for p in placements:
		var n = _instance_asset(L.ASSET_TANK_ASSEMBLY, L.TANK_ASSEMBLY_SCALE, p.yaw, L.TANK_ASSEMBLY_FRONT_YAW_OFFSET)
		n.name = p.name
		n.position = p.pos
		# collision sized to assembly bbox (centered approx at half height)
		var col = StaticBody3D.new(); col.name = "Body"
		var cs = CollisionShape3D.new(); var sh = BoxShape3D.new()
		sh.size = Vector3(base_size.x, base_size.y, base_size.z)
		cs.shape = sh; cs.position = Vector3(0, base_size.y * 0.5, 0)
		col.add_child(cs); n.add_child(col)
		g.add_child(n)

func _add_power_screen() -> void:
	var g = _get_group("PowerScreen")
	var n = _instance_asset(L.ASSET_POWER_SCREEN, L.POWER_SCREEN_SCALE, L.POWER_SCREEN_YAW, L.POWER_SCREEN_FRONT_YAW_OFFSET)
	n.name = "PowerScreenMain"
	n.position = L.POWER_SCREEN_POS
	g.add_child(n)

func _add_bed() -> void:
	var g = _get_group("Bed")
	var n = _instance_asset(L.ASSET_BED, L.BED_SCALE, L.BED_YAW, L.BED_FRONT_YAW_OFFSET)
	n.name = "BedSmallRoom3"
	n.position = L.BED_POS
	var col = StaticBody3D.new(); col.name = "Body"
	var cs = CollisionShape3D.new(); var sh = BoxShape3D.new()
	var sz = Vector3(0.998, 0.3496, 0.502) * L.BED_SCALE
	sh.size = sz; cs.shape = sh; cs.position = Vector3(0, sz.y * 0.5, 0)
	col.add_child(cs); n.add_child(col)
	g.add_child(n)

func _add_storage_and_cabinet() -> void:
	var g_store = _get_group("StorageContainer")
	var g_cab = _get_group("Cabinet")
	var store = _instance_asset(L.ASSET_STORAGE_CONTAINER, L.STORAGE_SCALE, L.STORAGE_YAW, L.STORAGE_FRONT_YAW_OFFSET)
	store.name = "StorageSmallRoom2"; store.position = L.STORAGE_POS
	var ssz = Vector3(0.998, 0.5332, 0.8223) * L.STORAGE_SCALE
	var scol = StaticBody3D.new(); var scs = CollisionShape3D.new(); var ssh = BoxShape3D.new()
	ssh.size = ssz; scs.shape = ssh; scs.position = Vector3(0, ssz.y * 0.5, 0)
	scol.add_child(scs); store.add_child(scol); g_store.add_child(store)
	var cab = _instance_asset(L.ASSET_CABINET, L.CABINET_SCALE, L.CABINET_YAW, L.CABINET_FRONT_YAW_OFFSET)
	cab.name = "CabinetSmallRoom2"; cab.position = L.CABINET_POS
	var csz = Vector3(0.5059, 0.998, 0.7598) * L.CABINET_SCALE
	var ccol = StaticBody3D.new(); var ccs = CollisionShape3D.new(); var csh = BoxShape3D.new()
	csh.size = csz; ccs.shape = csh; ccs.position = Vector3(0, csz.y * 0.5, 0)
	ccol.add_child(ccs); cab.add_child(ccol); g_cab.add_child(cab)

func _add_roof() -> void:
	var g = _get_group("Roof")
	# CSGCombiner3D union of per-room ceiling slabs (non-overlapping in plan to avoid coplanar z-fighting)
	var comb = CSGCombiner3D.new()
	comb.name = "CeilingCombiner"
	comb.use_collision = true
	comb.position = Vector3(0, L.CEILING_UNDERSIDE + L.CEILING_THICKNESS * 0.5, 0)
	var mat = load("res://materials/wall_greige.tres") if ResourceLoader.exists("res://materials/wall_greige.tres") else null
	# Large room slab
	var b1 = CSGBox3D.new(); b1.size = Vector3(20.0, L.CEILING_THICKNESS, 20.0); b1.position = Vector3(0,0,0)
	if mat: b1.material = mat
	comb.add_child(b1)
	# Small rooms (offset so they meet but not overlap large slab significantly)
	var b2 = CSGBox3D.new(); b2.size = Vector3(12.0, L.CEILING_THICKNESS, 12.0); b2.position = Vector3(12,0,0)
	if mat: b2.material = mat
	comb.add_child(b2)
	var b3 = CSGBox3D.new(); b3.size = Vector3(12.0, L.CEILING_THICKNESS, 12.0); b3.position = Vector3(-12,0,0)
	if mat: b3.material = mat
	comb.add_child(b3)
	var b4 = CSGBox3D.new(); b4.size = Vector3(12.0, L.CEILING_THICKNESS, 12.0); b4.position = Vector3(0,0,-12)
	if mat: b4.material = mat
	comb.add_child(b4)
	g.add_child(comb)

func _add_fixtures() -> void:
	var g = _get_group("LightFixtures")
	var mesh = _load_mesh_from_scene(L.ASSET_LIGHT_FIXTURE)
	# simple perimeter placement per room (ESTIMATED), spacing 4m, skip near door zones heuristically
	var rooms = [
		{"rect": L.LARGE_INNER, "y": L.CEILING_UNDERSIDE - 0.01},
		{"rect": L.SMALL1_INNER, "y": L.CEILING_UNDERSIDE - 0.01},
		{"rect": L.SMALL2_INNER, "y": L.CEILING_UNDERSIDE - 0.01},
		{"rect": L.SMALL3_INNER, "y": L.CEILING_UNDERSIDE - 0.01},
	]
	var positions = []
	for r in rooms:
		var rect: Rect2 = r.rect
		var x0 = rect.position.x; var z0 = rect.position.y
		var x1 = x0 + rect.size.x; var z1 = z0 + rect.size.y
		var s = L.FIXTURE_SPACING
		var x = x0 + s*0.5
		while x < x1:
			positions.append(Vector3(x, r.y, z0 + 0.2))
			positions.append(Vector3(x, r.y, z1 - 0.2))
			x += s
		var z = z0 + s*0.5
		while z < z1:
			positions.append(Vector3(x0 + 0.2, r.y, z))
			positions.append(Vector3(x1 - 0.2, r.y, z))
			z += s
	# cap lights at 60
	if positions.size() > 60:
		_report.append("Fixture count %d > 60; truncated to 60 (spacing should be raised)" % positions.size())
		positions = positions.slice(0, 60)
	_counts.fixtures = positions.size()
	_counts.real_lights = positions.size()
	# Use MultiMeshInstance3D if mesh available, else instance scenes
	if mesh:
		var mm = MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = mesh
		mm.instance_count = positions.size()
		var mmi = MultiMeshInstance3D.new()
		mmi.multimesh = mm
		mmi.name = "FixturesMultiMesh"
		g.add_child(mmi)
		for i in range(positions.size()):
			var t = Transform3D(Basis().scaled(L.FIXTURE_SCALE), positions[i])
			mm.set_instance_transform(i, t)
	else:
		for i in range(positions.size()):
			var n = _instance_asset(L.ASSET_LIGHT_FIXTURE, L.FIXTURE_SCALE, 0.0, L.FIXTURE_FRONT_YAW_OFFSET)
			n.position = positions[i]
			n.name = "Fixture_%d" % i
			g.add_child(n)
	for i in range(positions.size()):
		var l = OmniLight3D.new()
		l.name = "Light_%d" % i
		l.position = positions[i] + Vector3(0, 0, L.FIXTURE_LIGHT_FORWARD_OFFSET)
		l.light_color = L.FIXTURE_LIGHT_COLOR
		l.light_energy = L.FIXTURE_LIGHT_ENERGY
		l.omni_range = L.FIXTURE_LIGHT_RANGE
		l.shadow_enabled = false
		g.add_child(l)

func _add_green_pipes() -> void:
	var g = _get_group("GreenPipes")
	var mesh = _load_mesh_from_scene(L.ASSET_GREEN_PIPE)
	# simplified runs (ESTIMATED): RoomLarge perimeter at floor and branch to SmallRoom1
	var segs = []
	# along back wall of large room
	for x in range(-8, 9, 2): segs.append({"pos": Vector3(x, L.PIPE_BOTTOM_ABOVE_FLOOR, -9.3), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	# along front wall
	for x in range(-8, 9, 2): segs.append({"pos": Vector3(x, L.PIPE_BOTTOM_ABOVE_FLOOR, 9.3), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	# sides
	for z in range(-8, 9, 2): segs.append({"pos": Vector3(-9.3, L.PIPE_BOTTOM_ABOVE_FLOOR, z), "rot": Vector3(0, 0, 0), "len": 1.0})
	for z in range(-8, 9, 2): segs.append({"pos": Vector3(9.3, L.PIPE_BOTTOM_ABOVE_FLOOR, z), "rot": Vector3(0, 0, 0), "len": 1.0})
	# branch to SmallRoom1
	for x in range(10, 17, 2): segs.append({"pos": Vector3(x, L.PIPE_BOTTOM_ABOVE_FLOOR, 0), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	_counts.pipe_segments = segs.size()
	_place_segments(g, mesh, L.ASSET_GREEN_PIPE, L.GREEN_PIPE_BASE_SCALE, L.GREEN_PIPE_SEGMENT_LENGTH, segs)

func _add_blue_cables() -> void:
	var g = _get_group("BlueCables")
	var mesh = _load_mesh_from_scene(L.ASSET_BLUE_CABLE)
	var y = L.CEILING_UNDERSIDE - L.CABLE_TOP_BELOW_CEILING - 0.015
	var segs = []
	# ceiling runs per room (simplified rectangles) and connections
	for x in range(-8, 9, 2): segs.append({"pos": Vector3(x, y, -9.3), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	for x in range(-8, 9, 2): segs.append({"pos": Vector3(x, y, 9.3), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	for z in range(-8, 9, 2): segs.append({"pos": Vector3(-9.3, y, z), "rot": Vector3(0, 0, 0), "len": 1.0})
	for z in range(-8, 9, 2): segs.append({"pos": Vector3(9.3, y, z), "rot": Vector3(0, 0, 0), "len": 1.0})
	# to small rooms
	for x in range(10, 17, 2): segs.append({"pos": Vector3(x, y, 0), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	for x in range(-16, -9, 2): segs.append({"pos": Vector3(x, y, 0), "rot": Vector3(0, deg_to_rad(90), 0), "len": 1.0})
	for z in range(-16, -9, 2): segs.append({"pos": Vector3(0, y, z), "rot": Vector3(0, 0, 0), "len": 1.0})
	# a couple appliance drops (simplified)
	for yy in [3.5, 2.5, 1.5]: segs.append({"pos": Vector3(0, yy, 9.2), "rot": Vector3(deg_to_rad(90), 0, 0), "len": 1.0})
	_counts.cable_segments = segs.size()
	_place_segments(g, mesh, L.ASSET_BLUE_CABLE, L.BLUE_CABLE_BASE_SCALE, L.BLUE_CABLE_SEGMENT_LENGTH, segs)

func _place_segments(parent: Node3D, mesh: Mesh, asset_path: String, base_scale: Vector3, base_len: float, segs: Array) -> void:
	if mesh:
		var mm = MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = mesh
		mm.instance_count = segs.size()
		var mmi = MultiMeshInstance3D.new()
		mmi.multimesh = mm
		mmi.name = "SegmentsMultiMesh"
		parent.add_child(mmi)
		for i in range(segs.size()):
			var s = segs[i]
			var sc = base_scale
			sc.z = base_scale.z * (s.len / max(base_len, 0.001))
			var basis = Basis.from_euler(s.rot).scaled(sc)
			mm.set_instance_transform(i, Transform3D(basis, s.pos))
		_report.append("Used MultiMeshInstance3D for %s (%d segments)" % [asset_path, segs.size()])
	else:
		for i in range(segs.size()):
			var s = segs[i]
			var n = _instance_asset(asset_path, base_scale, 0, 0)
			n.scale = base_scale
			n.scale.z = base_scale.z * (s.len / max(base_len, 0.001))
			n.rotation = s.rot
			n.position = s.pos
			n.name = "Seg_%d" % i
			parent.add_child(n)
		_report.append("Instanced scenes per segment for %s (%d segments)" % [asset_path, segs.size()])
