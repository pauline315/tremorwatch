import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var maps: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let imageView = UIImageView()
    var searchResults: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "launch")
        imageView.alpha = 0
        view.addSubview(imageView)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Example: Trigger fadeOutImage after 2 seconds of viewDidLoad
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0) {
            self.fadeOutImage()
        }
    }
    
    @IBAction func fadeOutImage() {
        UIView.animate(withDuration: 1.0, animations: {
            self.imageView.alpha = 0
        }) { (finished) in
            self.imageView.removeFromSuperview()
            self.performSegue(withIdentifier: "segueToNextScreen", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNextScreen" {
            // Optionally, you can pass data to the destination view controller here
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearch(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update searchResults based on searchText
        // This could involve filtering a larger dataset or performing a new search
    }
    
    func performSearch(_ searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: maps.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            
            self.searchResults = response.mapItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = searchResults[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchResults[indexPath.row]
        let coordinate = selectedItem.placemark.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = selectedItem.name
        maps.addAnnotation(annotation)
        maps.setCenter(coordinate, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

