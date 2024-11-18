extends Node

class_name InitiativeTracker

var _entries : Array[InitiativeEntry] = []

static var instance : InitiativeTracker;

var current_active_unit : Unit

var is_combat_active : bool = false;

class InitiativeEntry:
	var name : String
	var bonus : int
	var value : int
	var client : InitiativeClient
	var enabled : bool
	
	func _init(p_client : InitiativeClient):
		client = p_client
		name = p_client.initiativeName;
		bonus = p_client.initiativeBonus;
		enabled = true;
		
		var rng = RandomNumberGenerator.new()
		value = rng.randi_range(1,20) + bonus

func _ready() -> void:
	instance = self;

#signal emitted to let the asynchronous start_combat function know when to go to the next turn.
signal _next_turn_signal;

func _process(_delta: float) -> void:
	_remove_disabled_entries();
		

#removes all entries with .enabled set to false; this is marked and then deleted in _process to avoid
#issues with `await` in the process_tracking() function
func _remove_disabled_entries():
	if (_entries.size() < 1):
		return;
	
	for i in range(_entries.size()-1, -1, -1):
		if !_entries[i].enabled:
			_entries.remove_at(i);
			if (i == 0):
				_next_turn_signal.emit(); #if the current active entry is being removed, go to the next turn.

#Tracks the entire combat process; does nothing if combat is already active.
func start_combat(clients: Array[InitiativeClient]):
	if is_combat_active:
		return;
		
	_roll_initiative(clients);
	is_combat_active = true;
	print("Initiative Tracker: Entered Combat")


	while (_entries.size() > 0 && is_combat_active):
		_debugPrint();
		
		_entries[0].client.on_turn_start.connect(set_active_unit)
		_entries[0].client.NotifyTurnStart();

		await _next_turn_signal;
		
		#only if combat is sitll ongoing, as it may have been changed since the await
		if (is_combat_active && _entries.size() > 0):
			for entry in _entries:
				entry.client.NotifyTurnChange()
			_entries.append(_entries.pop_front())
			
	is_combat_active = false;
	print("Initiative Tracker: Exited Combat")
	_entries.clear();


#queues a matching initiativeclient for deletion from the entries array
func stop_tracking(client : InitiativeClient):
	for i in range(_entries.size()-1, -1, -1):
		if _entries[i].client == client:
			_entries[i].enabled = false;

func next_turn():
	_next_turn_signal.emit();
	
func end_combat():
	is_combat_active = false;
	_next_turn_signal.emit();


func _roll_initiative(clients : Array[InitiativeClient]):
	_entries.clear()
	for client in clients:
		_entries.append(InitiativeEntry.new(client));
	_entries.sort_custom(func(obj1, obj2): return obj1.value > obj2.value)
	
	print("Initiative Rolled!")
	
	#_debugPrint()
	
	for entry in _entries:
		if (is_instance_valid(entry.client)):
			entry.client.NotifyInitiativeRoll();
		
	
func get_entries() -> Array[InitiativeEntry]:
	return _entries;
	
func get_current_turn() -> InitiativeClient:
	if (_entries.size() > 0):
		return _entries[0].client;
	return null;
func _debugPrint():
	
	print("------------")
	var first = true
	for entry in _entries:
		if first:
			print("%s : %s (+%s) <<<<" % [entry.name, entry.value-entry.bonus,entry.bonus])
			first = false
		else:
			print("%s : %s (+%s) " % [entry.name, entry.value-entry.bonus,entry.bonus])
			
func set_active_unit(unit):
	current_active_unit = unit

func get_active_unit():
	return current_active_unit
