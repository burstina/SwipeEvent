class_name _SwipeEventCore, "SwipeEventCore.png"
extends Node

export var SwipeTimeMax		:float	= 0.25	#length of swipe in seconds
export var Tollerance		:float	= 0.1	#length of swipe in seconds
export var BoundToParent	:bool	=true	# works only for parent Control node
export var AllowDrag		:bool	=false  # allow dragging
export var CumulativeDrag	:bool	=true	# if TRUE, instead of a EventDrag queue, only a single cumulative DragEvent is emitted
export var DragWhileSwipe	:bool	=true	# if TRUE, parsed drag events won't be suppressed
export var CallDeferred		:bool	=false	# if TRUE, events are created deferred, if FALSE, events are created instantly

var TimeTolleranceAccum	= 0
var BoundNode			= null

var SwipeTime	:float	= 0
var ProcessTime	:float	= 0
var ProcessDelta:float	= 0
var TimeProcessing		= false
var CollectingEvents	= false
var isThrowedEvent 		= false

var WaitNextTouch 		= true

var CoreActive 			= true
var EventQueue	= []

func _ready():
	init_parse()
	CollectingEvents	= false
	if BoundToParent:
		CoreActive		= false
		BoundNode		= get_parent()
		if BoundNode is Control:
			BoundNode.connect("focus_entered",self,"Activate")
			BoundNode.connect("focus_exited",self,"Deactivate")

func _process(delta):
#	prints(ProcessTime,SwipeTime,delta,TimeProcessing)
	ProcessDelta = delta
	if  ProcessTime  > SwipeTimeMax:		# swipe too long
#		prints("Process Timeout")
		is_not_a_swipe()
	elif ProcessTime > SwipeTime:
		TimeTolleranceAccum = TimeTolleranceAccum + delta
		if TimeTolleranceAccum <= Tollerance:
			SwipeTime = ProcessTime 
#			prints("tollerated:",TimeTolleranceAccum)
		else:
#			prints("No Swipe time")
			is_not_a_swipe()
	elif ProcessTime == SwipeTime:			# continue swipe detection
		if !CollectingEvents:
			it_is_a_swipe()
	elif SwipeTime  > SwipeTimeMax:			# IMPOSSIBLE swipe too log
#		prints("SwipeTimeMax")
		is_not_a_swipe()
	else:									# swipe ended
#		prints("no swipe (else)")
		is_not_a_swipe()

	if is_processing():	
		ProcessTime	= ProcessTime + delta
		if 	TimeProcessing:
			SwipeTime	= SwipeTime + ProcessDelta
	TimeProcessing = false

#	prints(ProcessTime,SwipeTime,delta)

func ThrowEvent(ev:InputEvent = null):
	if CallDeferred:
		Input.call_deferred("parse_input_event",ev)
	else:
		Input.parse_input_event(ev)

func it_is_a_swipe():
#	prints("swipe!")
	var ev = InputEventSwipe.new()
	ev.set_all_properties(EventQueue,SwipeTime,BoundNode)
	ThrowEvent(ev)
	end_parse()
	
func is_not_a_swipe():
	if  (AllowDrag
	and !DragWhileSwipe):
		if CumulativeDrag:
			var ev=EventQueue[0]
			for i in range(1,EventQueue.size()-1):	
				ev.relative = ev.relative + EventQueue[i].relative
			ev.position=EventQueue[EventQueue.size()-1].position
			ThrowEvent(ThrowedHeader.new())
			ThrowEvent(ev)
			ThrowEvent(ThrowedFooter.new())
		
		else:
			ThrowEvent(ThrowedHeader.new())
			for i in EventQueue:			#throw stored events
				ThrowEvent(i)
			ThrowEvent(ThrowedFooter.new())
	end_parse()
	pass

func init_parse():
	set_process(false)		#stop processing unnecessarily
	ProcessTime		= 0
	ProcessDelta	= 0
	SwipeTime		= 0
	EventQueue.clear()
	WaitNextTouch = true
	TimeTolleranceAccum = 0
	
func end_parse():
	init_parse()

func BoundNodeFocusOn():
	call_deferred("Activate")
	
func BoundNodeFocusOff():
	call_deferred("Deactivate")

func Activate():
	CoreActive = true

func Deactivate():
	CoreActive = false
	init_parse()
	
func _input(event):
	if  !CoreActive:
		pass
	elif event is ThrowedHeader:
		isThrowedEvent = true
		get_tree().set_input_as_handled()
	elif event is ThrowedFooter:
		isThrowedEvent = false
		get_tree().set_input_as_handled()
	elif isThrowedEvent:
#		prints("bypass:")
		pass
	elif (event is InputEventScreenTouch
	 and !event.is_pressed()):
		processInputEventMouseButtonReleased()
	elif (event is InputEventScreenTouch
	 and  event.is_pressed()):
		if !CollectingEvents:
#			prints("event pressed:",event.is_pressed())
			processInputEventMouseButtonPressed()
	elif (WaitNextTouch
	 and !AllowDrag
	 and event is InputEventScreenDrag):
		prints("cant' alow drag")
		get_tree().set_input_as_handled()
	elif WaitNextTouch:
		pass
	elif event is InputEventScreenDrag:
		processInputEventScreenDrag(event)


func processInputEventMouseButtonPressed():
	WaitNextTouch	= false
	CollectingEvents = true
	TimeProcessing  = true
	get_tree().set_input_as_handled()
#	prints(get_name(),"mouse pressed")

func processInputEventMouseButtonReleased():
	WaitNextTouch	 = true	
	CollectingEvents = false
	get_tree().set_input_as_handled()
#	prints(get_name(),"mouse released")

func processInputEventScreenDrag(event):
	if !is_processing():
		set_process(true)
	TimeProcessing = true
	EventQueue.append(event)
	if !DragWhileSwipe:
		get_tree().set_input_as_handled()
#	prints("drag:",event)
