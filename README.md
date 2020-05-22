# Journal (Core Data) Day 4

## Introduction

<<<<<<< HEAD
<<<<<<< HEAD
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
Today's project will continue to add more functionality to the Journal project. You will add syncing between Core Data and a server. In this case, Firebase will be used as the server. Since we have already set up an `NSFetchedResultsController` to update the table view when the persistent store's managed objects change, you will only need to do work on the model and model controller layers. This is a good example of adding functionality without having to tear up your entire application.

## Instructions

Use the Journal project you made yesterday. Create a new branch called `day3`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day3` branch as the base branch, and your own `day3` branch as the compare branch.
>>>>>>> f4b1ceb72f5652339545cfa2aa66ecd5cb3262ce

### Part 1 - PUTting and deleting Entries

First, you'll set up the ability to PUT entries to Firebase. Since the `Entry` entity already has an `identifier` attribute, there is no need to make a new model version.

<<<<<<< HEAD
Feel free to take the core data stack you used in the guided project and paste it in this file. You may need to change the name of the persistent container to match the name of your data model file.
=======
1. Create a new Firebase project for this application. Choose to use the "Realtime Database" and set it to testing mode so no authentication is required.
>>>>>>> f4b1ceb72f5652339545cfa2aa66ecd5cb3262ce

#### EntryRepresentation

Something to keep in mind when trying to sync multiple databases like we are in this case is that you need to make sure you don't duplicate data. For example, say you have an entry saved in your persistent store on the device, and on Firebase. If you were to go about fetching the entries from Firebase and decoding them into `Entry` objects like you've done previously before today, you would end up with a duplicate of the entry in your persistent store. This would occur every single time that you fetch the entry from Firebase. 

<<<<<<< HEAD
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
=======
For today's project, you will update Journal to update its Core Data data from the server in the background. This will allow you to practice more complex Core Data scenarios using multiple managed object contexts, as well as using concurrency with Core Data. You will be modifying an existing codebase to be more performant and correct. To prepare for many of these changes, you'll [_refactor_](https://en.wikipedia.org/wiki/Code_refactoring) your code, meaning you'll restructure it so that it's functionality can be updated without compromising its readability and maintainability.

The instructions for this project are intentionally somewhat less detailed that previous instructions this week. This project will require you to think about and understand how to architect your app to use multiple contexts and concurrency correctly. As always, follow the 20-minute rule, but don't be afraid to ask for help as you work.

## Instructions

Use the Journal project you made yesterday. Create a new branch called `day4`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day4` branch as the base branch, and your own `day4` branch as the compare branch.
>>>>>>> 5ade799d2cee98eca603f1374f1eef1bd7cbc30b

### Part 0 - Troubleshooting

<<<<<<< HEAD
#### Back to EntryController
=======
Before starting, run your app with the `-com.apple.CoreData.ConcurrencyDebug 1` launch argument. Exercise all functions of the app and note whether any Core Data concurrency assertions are triggered. Were any triggered (ie. did the app crash)? If so, why? Today you'll fix these problems while simultaneously improving the overall performance of the app.

### Part 1 - Refactor to Prepare for Multiple Contexts

Start by refactoring some of your code to be better prepared to switch to using a separate managed object context for syncing operations.

1. Change your convenience initalizer for creating an `Entry` from an `EntryRepresentation` to accept a context in which to create the new `Entry`.
2. Remove the `EntryController`'s `saveToPersistentStore` method and instead create a `save(context: NSManagedObjectContext)` method in your `CoreDataStack`. This should call `.performAndWait` on the context that is passed in, then save the same context. Handle any potential errors.

### Part 2 - Use Concurrency APIs to Ensure Correctness
>>>>>>> 5ade799d2cee98eca603f1374f1eef1bd7cbc30b

Even though you haven't yet updated your code to use multiple contexts, you can prepare for that by using Core Data's concurrency APIs to ensure that regardless of context, your code is concurrency-safe. Core Data is designed in such a way that you can write concurrency-correct code without having to keep track of and maintain the dispatch queues that each context has yourself.

Remember that **any** use of managed objects or a managed object context must be done in a `perform` or `performAndWait` call for non-main-queue contexts. Even for main-queue contexts, it is safe and valid to use `perform` or `performAndWait`.

1. Go through each function that deals with managed objects. Decide whether it should ensure concurrency correctness itself, or whether responsibility for correctness should be left up to its caller. 
2. Update each function to do its work using `perform()` or `performAndWait()` on the main context for now.
3. Run your app with the `-com.apple.CoreData.ConcurrencyDebug 1` launch argument. Exercise all functions of the app and verify that no Core Data concurrency assertions are triggered (i.e. the app shouldn't crash). 

<<<<<<< HEAD
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
>>>>>>> f4b1ceb72f5652339545cfa2aa66ecd5cb3262ce
=======
### Part 3 - Use a Background Context for Syncing

While the app shouldn't crash anymore, it's still using the main context for operations that could potentially take a long time and block the main queue. In order to fix this:

1. Update your `updateEntries(with representations: ...)` method so that it creates a new background context, and does all Core Data work on this context. It should update/create tasks from the fetched data on this context.
2. Save the context only after the update/creation process is complete. Remember that `save()` itself must be called on the context's private queue using `perform()` or `performAndWait()`. (You already made a function to do this earlier that you can call to do this)
3. In your `CoreDataStack`, after creating the container, set its `viewContext`'s `automaticallyMergesChangesFromParent` property to true. This is required for the `viewContext` (ie. the main context) to be updated with changes saved in a background context. In this case, the `viewContext`'s parent is the persistent store coordinator, **not** another context. This will ensure that the viewContext gets the changes you made on a background context so the fetched results controller can see those changes and update the table view automatically.

### Part 4 - Testing

Thoroughly test your app to be sure that all features continue to function correctly. From an end user perspective, the app should behave **exactly** as it did yesterday. While you're testing the app, be sure the `-com.apple.CoreData.ConcurrencyDebug 1` launch argument is set. Verify that no Core Data multithreading assertions are triggered.

If the app behaves correctly and doesn't trigger any assertions, you're done! Submit your pull request. If you have time left, try the suggestions in the Go Further section below.
>>>>>>> 5ade799d2cee98eca603f1374f1eef1bd7cbc30b
