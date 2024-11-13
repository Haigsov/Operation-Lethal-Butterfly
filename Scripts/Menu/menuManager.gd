extends Node


class_name MenuManager;

var _menu_stack = Array[MenuBase];


func display(m : MenuBase):
	_menu_stack.push_back(m);
	m.display();
	m.on_close.connect(_current_menu_closed);

func _current_menu_closed(back : int):
	if _menu_stack.size() - back < 0:
		pass
	
