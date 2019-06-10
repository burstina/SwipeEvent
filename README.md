# SwipeEvent
Swipe Event Module for Godot Engine

| Property         | Description|
|------------------|------------------|
| Swipe Time Max   | Time limit to detect if the gesture is a swipe or a drag |
| Tollerance       | Time tollerance between frames to adjust swipe detection |
| Bound to Parent  | If **TRUE**, detection will affect only parent node. That means: ```event.get_target() = parent_node``` **NOTE**:It has to ba any Control node to run smoothly. (if parent is not a Control node, you have to call ```Activate()``` and ```Deactivate()``` by yourself  |
| Cumulative Drag  | (Pretty experimental) If detection engine doesn't detect a swipe, only a single cumulative drag event has to be trasmitted|
| Drag while Swipe | Doesn't suppress Drag events while the engine are trying to detect swipes |
| Call deferred    | If **TRUE**, swipe engine submits events as deferred calls |



![img1](https://raw.githubusercontent.com/burstina/SwipeEvent/master/Pics/swipeEvent1.jpg)
![img1](https://raw.githubusercontent.com/burstina/SwipeEvent/master/Pics/swipeEvent2.jpg)
![img1](https://raw.githubusercontent.com/burstina/SwipeEvent/master/Pics/swipeEvent3.jpg)
