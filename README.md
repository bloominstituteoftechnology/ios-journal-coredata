# Journal (Core Data) Day 2

## Introduction

This version of Journal will allow you to implement each part of CRUD when working with Core Data.

## Instructions

Please fork and clone this repository. This repository does not have a starter project, so create one inside of the cloned repository folder.

Create a single view application called `Journal` in Xcode and do not check the Core Data box in the setup. We'll create our own Core Data stack.

### Part 1 - File Creation and UI

#### File Tasks

1. Rename the view controller included with the single view template to `CreateEntryViewController`.
2. Create an `EntriesTableViewController` subclass of `UITableViewController`.
3. Create a `UITableViewCell` subclass called `EntryTableViewCell`.
4. Create a `CoreDataStack` Swift file.
5. Create an `Entry+Convenience` Swift file.
6. Create a new Core Data model file called `Journal`.

#### Storyboard Tasks

1. Add a `UITableViewController` scene
2. Embed each of the above scenes in their own navigation controllers
3. Assign the nav controller attached to the table view scene as the initial view
4. Create a bar button item in the upper right of the table view scene's nav bar.
5. Connect that button to the nav controller for the create scene and use the _present modally_ kind. Change the presentation on the segue to _full screen_.
6. See the below mockup images for design specs on the create entry view as as well as the table view. Try your best to recreate the design using Auto Layout, stack views, etc. (see today's guided project storyboard for help)
=======
# Journal (Core Data) Day 3

## Introduction

Today's project will continue to add more functionality to the Journal project. You will add syncing between Core Data and a server. In this case, Firebase will be used as the server. Since we have already set up an `NSFetchedResultsController` to update the table view when the persistent store's managed objects change, you will only need to do work on the model and model controller layers. This is a good example of adding functionality without having to tear up your entire application.

## Instructions

Use the Journal project you made yesterday. Create a new branch called `day3`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day3` branch as the base branch, and your own `day3` branch as the compare branch.

### Part 1 - PUTting and deleting Entries

First, you'll set up the ability to PUT entries to Firebase. Since the `Entry` entity already has an `identifier` attribute, there is no need to make a new model version.

Feel free to take the core data stack you used in the guided project and paste it in this file. You may need to change the name of the persistent container to match the name of your data model file.
=======
1. Create a new Firebase project for this application. Choose to use the "Realtime Database" and set it to testing mode so no authentication is required.

#### EntryRepresentation

Something to keep in mind when trying to sync multiple databases like we are in this case is that you need to make sure you don't duplicate data. For example, say you have an entry saved in your persistent store on the device, and on Firebase. If you were to go about fetching the entries from Firebase and decoding them into `Entry` objects like you've done previously before today, you would end up with a duplicate of the entry in your persistent store. This would occur every single time that you fetch the entry from Firebase. 

1. Create a new entity and call it `Entry`. Keep the codegen as _Class Definition_.
2. Add the following attributes to the `Entry` entity:
    - A `title` string.
    - A `bodyText` string.
    - A `timestamp` `Date`.
    - An `identifier` string.

In the file `Entry+Convenience.swift`: 
1. Import `CoreData` in this file.
2. Add an extension on `Entry`.
3. Create a convenience initializer that takes in values for each of the `Entry` entity's attributes, and an instance of `NSManagedObjectContext`. Consider giving default values to the timestamp and identifier parameters in this initializer. This initializer should:
    - Call the `Entry` class' initializer that takes in an `NSManagedObjectContext`
    - Set the value of attributes you defined in the data model using the parameters of the initializer.
    - Add the `@discardableResult` annotation to the beginning of the initializer's method signature so callers don't need to use the object returned.

### Part 3 - View and View Controller Implementation

In the `EntryTableViewCell` class:

1. Add an `entry: Entry?` variable.
2. Create an `updateViews()` function that takes the values from the `entry` variable and places them in the outlets.
3. Add a `didSet` property observer to the `entry` variable. Call `updateViews()` in it.

In the `CreateEntryViewController`:

1. Add outlets for the textfield and the textview. Wire those up to their appropriate views in the storyboard.
2. Add IBActions for the cancel and save buttons. Wire those up to their appropriate buttons in the storyboard.
3. For cancel, simply dismiss this view's navigation controller.
4. For save, collect the data from the user, validate that it isn't empty, create a new `Entry` managed object, and finally issue a save on Core Data, with the appropriate error handling.

In the `EntryTableViewController`:

1. Create an `entries` computed property that fetches all entry entities from Core Data and returns them in an array.
2. Implement the `numberOfRows` method using the entries array property.
3. Implement the `cellForRowAt` method. Remember to cast the call as `EntryTableViewCell`, then pass an `Entry` to the cell's `entry` property in order for it to call the `updateViews()` method to fill in the information for the cell's labels.
4. Add the `viewWillAppear` method. It should reload the table view.
5. Implement the `commit editingStyle` `UITableViewDataSource` method to allow the user to swipe to delete entries. Be sure to delete the entry record from Core Data and remove the appropriate cell from the screen.

### UI Mockups

![Create entry view](https://raw.githubusercontent.com/LambdaSchool/ios-journal-coredata/master/CreateEntry-Blank.png)
![Entries table view](https://raw.githubusercontent.com/LambdaSchool/ios-journal-coredata/master/Tableview-with-Entry.png)
=======
Today you will take the Journal project you made yesterday and add more functionality to it. This will help you practice migrating data in Core Data and `NSFetchedResultsController`.

## Instructions

Use the Journal project you made yesterday. Create a new branch called `day2`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day2` branch as the base branch, and your own `day2` branch as the compare branch.

### Part 1 - Mood Feature

#### Segmented Control Addition

1. Add a `UISegmentedControl` to the `CreateEntryViewController` scene. 
2. Make 3 segments.
3. Set each segment's title to a mood. It's recommended to set them to happy, sad, and neutral emoji for the three moods, but you can choose anything you want.
4. Make an outlet from the segmented control to the view controller's class file.

#### Data Model Updates and Migration

Now, you will update your Core Data model to include a property to hold the mood that the user selects on the segmented control.

1. Select your Core Data data model file. In the menu, select Editor -> Add Model Version (keep it the same name and click the "Finish" button).
2. In the new data model file, add a new attribute called `mood`. Set its type to be `String`. 
3. Give the `mood` a default value. The default value is 😐, the neutral emoji. Again, you can choose whichever 3 moods you want. Just make sure to set the default value of this attribute to one of them.  This will allow the `Entry` objects that have been created before `mood` was added to have an initial value. 
4. In the File Inspector with the data model file selected, set the current model version to the new model version you just created. (It should be something like `Journal 2`)
5. Now navigate to your "Entry+Convenience.swift" file where you have the `Entry` extension and convenience initializer.
6. Add a `Mood` enum that has a `String` raw value. Set your cases to whatever three moods you chose. Make the enum conform to the `CaseIterable` protocol.
7. Update the initializer to include and property initialize the new `mood` property. Have the initializer take a `Mood` enum value, and then use the `rawValue` to actually set the property in the managed object.
8. In `CreateEntryViewController` update the code to collect the mood from the segmented control and then pass the appropriate `Mood` enum value into the `Entry` initializer.
    - **NOTE:** You'll need to translate the selected segment index into a `Mood` enum value. Use the `allCases` property of the enum to help you out, and look at the guided project for this module to see how you did it there.

At this point, take the time to test your project. Make sure that:
- Entries that you have saved before adding the `mood` property have a default `mood` value added to them.
- Moods get saved correctly to new entries.

#### Part 2 - NSFetchedResultsController Implementation

You will now implement an `NSFetchedResultsController` to manage displaying entries on and handling interactions with the table view.

##### EntriesTableViewController

1. In the `EntriesTableViewController`, create a lazy stored property called `fetchedResultsController`. Its type should be `NSFetchedResultsController<Entry>`. It should be initialized using a closure. Inside the closure:
    - Create a fetch request from the `Entry` object.
    - Create a sort descriptor that will sort the entries based on their `mood`. This can be either ascending or descending depending on your preference.
    - Create a sort descriptor that will sort the entries based on their `timestamp`. This can also be either ascending or descending depending on your preference.
    - Give the sort descriptor to the fetch request's `sortDescriptors` property. Note that this property's type is an array of sort descriptors, not a single one.
    - Create a constant that references your core data stack's `mainContext`.
    - Create a constant and initialize an `NSFetchedResultsController` using the fetch request and managed object context. For the `sectionNameKeyPath`, put "mood" (exactly how you spelled it in the data model file), and `nil` for `cacheName`.
    - Set this view controller class as the delegate of the fetched results controller. **NOTE:** Xcode will give you an error, but you will fix it in just a second.
    - Perform the fetch request using the fetched results controller
    - Return the fetched results controller.
2. Adopt the `NSFetchedResultsControllerDelegate` protocol in an extension to this view controller.
3. Add the following delegate methods to the table view controller: (feel free to paste this code in if you made a snippet out of it)
    - `controllerWillChangeContent`.
    - `controllerDidChangeContent`.
    - `didChange sectionInfo` ... `atSectionIndex`.
    - `didChange anObject` ... `at indexPath`.

Now you will change the `UITableViewDataSource` methods to look to the fetched results controller for information about how to set up the table view instead of the (no longer existing) `entries` array in the `EntryController`.

4. Add the `numberOfSections(in tableView: ...)` method if you don't have it already. This should use the number of sections in the fetched results controller's `sections` array.
5. In the `numberOfRowsInSection`, Again, use the `section` parameter to get the section currently being set up to return the `numberOfObjects`.
6. In the `cellForRowAt`, use the fetched results controller's `object(at: IndexPath)` method to get the correct entry corresponding to the cell instead of using the `entries` array.
7. In the `commit editingStyle`, use the `object(at: IndexPath)` method again to get the correct entry to be deleted instead of using the `entries` array.
8. Use the same `object(at: IndexPath)` method in the `prepare(for segue: ...)` method to get the correct entry instead of using the `entries` array.

#### Part 3 - Detail View

1. Create an `EntryDetailViewController` file that subclasses `UIViewController`
2. Add a view controller scene to your storyboard and link it with a segue between the cell and the view (use _show_ for the kind). This should extend the navigation bar to the new scene.
3. Assign the `EntryDetailViewController` class to the new scene in the identity inspector.
4. Set the title to `Entry Details`.
5. Copy and paste the stackview of views from the create scene to this one (you might consider breaking the connections to the outlets and actions before you copy/paste. Sometimes Xcode can get confused about the connections on copied views. Just be sure to reconnect them afterwards).
6. Constrain the stackview in the detail view scene with the following:
    - leading, top, and trailing of 20 pts (with margins)
    - equal height to the superview (will end up with a proportional height constraint; ensure the multiplier is 0.4)
7. Create outlets in the detail view controller for: the textfield, the text view, and the segmented control
8. Create an optional property to store an `Entry` object, and a variable Bool called `wasEdited` defaulted to `false`
9. In `viewDidLoad`, set the `editButtonItem` to the `rightBarButtonItem` in the `navigationItem` property.
    - Also call `updateViews` (which you'll create next)
10. Create and fill in the `updateViews` method. Set the views onscreen to the data from the `entry` model object. Also set the textfield, text view, and segmented control's `isUserInteractionEnabled` properties to `isEditing`.
11. Override the `setEditing(_:animated:)` method.
    - Call the superclass implementation
    - Check the `editing` property, if it's true set the `wasEdited` property to true
    - Set the 3 outlets' `isUserInteractionEnabled` properties to the `editing` variable
    - Set the `navigationItem`'s `hidesBackButton` property also to `editing` (this will hide the back button whenever editing is enabled)
12. Override the `viewWillDisappear(_:)` method
    - Call the superclass implementation
    - Check if `wasEdited` is true. If so, collect entry data from the user interface controls and update the `entry` managed object
    - Call save on the main context from your `CoreDataStack` singleton
=======
The way to prevent this is to create an intermediate data type between the JSON and the `Entry` class that will serve as a temporary representation of an `Entry` without being added to a managed object context.

1. Create a new Swift file called "EntryRepresentation". In the file, create a struct called `EntryRepresentation`.
2. Adopt the `Codable` protocol.
3. Add a property in this struct for each attribute in the `Entry` model. Their names should match exactly or else the JSON from Firebase will not decode into this struct properly.
4. In the "Entry+Convenience.swift" file, add a new convenience initializer. This initializer should be failable. It should take in an `EntryRepresentation` parameter and an `NSManagedObjectContext`. This should simply pass the values from the entry representation to the convenience initializer you made earlier in the project. 
5. In the `Entry` extension, create a `var entryRepresentation: EntryRepresentation` computed property. It should simply return an `EntryRepresentation` object that is initialized from the values of the `Entry`.

#### EntryController

1. Create an `EntryController` class for communicating with Firebase and Core Data.
2. In the `EntryController`, add a `baseURL: URL` constant that is the URL from the new Firebase database you created for this app.
3. Create a function called `sendEntryToServer` that takes in an entry and has an escaping completion closure. Give this completion closure a default value of an empty closure. (e.g. `{ _ in }` ). This will allow you to use the completion closure if you want to do something when `completion` is called or just not worry about doing anything after knowing the data task has completed. This method should:
    - Take the `baseURL` and append the identifier of the entry parameter to it. Add the `"json"` extension to the URL as well.
    - Create a `URLRequest` object. Set its HTTP method to PUT.
    - Using `JSONEncoder`, encode the entry's `entryRepresentation` into JSON data. Set the URL request's `httpBody` to this data.
    - Perform a `URLSessionDataTask` with the request, and handle any errors. Make sure to call completion and resume the data task.
4. Call this method from the `CreateEntryViewController`'s `save` method and the `EntryDetailViewController`'s `viewWillDisappear` method.
5. Create a `deleteEntryFromServer` method. It should take in an entry, and a completion closure that returns an optional error. Again, give the closure a default value of an empty closure. This method should:
    - Create a URL from the `baseURL` and append the entry parameter's identifier to it. Also append the "json" extension to the URL as well. This URL should be formatted the same as the URL you would use to PUT an entry to Firebase.
    - Create a `URLRequest` object, and set its HTTP method to DELETE.
    - Perform a `URLSessionDataTask` with the request and handle any errors. Call completion and don't forget to resume the data task.
6. Call the `deleteEntryFromServer` method from the `EntriesTableViewController`'s `commitEditingStyle` method.

Test the app at this point. You should be able to both create and update entries and they will be sent to Firebase as well as to the `NSPersistentStore` on the device. You should also be able to delete entries from Firebase also.

#### Part 2 - Syncing Databases

#### Back to EntryController

The goal when fetching the entries from Firebase is to go through each fetched entry and check a couple things:
- **Is there a corresponding entry in the device's persistent store?**
    - No, so create a new `Entry` object. (This would happen if someone else created an entry on their device and you don't have it on your device yet)
    - Yes. Are its values different from the entry fetched from Firebase? If so, then update the entry in the persistent store with the new values from the entry from Firebase.

You'll use the `EntryRepresentation` to do this. It will let you decode the JSON as `EntryRepresentation`s, perform these checks and either create an actual `Entry` if one doesn't exist on the device or update an existing one with its decoded values.

Back in the `EntryController`, you will make a couple methods that will help when fetching the entries from Firebase. 

1. Create a new function called `update`. It should take in an `Entry` whose values should be updated, and an `EntryRepresentation` to take the values from. This should simply set each of the `Entry`'s values to the `EntryRepresentation`'s corresponding values. **DO NOT** call `saveToPersistentStore` in this method. It will be explained why later on.
2. Create a method called `updateEntries(with representations: [EntryRepresentation])`. This method's `representation` argument represents the EntryRepresentation objects that are fetched from Firebase. This method should:
    - Create a fetch request from `Entry` object. 
    - Create a dictionary with the identifiers of the `representations` as the keys, and the values as the `representations`. To accomplish making this dictionary you will need to create a separate array of just the entry representations identifiers. You can use the `zip` method to combine two arrays of items together into a dictionary.
    - Give the fetch request an `NSPredicate`. This predicate should see if the `identifier` attribute in the `Entry` is in identifiers array that you made from the previous step. Refer to the hint below if you need help with the predicate.
    - <details><summary>Predicate Hint:</summary><p>
  
      `NSPredicate(format: "identifier IN %@", identifiersToFetch) // assuming the array of identifiers you made was called "identifiersToFetch"`

      </p>
      </details>
    - Perform the fetch request on your core data stack's `mainContext`. This will return an array of `Entry` objects whose identifier was in the array you passed in to the predicate. Make sure you handle a potential error from the `fetch` method on your managed object context, as it is a throwing method.
    - From here, loop through the fetched entries and call your `update(entry: ...` method that you made earlier. One you have updated the entry, remove the entry from the dictionary you made a few points earlier. This will make it so you only create entries from the remaining objects in the dictionary. The only ones that would remain after this loop are ones that didn't exist in Core Data already.
    - Then make a second loop through your dictionary's `values` property. This should create an entry for each of the values in that dictionary using the `Entry` initializer that takes in an `EntryRepresentation` and an `NSManagedObjectContext`
    - Under both loops, call `saveToPersistentStore()` to persist the changes and effectively synchronize the data in the device's persistent store with the data on the server.  Since you are using an `NSFetchedResultsController`, as soon as you save the managed object context, the fetched results controller will observe those changes and automatically update the table view with the updated entries.
    
3. Create a function called `fetchEntriesFromServer`. It should have a completion closure that looks like the other closures you've used in this class and its default value should be an empty closure. This method should:
    - Take the `baseURL` and add the "json" extension to it. 
    - Perform a GET `URLSessionDataTask` with the url you just set up.
    - In the completion of the data task, check for errors
    - Unwrap the data returned in the closure.
    - Create a variable of type `[EntryRepresentation]`. Set its initial value to an empty array.
    - Decode the data into `[String: EntryRepresentation].self`. Set the value of the array you just made in the previous step to the entry representations in this decoded dictionary. Think about why we are decoding it in this way. Loop through the dictionary to return an array of just the entry representations without the identifier keys. **HINT:** You can use a for-in loop or `map` to do this.
    - Call your `updateEntries` method that you just made in the previous step.
    - Call completion and pass in `nil` for the error.
    - Don't forget to resume the data task.
4. Write an initializer for the `EntryController`. It shouldn't take in any values. Inside of the initializer, call the `fetchEntriesFromServer` method. As soon as the app runs and initializes this model controller, it should fetch the entries from Firebase and update the persistent store.

The app should be working at this point. Test it by going to the Firebase Database in a browser and changing some values in the entries saved there. The easiest thing to change is the mood. This will allow you to easily see if the table view will update according to the new changes. It may take a few seconds after the app launches, but you should see the cell(s) move to different sections if you changed the mood of some entries in Firebase.

