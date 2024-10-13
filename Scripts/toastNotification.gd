extends CenterContainer


#for whatever reason, giving the object a non-zero rotation makes moving the position infinitely smoother.


@export var timeUntilFade : float = 0.5;
@export var fadeDuration : float = 0.5;
@export var color : Color;
@export var text : String;
@export var motionSpeed = 3;
@export var movement_direction : Vector2 = Vector2(0,-1);


@onready var label : RichTextLabel = $RichTextLabel

var _fadeProgress : float;

func _ready():
	
	_fadeProgress = fadeDuration;
	label.text = text;
	label.add_theme_color_override("default_color", color);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (timeUntilFade > 0):
		timeUntilFade -= delta;
	else:
		_fadeProgress -= delta;
		modulate.a = clampf(_fadeProgress/fadeDuration, 0, 1);
		
	if (_fadeProgress <= 0):
		queue_free();
	position = position + movement_direction * motionSpeed * delta;



