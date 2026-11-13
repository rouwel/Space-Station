extends Node3D

@export var wall_material: Material = preload("res://materials/wall_red.tres")

func _ready() -> void:
	var targets := [
		$RoomLarge,
		$SmallRoom1,
		$SmallRoom2,
		$SmallRoom3,
	]
	for target in targets:
		_apply_to_meshes(target)

	# Blocker wall pieces are template-wall instances under each small room
	for room_name in ["SmallRoom1", "SmallRoom2", "SmallRoom3"]:
		var room := get_node_or_null(room_name)
		if room == null:
			continue
		for child in room.get_children():
			if child.name.begins_with("Blocker"):
				_apply_to_meshes(child)

func _apply_to_meshes(node: Node) -> void:
	if node == null:
		return
	if node is MeshInstance3D:
		node.material_override = wall_material
	for child in node.get_children():
		_apply_to_meshes(child)
