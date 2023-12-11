@tool # Needed so it runs in the editor.
extends EditorScenePostImport

# Speicherpfad
var source_path: String
var save_path: String
var mesh_path: String = "res://low/mesh/"
var mat_path: String = "res://low/mat/"

# DirAccess
var dir: DirAccess = DirAccess.open("res://low/")

var subName: String = ""

func check_mesh(node: Node3D) -> void:
	print("check_mesh")
	if !node is Node3D:
		return
	
	# nur wenn MeshInstance mit Mesh
	if node is MeshInstance3D and node.mesh:
		var mesh: Mesh = node.mesh
		var instanceName = mesh.resource_name.substr(len(subName) +1)
		
		# alle Surfaces durchgehen
		for i in range(mesh.get_surface_count()):
			# Material bearbeiten
			var mat:Material = mesh.surface_get_material(i)
			var mat_name:String = mat.resource_name
			var mat_file:String = mat_path + mat_name + ".material"
			if FileAccess.file_exists(mat_file):
				mesh.surface_set_material(i, load(mat_file))
			else:
				mesh.surface_set_material(i, null)
	
		# Mesh als Resource speichern
		print("save")
		var err = ResourceSaver.save(mesh, save_path + instanceName + ".mesh")
	
	pass

# Alle Nodes prüfen
func check_node(node):
	print("check_node")
	if node != null:
		check_mesh(node)
		for child in node.get_children():
			check_node(child)


# wird nach dem Import ausgeführt
func _post_import(scene):
	print("_post_import")
	
	# Namen lesen
	subName = scene.name
	if !subName:
		return

	# ordner prüfen
	save_path = mesh_path + subName + "/"
	if !dir.dir_exists(save_path):
		dir.make_dir(save_path)
	
	# Szene prüfen
	check_node(scene)
	
	# Do your stuff here.
	return scene # remember to return the imported scene
