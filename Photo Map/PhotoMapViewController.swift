//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


var capturedPhoto: UIImage?

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
    
    

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                                  MKCoordinateSpanMake(0.1, 0.1))
            mapView.setRegion(sfRegion, animated: false)
        }
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    /**
       Delegate method from LocationsViewController. Upon clicking a table cell, the API sends it's coordinates (latitude and longitude)
       to this method, which then adds an annotation to the mapView.
     
       - Parameter controller: LocationsViewController where the delegate is listening from
       - Parameter latitude: Latitude of location picked
       - Parameter longitude: Longitude of location picked
     
     */
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "Picture!"
        mapView.addAnnotation(annotation)
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("FUNCTION IS BEING CALLED!")
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        print("ANNOTATION VIEW IS STILL WORKING")
        if (annotationView == nil) {
            print("ANNOTATION VIEW IS NOT NIL??")
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        print("IF STATEMENT WENT PAST")
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = #imageLiteral(resourceName: "camera")
        return annotationView
    }
    
    /**
        This method receives input from the camera button upon being clicked and then presents the camera/photo library
        - Parameter sender: The Camera Button that will be clicked on this view controller when the user wants to take a picture
     
     */
    @IBAction func didPressCameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
    }
    /**
       This method keeps the capturedPhoto taken from UIImagePicker and sets the PhotoMapViewController's capturedPhoto to be the
       edited image.
     */ 
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        // Do something with the images (based on your use case)
        capturedPhoto = editedImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let vc: LocationsViewController = segue.destination as! LocationsViewController
            vc.delegate = self
        }
    }
}
