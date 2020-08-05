# motionTest

Looping video background rotating according to the angle of the device.

### Usage

Create `MagicVideoController` and add it to view
```
var url: URL!
var magicController: MagicVideoController!

let magicController = MagicVideoController(url: url)
magicController.addPlayer(to: self.view)

```

To start playing video and motion tracking call:

```
magicController.start()
```

To pause call:
```
magicController.pause()
```
