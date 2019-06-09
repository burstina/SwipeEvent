class_name SwipeModule
extends _SwipeEventCore

# NOTE:
# 1.	to run on non-touch screen devices, turn on:
#		-> Project Setting->Input->Pointing->"Emulate touch with mouse"
#
# 1.	if BoundNode is TRUE:
#		a.	put this node as a child of Control node to bind;
#		b.	on Control (parent) node, set FOCUS MODE to CLICK;
#		c.	if parent is not a Control node, you have to call thisnode.Activate() and thisnode.Deactivate() as it needs
#
# 2.	if BoundNode is FALSE, put this node as the scene most bottom node
#		in this case, no need to activate or deactivate