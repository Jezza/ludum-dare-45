extends Control

const WORKING_DIR = "jezza@bot:~$ ";

var ticker = null;
var history = "";
var buffer = "";
var cursor = "_"

var text = "";
var counter = 0;
var skipped;

export var max_lines = 34;

func _ready():
	var label = $Panel/MarginContainer/Label;
	label.grab_focus();
	
	label.max_lines_visible = max_lines;
	skipped = -(max_lines - 1)
	
	text = WORKING_DIR
	
	ticker = Timer.new()
	add_child(ticker)
	
	ticker.connect("timeout", self, "_on_timer_tick");
	ticker.set_wait_time(0.01);
	ticker.set_one_shot(false);
	ticker.start();

func _on_timer_tick():
	counter += 1;
	
	if counter % 80 == 0:
		if cursor == " ":
			cursor = "_"
		else:
			cursor = " "
	
	var label = $Panel/MarginContainer/Label;
	label.text = text + cursor
	if skipped > 0:
		label.lines_skipped = skipped

func _on_Label_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			history += WORKING_DIR + buffer + '\n'
			skipped += 1;
			var output = on_command(buffer.split(" "));
			skipped += count_chars(output, "\n");
			history += output;
			buffer = "";
		elif event.pressed and event.scancode == KEY_BACKSPACE:
			buffer = buffer.substr(0, buffer.length() - 1);
		else:
			buffer += char(event.unicode);
		
		text = history + WORKING_DIR + buffer;

func on_command(input):
	var command = input[0];
	if command == "help":
		return "You're basically fucked...\n"
	elif command == "attach":
		return "Installing...\nDone...\n"
	else:
		return str("Command not found: ", command, '\n')

func count_chars(input, c):
	var count = 0;
	var offset = 1;
	while offset != -1:
		offset = input.find(c, offset + 1);
		count += 1;
	return count - 1;