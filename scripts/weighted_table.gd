class_name WeightedTable
extends RefCounted

class ItemDictionary:
	var item:Variant
	var weight:int
	
	func _init(_item:Variant, _weight:int) -> void:
		item = _item
		weight = _weight

var items:Array[ItemDictionary] = []
var weight_sum:int = 0

func add_item(item:Variant, weight:int) -> void:
	items.append(ItemDictionary.new(item, weight))
	weight_sum += weight

func remove_item(item_to_remove:Variant) -> void:
	items = items.filter(func (item_dic:ItemDictionary) -> bool: return item_dic.item != item_to_remove)
	weight_sum = 0
	for item_dic:ItemDictionary in items:
		weight_sum += item_dic.weight

func pick_item_at_random_weight(exclude: Array = []) -> Variant:
	var adjusted_items:Array[ItemDictionary] = items
	var adjusted_weight_sum := weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item_dic:ItemDictionary in items:
			if item_dic.item in exclude:
				continue
			
			adjusted_items.append(item_dic)
			adjusted_weight_sum += item_dic.weight
	
	var chosen_weight := randi_range(1, adjusted_weight_sum)
	var iteration_sum:int = 0
	for item_dic:ItemDictionary in adjusted_items:
		iteration_sum += item_dic.weight
		if chosen_weight <= iteration_sum:
			return item_dic.item
	
	return null
