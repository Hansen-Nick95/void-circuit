class_name ModDef
extends Resource
## A draftable in-run mod. One .tres file per mod in data/mods/.

enum Rarity { COMMON, RARE, LEGENDARY }

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var rarity: Rarity = Rarity.COMMON
@export var tags: Array[StringName] = []
@export var stat_mods: Array[StatMod] = []
## EventBus-driven behaviours this mod needs, e.g. &"on_drift_end". Implemented in M3.5.
@export var hooks: Array[StringName] = []
