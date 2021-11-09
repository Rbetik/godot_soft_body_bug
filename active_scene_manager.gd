extends Node
# IN demo only one point is pinned, but if you pin another 3 or more, 
# it also demonstrates problem with more than 3 pinned

#for bug to be reproducable SOFT_BODY_PARENT must have some transform.origin


var alreadyLoaded = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _unhandled_input(event):
    if (event.is_action_pressed("change_scene")):
        self.changeScene()
        return

func changeScene():
    # if scene is not yet stored, save it for later
    if !self.alreadyLoaded.keys().has(self.get_tree().current_scene.name):
        self.alreadyLoaded[self.get_tree().current_scene.name] = self.get_tree().current_scene

    # toggle switching A goes to B, B goes to A
    var nextSceneName = 'Scene_A' if self.get_tree().current_scene.name == 'Scene_B' else 'Scene_B'

    #if i dont have scene loaded instance it, else use previously loaded scnene.
    # THIS IS IMPORTANT FOR BUG, IF YOU LOAD SCNENE FRESH IT WORKS CORRECTLY
    var nextScene
    if !self.alreadyLoaded.keys().has(nextSceneName):
        print('loading from fresh')
        nextScene = load('res://' + nextSceneName + '.tscn').instance()
    else:
        nextScene = alreadyLoaded[nextSceneName]
    var currentScene = self.get_tree().current_scene
    self.get_tree().get_root().call_deferred('add_child', nextScene)
    self.get_tree().call_deferred('set_current_scene', nextScene)
    self.get_tree().get_root().call_deferred('remove_child', currentScene)
