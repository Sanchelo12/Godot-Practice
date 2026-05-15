extends CSGBox3D

@onready var skeleton: Skeleton3D = $Armature/Skeleton3D
@onready var stick: Node3D = $Stick

@export var largo_maximo_brazo: float = 1.3

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var centro_pecho: Vector3 = global_position + Vector3(0, 1.2, 0) 
	
	# 3. Calculamos el vector desde el pecho hasta donde el stick INTENTA ir
	var vector_hacia_stick: Vector3 = stick.global_position - centro_pecho
	
	# 4. Si el stick intenta ir más lejos de lo que miden los brazos...
	if vector_hacia_stick.length() > largo_maximo_brazo:
		# Forzamos al stick a quedarse en el límite del círculo/esfera de alcance
		var posicion_limite = vector_hacia_stick.normalized() * largo_maximo_brazo
		stick.global_position = centro_pecho + posicion_limite
