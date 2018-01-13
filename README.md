# SKImageReader
It can fetches all assets from Photos framework and displays in a UICollectionView.

# Components Used

- Xcode 9
- Obective C
- Photos framework
- Grand Central Dispatcher
- UICollectionView

# Implementation Details

My main goal was to create an application which can fetch all images from Images Library and write them into Documents Directory in a best possible way.

I created two 'Serial Queues' which executes tasks in a serial way. The first one is fetching images from Photos library and the second one writing them into 'Documents directory'. I used Async dispatcher to avoid blocking of threads. Currently I have set a limit of upto 200 images but it can be further icreased.

# Refernces

https://developer.apple.com/documentation/photos/phasset
https://developer.apple.com/documentation/photos/phimagemanager
https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
https://stackoverflow.com/questions/19822700/difference-between-dispatch-async-and-dispatch-sync-on-serial-queue
http://bcdilumonline.blogspot.com/2015/03/add-uicollectionview-to-xib-with-custom.html



