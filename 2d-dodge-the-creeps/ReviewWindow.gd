extends VBoxContainer

var file_path = "res://data/reviews.txt"

func _on_SubmitButton_pressed():
	write_file(file_path, get_node("CommentTextBox").text)
	update_reviews_text_box()
	

# Method that writes into file.
# Source: https://godotengine.org/qa/16555/how-to-create-a-file-in-godot
static func write_file(file_name, string):
	var file = File.new()
	file.open(file_name, File.READ_WRITE)
	file.seek_end(0)
	file.store_line(string)
	file.close()


# Method that reads file.
# https://godotengine.org/qa/16555/how-to-create-a-file-in-godot
static func read_file(file_name):
	var file = File.new()
	file.open(file_name, File.READ)
	var content = file.get_as_text()
	file.close()
	return content


func update_reviews_text_box():
	get_node("ReviewsTextBox").text = read_file(file_path)
	
