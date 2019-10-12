//
//  BluetoothViewController.swift
//  BareFoot
//
//  Created by Sanya Khurana on 09/10/19.
//  Copyright © 2019 Sanya Khurana. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import CoreData

class BluetoothViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {

    
    
    private let ActivityServiceType: String = "bf-service"

    private let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
//
//    private var serviceAdvertiser : MCNearbyServiceAdvertiser
//    private var serviceBrowser : MCNearbyServiceBrowser
   
    lazy var mcSession : MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    var activities: [Activity] = [Activity]()
    var attendanceTable: [AttendanceTable] = [AttendanceTable]()
    var lessonPlan: [LessonPlan] = [LessonPlan]()
    
    @IBAction func sendLessonPlan(_ sender: Any) {
        
        print("Data has been recieved")
    
        
    }
    
    @IBAction func sendAttendance(_ sender: Any) {
        
        print("Data has been recieved")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AttendanceTable")
            do{
                let result = try managedObjectContext.fetch(fetchRequest)
                let activitiesLocal = result as! [AttendanceTable]
                for activity in activitiesLocal{
                    attendanceTable.append(activity)
                }
        } catch {
            
            print("Could Not Get Activity Context")
            
        }
        
//        sendAttendance(attendanceTable)
    }
    @IBAction func sendActivities(_ sender: Any) {
        
        print("Data has been recieved")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LessonPlan")
            do{
                let result = try managedObjectContext.fetch(fetchRequest)
                let activitiesLocal = result as! [LessonPlan]
                for activity in activitiesLocal{
                    lessonPlan.append(activity)
                }
        } catch {
            
            print("Could Not Get Activity Context")
            
        }
        
        sendActivities(data: activities)
    }
    override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view, typically from a nib.
          //peerID = MCPeerID(displayName: UIDevice.current.name)
        //mcSession: = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
          //mcSession.delegate = self
          
        let serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: ActivityServiceType)
        let serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: ActivityServiceType)


          serviceAdvertiser.delegate = self
          serviceAdvertiser.startAdvertisingPeer()

          serviceBrowser.delegate = self
          serviceBrowser.startBrowsingForPeers()
      }
      
      override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
           case MCSessionState.connected:
               print("Connected: \(peerID.displayName)")

           case MCSessionState.connecting:
               print("Connecting: \(peerID.displayName)")

           case MCSessionState.notConnected:
               print("Not Connected: \(peerID.displayName)")
           }
    }
    

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Data has been recieved")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func sendActivities(data: [Activity]) {
        if mcSession.connectedPeers.count > 0 {
                do {
                    let activityData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                    try mcSession.send(activityData, toPeers: mcSession.connectedPeers, with: .reliable)
                    let ac = UIAlertController(title: "Sending Data", message: "Sending Data to " + (mcSession.connectedPeers.first?.displayName ?? "the connected device"), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            
        }
    }
    
    func sendLessonPlan(data: [LessonPlan]) {
           if mcSession.connectedPeers.count > 0 {
                   do {
                       let activityData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                       try mcSession.send(activityData, toPeers: mcSession.connectedPeers, with: .reliable)
                       let ac = UIAlertController(title: "Sending Data", message: "Sending Data to " + (mcSession.connectedPeers.first?.displayName ?? "the connected device"), preferredStyle: .alert)
                       ac.addAction(UIAlertAction(title: "OK", style: .default))
                       present(ac, animated: true)
                   } catch let error as NSError {
                       let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                       ac.addAction(UIAlertAction(title: "OK", style: .default))
                       present(ac, animated: true)
                   }
               
           }
       }
    
    func sendAttendanceData(data: [AttendanceTable], studentPresence: [StudentPresence]) {
              if mcSession.connectedPeers.count > 0 {
                  
                      do {
                          let activityData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                          try mcSession.send(activityData, toPeers: mcSession.connectedPeers, with: .reliable)
                        let ac = UIAlertController(title: "Sending Data", message: "Sending Data to " + (mcSession.connectedPeers.first?.displayName ?? "the connected device"), preferredStyle: .alert)
                          ac.addAction(UIAlertAction(title: "OK", style: .default))
                          present(ac, animated: true)
                      } catch let error as NSError {
                          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                          ac.addAction(UIAlertAction(title: "OK", style: .default))
                          present(ac, animated: true)
                      }
                
                do {
                    let studentPresenceData = try NSKeyedArchiver.archivedData(withRootObject: studentPresence, requiringSecureCoding: false)
                    try mcSession.send(studentPresenceData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
                  
              }
          }
       

  
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.mcSession)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.mcSession, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
}

