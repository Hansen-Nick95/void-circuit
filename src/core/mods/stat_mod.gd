class_name StatMod
extends Resource
## One stat change carried by a mod. Adds apply before multipliers (see Stats.compute).

enum Op { ADD, MULTIPLY }

@export var stat: StringName
@export var op: Op = Op.ADD
@export var value: float = 0.0
