extends Node


var _entries : Array = []

var currentActiveUnit :
	get : _entries[0] if _entries.size() > 0 else null;


class InitiativeEntry:
	var node : Node
	var name : String
	var bonus : int
	var value : int
	
	func _init(p_node : Node, p_name : String, p_bonus : int):
		node = p_node
		name = p_name
		bonus = p_bonus
		
		var rng = RandomNumberGenerator.new()
		value = rng.randi_range(1,20) + bonus



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func roll_initiative():
	_entries.clear()
	for client in get_tree().get_nodes_in_group("initiative"):
		_entries.append(InitiativeEntry.new(client, client.getInitiativeInfo()["name"], client.getInitiativeInfo()["bonus"]))	
		
	_entries.sort_custom(func(obj1, obj2): return obj1.value > obj2.value)
	
	print("Initiative Rolled!")
	
	_debugPrint()
	
	for entry in _entries:
		entry.node.NotifyInitiativeRoll();
		

func next():
	if _entries.size() < 1 : 
		return
	
	for entry in _entries:
		entry.node.NotifyTurnChange()
	_entries.append(_entries.pop_front())
	
	_debugPrint()
	
	_entries[0].node.NotifyTurnStart()
	
	

func _debugPrint():
	
	print("------------")
	var first = true
	for entry in _entries:
		if first:
			print("%s : %s (+%s) <<<<" % [entry.name, entry.value-entry.bonus,entry.bonus])
			first = false
		else:
			print("%s : %s (+%s) " % [entry.name, entry.value-entry.bonus,entry.bonus])
