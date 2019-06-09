class_name InputEventSwipe,"SwipeEventCore.png"
extends InputEventAction 

var direction		: Vector2	;func get_direction():	return direction;	func set_direction(inp):	direction = inp
var speed			: Vector2	;func get_speed():		return speed;		func set_speed(inp):		speed = inp
var heading_left	: bool		;func left():			return heading_left
var heading_right	: bool		;func right():			return heading_right
var heading_up		: bool		;func up():				return heading_up
var heading_down	: bool  	;func down():			return heading_down
var TargetNode		: Node		;func get_target():		return TargetNode;	func set_target_node(inp):	TargetNode = inp
func init():
	direction 		= Vector2(0,0)
	speed			= Vector2(0,0)
	heading_left	= false
	heading_right	= false
	heading_up		= false
	heading_down	= false
	TargetNode		= null
	
	
func set_all_properties(ar:Array,SwipeTime=null,target=null):
	compute_direction(ar)
	set_heading()
	compute_speed(direction,SwipeTime)
	if target is Control:
		set_target_node(target)

func compute_direction(ar:Array):
	for i in ar:
		if i is InputEventScreenDrag:
			direction = direction + i.relative

func compute_speed(dir:Vector2,time:float):
	speed.x = dir.x*time
	speed.y = dir.y*time
	pass

			
func set_heading(vec:Vector2=direction):
	var vn=direction.normalized()
	var ratio:float=abs(vn.x/(vn.y+0.000001)) # no division by 0
	if vn.x < 0:		# left
		heading_left	=true
	else:				# right
		heading_right	=true
	if vn.y < 0:		# up
		heading_up		=true
	else:				# down
		heading_down	=true

	if ratio > 0.5:		# x > y
		heading_up		=false
		heading_down	=false
	else:				# x < y
		heading_left	=false
		heading_right	=false
		
