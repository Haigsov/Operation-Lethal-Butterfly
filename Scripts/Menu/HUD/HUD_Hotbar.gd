extends Node

var traitBtn : TextureButton;
var itemsBtn : TextureButton;
var shootBtn: TextureButton;
var moveBtn : TextureButton;
var endTurnBtn : TextureButton;
var hotbarLabel : RichTextLabel;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	traitBtn = get_node("TraitsBtn");
	itemsBtn = get_node("ItemsBtn");
	moveBtn = get_node("MoveBtn");
	shootBtn = get_node("ShootBtn");
	endTurnBtn = get_node("EndTurnBtn");
	
	hotbarLabel = get_node("HUDLabel");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (traitBtn.is_hovered()):
		hotbarLabel.text = "[center]Traits";
	elif (itemsBtn.is_hovered()):
		hotbarLabel.text = "[center]Items";
	elif (moveBtn.is_hovered()):
		hotbarLabel.text = "[center]Move";
	elif (shootBtn.is_hovered()):
		hotbarLabel.text = "[center]Shoot";
	elif (endTurnBtn.is_hovered()):
		hotbarLabel.text = "[center]End Turn";
	else:
		hotbarLabel.text = "";
