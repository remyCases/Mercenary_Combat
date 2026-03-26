extends Control

@export var id: int
@export var element_size := 48
@export var gap := 4
@export var optional_label: Label = null
 
var current_element: SelectableElement
var dropdown_container: HBoxContainer
var slot_button: Button
var slot_texture: TextureRect

static func setCenter(rect: TextureRect):
	rect.anchor_left = 0.5
	rect.anchor_right = 0.5
	rect.anchor_top = 0.5
	rect.anchor_bottom = 0.5
	var texture_size = rect.texture.get_size()
	rect.offset_left = -texture_size.x / 2
	rect.offset_right = texture_size.x / 2
	rect.offset_top = -texture_size.y / 2
	rect.offset_bottom = texture_size.y / 2

func _ready():
	current_element = get_parent().empty_unit
	
	slot_button = Button.new()
	slot_button.custom_minimum_size = Vector2(element_size, element_size)
	add_child(slot_button)
	slot_button.gui_input.connect(_on_slot_clicked)
	
	slot_texture = TextureRect.new()
	slot_button.add_child(slot_texture)

	dropdown_container = HBoxContainer.new()
	dropdown_container.add_theme_constant_override("separation", gap)
	dropdown_container.anchor_top = 1.0
	dropdown_container.offset_top = - element_size
	dropdown_container.z_index = 10
	add_child(dropdown_container)
	move_child(dropdown_container, 0)
	
	_set_element(current_element)

func _on_slot_clicked(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		dropdown_container.visible = !dropdown_container.visible 

func _update_dropdown():
	for child in dropdown_container.get_children():
		child.queue_free()

	var elements_to_show = get_parent().get_troops()
	elements_to_show.erase(current_element)
	
	for element in elements_to_show:
		var button = _create_element_button(element)
		button.pressed.connect(func(): _set_element(element))
		dropdown_container.add_child(button)
	
	dropdown_container.visible = false

func _create_element_button(element: SelectableElement) -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(element_size, element_size)
	button.name = element.name
	
	if element.texture:
		var button_texture = TextureRect.new()
		button_texture.texture = element.texture
		setCenter(button_texture)
		button.add_child(button_texture)
	else:
		button.text = element.name
	return button

func _set_element(element: SelectableElement):
	current_element = element

	if current_element.texture:
		slot_texture.texture = current_element.texture
		setCenter(slot_texture)
		slot_button.text = ""
	else:
		slot_texture.texture = null
		slot_button.text = current_element.name
	
	if optional_label:
		optional_label.text = current_element.name

	dropdown_container.visible = false
	_update_dropdown()
	
	get_parent().element_selected.emit(self, element)
