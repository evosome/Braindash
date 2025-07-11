class_name ArenaCamera extends Camera2D

var _default_zoom_value: Vector2
var _zoom_in_tween: Tween


#region builtin

func _ready() -> void:
    _default_zoom_value = zoom

#endregion


#region public

## This method is asynchronous. Zoom camera in at the given point with the zoom value
func zoom_in(at_position: Vector2, zoom_value: float, speed: float = 0.5) -> void:

    if _zoom_in_tween:
        _zoom_in_tween.kill()

    var zoom_in_tween = create_tween()
    zoom_in_tween.parallel().tween_property(self, "zoom", Vector2.ONE * zoom_value, speed)
    zoom_in_tween.parallel().tween_property(self, "position", at_position, speed)
    _zoom_in_tween = zoom_in_tween

    await zoom_in_tween.finished


## This method is asynchronous. Zoom camera back at zero point and set default zoom
func zoom_off(speed: float = 0.5) -> void:
    
    if _zoom_in_tween:
        _zoom_in_tween.kill()

    var zoom_in_tween = create_tween()
    zoom_in_tween.parallel().tween_property(self, "zoom", _default_zoom_value, speed)
    zoom_in_tween.parallel().tween_property(self, "position", Vector2.ZERO, speed)
    _zoom_in_tween = zoom_in_tween

    await zoom_in_tween.finished

#endregion
