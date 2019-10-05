extends Control

const WORKING_DIR = "jezza@bot:~$ ";

# Gets called every 0.X seconds.
var ticker = null;
# Basically everything that's happened before now.
# This stuff can't be changed, so we're keeping it in a seperate buffer.
var history = "";
# This is the stuff the user is actually typing.
var buffer = "";
# Just the current character for the blinking cursor.
# It changes every 0.X % Y seconds.
var cursor = "_"

# The value that the label's text needs to be set to.
# We do this in a roundabout way because we want to be able to control the cursor.
var text = "";
# How many ticks have happened since the start..
# Currently not reset. (@TODO: reset this fucker...)
var counter = 0;
# How many lines are skipped in the history, when we start getting near the max_lines value.
var skipped;

# The exported variable that determines how big the _visible_ buffer is.
# Smaller panels obviously have smaller buffers.
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
	elif command == "define":
		if input.size() >= 2 and input[1] == "Dirk":
			return "Definition: \"Dirk\" (noun):\nA German man commonly seen playing with his pussies.\n"
		else:
			return "Boop.\n";
	else:
		return str("Command not found: ", command, '\n')

func count_chars(input, c):
	var count = 0;
	var offset = 1;
	while offset != -1:
		offset = input.find(c, offset + 1);
		count += 1;
	return count - 1;