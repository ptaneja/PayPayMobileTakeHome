PayPayMobileTakeHome
====================
This app is developed to demonstrate the Photo viewing functionality and photos from web server. This retrieves the picture from the device gallery and shows it under Photos sections and photos from web under Cloud section
and shows it in Collection View. On tap of any grid it opens it in the Poster view.

This can be achieved by including the classes under the SDK folder.

Description of classes

Protocols
PPMTHCollectionViewDataSource
PPMTHCollectionViewDelegate

Above protocols for controlling the collection view. To tell the number of images and number of sections to be displayed.

PPMTHCollectionView: View class
This class holds the object of Collection view. There are two method exposed, one is written to give the customization 
to the developer.

Model
PPMTHCollectionData: To maintain the data of grid view.
PPMTHImageData: To maintain the data of images.

Controller class
PPMTHPosterImageViewController: This controller presents the poster image.

Open issue:
When user scrolls below images are visible.

