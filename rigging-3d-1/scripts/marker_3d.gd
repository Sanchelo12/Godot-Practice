@tool
extends Marker3D

@export var skeleton: Skeleton3D
@export var bone_name: String = ""


# Method 1: Setter Referenciado
# Requiere que la función '_do_snap' esté definida en el script antes.
# Es más propenso a errores en el Editor si no se reinicia la escena, ya que el Inspector debe "vincular" el nombre de la variable con el nombre de la función. Para que funcione debes asegurarte de que la función (_do_snap) que se le asignará con "set" exista ANTES de definir la variable, o simplemente cerrar y abrir la escena después de guardar el script.
func _do_snap(value):
	print("Logg")
	if value == true:
		snap_to_rest_pose()
	snap_now = false # Se desactiva solo tras el clic

@export var snap_now1: bool = false : set = _do_snap

# Method 2: Setter Integrado (Inline)
# Es más robusto y directo porque la lógica se define dentro del mismo @export.
# El Editor de Godot detecta la lógica instantáneamente como una propiedad única, por lo que no depende de buscar funciones externas ni del orden del código.

@export var snap_now: bool = false : 
	set(value):
		# Esta función se ejecuta CADA VEZ que tocas el checkbox en el inspector
		if value == true:
			snap_to_bone()
		# Forzamos a que siempre vuelva a estar en 'false' para que puedas clickear de nuevo
		snap_now = false

func snap_to_bone():
	if not skeleton:
		print("Error: ¡Asigna un Skeleton3D primero!")
		return
	
	var bone_idx = skeleton.find_bone(bone_name)
	if bone_idx == -1:
		print("Error: No encontré el hueso '", bone_name, "'")
		return

	# Obtenemos la posición global del hueso
	# Combinamos la transformación global del esqueleto con la pose global del hueso
	global_transform = skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx)
	print("Snap completado a: ", bone_name)

func snap_to_rest_pose():
	if not skeleton: return
	
	var bone_idx = skeleton.find_bone(bone_name)
	if bone_idx == -1: return

	# 1. Obtenemos la Transform de descanso RELATIVA al Skeleton
	# get_bone_global_rest calcula la posición sumando todos los 'rest' de la cadena
	var rest_pose_local = skeleton.get_bone_global_rest(bone_idx)
	
	# 2. La convertimos a posición GLOBAL del mundo
	# Multiplicamos la Transform del Skeleton por la pose de descanso
	global_transform = skeleton.global_transform * rest_pose_local
	
	print("Snap realizado a la POSICIÓN DE DESCANSO de: ", bone_name)
