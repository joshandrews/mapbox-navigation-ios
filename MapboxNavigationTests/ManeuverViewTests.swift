import XCTest
import FBSnapshotTestCase
import MapboxDirections
@testable import MapboxNavigation
@testable import MapboxCoreNavigation


class ManeuverViewTests: FBSnapshotTestCase {
    
    let maneuverView = ManeuverView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
    
    override func setUp() {
        super.setUp()
        maneuverView.backgroundColor = .white
        recordMode = false
        isDeviceAgnostic = false
        usesDrawViewHierarchyInRect = true
        
        let window = UIWindow(frame: maneuverView.bounds)
        window.addSubview(maneuverView)
    }
    
    func maneuverInstruction(_ maneuverType: ManeuverType, _ maneuverDirection: ManeuverDirection, _ drivingSide: DrivingSide, _ degrees: CLLocationDegrees = 180) -> VisualInstructionBanner {
        let component = VisualInstructionComponent(type: .delimiter, text: "", imageURL: nil, abbreviation: nil, abbreviationPriority: 0)
        let primary = VisualInstruction(text: "", maneuverType: maneuverType, maneuverDirection: maneuverDirection, components: [component], degrees: degrees)
        return VisualInstructionBanner(distanceAlongStep: 0, primaryInstruction: primary, secondaryInstruction: nil, tertiaryInstruction: nil, drivingSide: drivingSide)
    }
    
    func testStraightRoundabout() {
        maneuverView.visualInstruction = maneuverInstruction(.takeRoundabout, .straightAhead, .right)
        FBSnapshotVerifyLayer(maneuverView.layer)
    }
    
    func testTurnRight() {
        maneuverView.visualInstruction = maneuverInstruction(.turn, .right, .right)
        FBSnapshotVerifyLayer(maneuverView.layer)
    }
    
    func testTurnSlightRight() {
        maneuverView.visualInstruction = maneuverInstruction(.turn, .slightRight, .right)
        FBSnapshotVerifyLayer(maneuverView.layer)
    }
    
    func testMergeRight() {
        maneuverView.visualInstruction = maneuverInstruction(.merge, .right, .right)
        FBSnapshotVerifyLayer(maneuverView.layer)
    }
    
    func testRoundabout() {
        let incrementer: CGFloat = 45
        let size = CGSize(width: maneuverView.bounds.width * (360 / incrementer), height: maneuverView.bounds.height)
        let views = UIView(frame: CGRect(origin: .zero, size: size))
        
        for bearing in stride(from: CGFloat(0), to: CGFloat(360), by: incrementer) {
            let position = CGPoint(x: maneuverView.bounds.width * (bearing / incrementer), y: 0)
            let view = ManeuverView(frame: CGRect(origin: position, size: maneuverView.bounds.size))
            view.backgroundColor = .white
            view.visualInstruction = maneuverInstruction(.takeRoundabout, .right, .right, CLLocationDegrees(bearing))
            views.addSubview(view)
        }
        
        FBSnapshotVerifyLayer(views.layer, suffixes: ["_64"])
    }
    
    // TODO: Figure out why the flip transformation do not render in a snapshot so we can test left turns and left side rule of the road.
}
