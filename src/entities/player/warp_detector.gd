class_name WarpDetector
extends Area2D


func can_warp(target_position: Vector2) -> bool:
	var overlaps := get_overlapping_areas() + get_overlapping_bodies()

	for node in overlaps:
		if node.is_in_group("tile_maps"):
			return false

	return true
