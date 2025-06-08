class_name TrainJoint
extends ConeTwistJoint3D


func destroy_on_train_exiting(train: TrainBody) -> void:
	train.tree_exiting.connect(_on_train_exiting)


func _on_train_exiting() -> void:
	queue_free()
