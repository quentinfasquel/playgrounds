//: # 1. Transparent Videos in SpriteKit
//: #### → [Transparent Videos in SceneKit](@next)

import AVFoundation
import SpriteKit
import PlaygroundSupport
import UIKit

class MyExampleScene: SKScene {
  
  var player: AVPlayer!
  var playerLooper: AVPlayerLooper!
  
  override func didMove(to view: SKView) {
    
    guard let url = Bundle.main.url(forResource: "playdoh-bat", withExtension: "mp4") else {
      print("Can't find example video")
      return
    }
    
    // Creating our player
    let playerItem = AVPlayerItem(url: url)
    player = AVQueuePlayer(playerItem: playerItem)
    playerLooper = AVPlayerLooper(player: player as! AVQueuePlayer, templateItem: playerItem)
    
    // Getting the size of our video
    let videoTrack = playerItem.asset.tracks(withMediaType: .video).first!
    let videoSize = videoTrack.naturalSize

    // An orange background color to show transparency
    backgroundColor = .orange
    
    // Adding a `SKVideoNode` to display video in our scene
    let videoNode = SKVideoNode(avPlayer: player)
    videoNode.position = CGPoint(x: frame.midX, y: frame.midY)
    // TODO: Comment
    videoNode.size = videoSize.applying(CGAffineTransform(scaleX: 1.0, y: 0.5))
    
    // Let's make it transparent, using an SKEffectNode,
    // since a shader cannot be applied to a SKVideoNode directly
    let effectNode = SKEffectNode()
    // Loving Swift's multiline syntax here:
    effectNode.shader = SKShader(source: """
void main() {
  vec2 texCoords = v_tex_coord;
  vec2 colorCoords = vec2(texCoords.x, (1.0 + texCoords.y) * 0.5);
  vec2 alphaCoords = vec2(texCoords.x, texCoords.y * 0.5);
  vec4 color = texture2D(u_texture, colorCoords);
  float alpha = texture2D(u_texture, alphaCoords).r;
  gl_FragColor = vec4(color.rgb, alpha);
}
""")
    addChild(effectNode)
    effectNode.addChild(videoNode)
    
    // Start playing your video
    player.play()
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
}


// Load the SKScene
let sceneBounds = CGRect(x: 0 , y: 0, width: 640, height: 480)
let sceneView = SKView(frame: sceneBounds)
sceneView.backgroundColor = .black

let scene = MyExampleScene()
scene.backgroundColor = .black
// Set the scale mode to scale to fit the window
scene.anchorPoint = .zero
scene.scaleMode = .aspectFill
scene.size = sceneView.bounds.size

// Note: do not use a SKTransition to present your scene
//sceneView.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))

//#-hidden-code
PlaygroundPage.current.liveView = sceneView
sceneView.presentScene(scene)
//#-end-hidden-code
//: ### Next: **[Transparent Videos in SceneKit](@next)**
