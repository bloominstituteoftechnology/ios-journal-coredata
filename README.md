<<<<<<< HEAD
<<<<<<< HEAD
# Journal (Core Data) Day 2

## Introduction

Today you will take the Journal project you made yesterday and add more functionality to it. This will help you practice migrating data in Core Data and `NSFetchedResultsController`.

Please look at the screen recording below to know what the finished project should look like:

![](https://user-images.githubusercontent.com/16965587/44080370-10aef76a-9f69-11e8-85de-289b9fea722a.gif)


## Instructions

Use the Journal project you made yesterday. Create a new branch called `day2`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day2` branch as the base branch, and your own `day2` branch as the compare branch.

### Part 1 - Mood Feature

#### Segmented Control Addition

In order to add the functionality seen in the screen recording, which is the ability to set your mood: 

1. Add a `UISegmentedControl` to the `EntryDetailViewController` scene. 
2. Make 3 segments.
3. Set each segment's title to a mood. In the example screen recording, it uses happy, sad, and neutral emoji for the three moods, but you can choose anything you want.
4. Make an outlet from the segmented control to the view controller's class file.

#### Data Model Updates and Migration

Now, you will update your Core Data model to include a property to hold the mood that the user selects on the segmented control.

1. Select your Core Data data model file. In the menu, select Editor -> Add Model Version (keep it the same name and click the "Finish" button.
2. In the new data model file, add a new attribute called `mood`. Set its type to be `String`. 
3. Give the `mood` a default value. In the example, the default value is 😐, the neutral emoji. Again, you can choose whichever 3 moods you want. Just make sure to set the default value of this attribute to one of them.  This will allow the `Entry` objects that have been created before `mood` was added to have an initial value. 
4. In the File Inspector with the data model file selected, set the current model version to the new model version you just created. (It should be something like `Journal 2`)
5. Now navigate to your "Entry+Convenience.swift" file where you have the `Entry` extension and convenience initializer. Update the initializer to include and property initialize the new `mood` property.
6. Update your "Create" `EntryController` method to call the updated `Entry` initializer
7. Update your "Update" `EntryController` method to include a `mood` String parameter so the entry's `mood` can also be updated.

You will need to update the `EntryDetailViewController` in order for the mood to get saved (or updated) to an entry.

1. In the `EntryDetailViewController`'s save entry action (where you call the "Create" and "Update" CRUD methods), check which segment is selected and create a string constant that holds the corresponding mood.
    - **NOTE:** There are a few ways to go about this. You can use the `selectedSegmentIndex` propery of the segmented control to get the currently selected segment. From there, you can either create a conditional statement that will set the constant's value based on the `selectedSegmentIndex`. You could also use the `titleForSegment(at: Int)` method if the text in each segment is exactly what your moods are going to be. 
    - Remember that you're dealing with strings here. Now would be a perfect time to create an enum with a case for each of your three moods. You can add string raw values to each case that holds the mood string. This will help you make sure that you're using the same three strings anywhere in the application.
2. Still in the save entry action, you will need to update the "Create" and "Update" method calls to include the mood string you just made.
3. In the `updateViews()` method, set the segmented control's `selectedSegmentIndex` based on the entry's `mood` property. Doing this programmatically will cause the segmented control have the entry's corresponding mood segment selected to the user.

At this point, take the time to test your project. Make sure that:

- Entries that you have saved before adding the `mood` property have a default `mood` value added to them.
- The segmented control in the detail view controller selects the correct mood of an entry that you view when seguing to it.
- Moods get saved correctly to entries, both newly created and updated.

#### Part 2 - NSFetchedResultsController Implementation

You will now implement an `NSFetchedResultsController` to manage displaying entries on and handling interactions with the table view.

##### EntryController

1. Delete or comment out the `loadFromPersistentStore` method, and the `entries` array in the `EntryController`. The fetched results controller will manage performing fetch requests and giving data to the table view now.

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
2. Adopt the `NSFetchedResultsControllerDelegate` protocol in this view controller.
3. Add the following delegate methods to the table view controller:
    - `controllerWillChangeContent`.
    - `controllerDidChangeContent`.
    - `didChange sectionInfo` ... `atSectionIndex`.
    - `didChange anObject` ... `at indexPath`.

Remember that the implementation of these methods is going to be the same in most cases. You can use the implementations created in this morning's guided project. 

Now you will change the `UITableViewDataSource` methods to look to the fetched results controller for information about how to set up the table view instead of the (no longer existing) `entries` array in the `EntryController`.

<<<<<<< HEAD
### Part 1 - Storyboard Layout
=======
# Journal (Core Data) Day 3
=======
# Journal (Core Data) Day 4
>>>>>>> ee35911f8b7c78cf68ad2369aeff1d126f3c7c5e

## Introduction

For today's project, you will update Journal to update its Core Data data from the server in the background. This will allow you to practice more complex Core Data scenarios using multiple managed object contexts, as well as using concurrency with Core Data. You will be modifying an existing codebase to be more performant and correct. To prepare for many of these changes, you'll [_refactor_](https://en.wikipedia.org/wiki/Code_refactoring) your code, meaning you'll restructure it so that it's functionality can be updated without compromising its readability and maintainability.

The instructions for this project are intentionally somewhat less detailed that previous instructions this week. This project will require you to think about and understand how to architect your app to use multiple contexts and concurrency correctly. As always, follow the 20-minute rule, but don't be afraid to ask for help as you work.

## Instructions

<<<<<<< HEAD
Use the Journal project you made yesterday. Create a new branch called `day3`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day3` branch as the base branch, and your own `day3` branch as the compare branch.

### Part 1 - PUTting and deleting Entries
>>>>>>> 785a6c4f1ef9fcba0406a52f34f1e7df72ec1bc8

First, you'll set up the ability to PUT entries to Firebase. Since the `Entry` entity already has an `identifier` attribute, there is no need to make a new model version.

1. Create a new Firebase project for this application. Choose to use the "Realtime Database" and set it to testing mode so no authentication is required.

#### EntryRepresentation

Something to keep in mind when trying to sync multiple databases like we are in this case is that you need to make sure you don't duplicate data. For example, say you have an entry saved in your persistent store on the device, and on Firebase. If you were to go about fetching the entries from Firebase and decoding them into `Entry` objects like you've done previously before today, you would end up with a duplicate of the entry in your persistent store. This would occur every single time that you fetch the entry from Firebase. 

The way to prevent this is to create an intermediate data type between the JSON and the `Entry` class that will serve as a temporary representation of an `Entry` without being added to a managed object context.

1. Create a new Swift file called "EntryRepresentation". In the file, create a struct called `EntryRepresentation`.
2. Adopt the `Codable` protocol.
3. Add a property in this struct for each attribute in the `Entry` model. Their names should match exactly or else the JSON from Firebase will not decode into this struct properly.
4. In the "Entry+Convenience.swift" file, add a new convenience initializer. This initializer should be failable. It should take in an `EntryRepresentation` parameter and an `NSManagedObjectContext`. This should simply pass the values from the entry representation to the convenience initializer you made earlier in the project. 
5. In the `Entry` extension, create a `var entryRepresentation: EntryRepresentation` computed property. It should simply return an `EntryRepresentation` object that is initialized from the values of the `Entry`.
=======
Use the Journal project you made yesterday. Create a new branch called `day4`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day4` branch as the base branch, and your own `day4` branch as the compare branch.

### Part 0 - Troubleshooting

Before starting, run your app with the `-com.apple.CoreData.ConcurrencyDebug 1` launch argument. Excercise all functions of the app and note whether any Core Data concurrency assertions are triggered. Were any triggered (ie. did the app crash)? If so, why? Today you'll fix these problems while simultaneously improving the overall performance of the app.
>>>>>>> ee35911f8b7c78cf68ad2369aeff1d126f3c7c5e

### Part 1 - Refactor to Prepare for Multiple Contexts

<<<<<<< HEAD
<<<<<<< HEAD
1. Create a Swift file called "EntryController.swift". Make a class called `EntryController`.
2. Create a function called `saveToPersistentStore()`. This method should save your core data stack's `mainContext`. Remember that this will bundle the changes in the context, pass them to the persistent store coordinator who will then put those changes in the persistent store.
3. Create a function called `loadFromPersistentStore() -> [Entry]`. This method should:
    - Create an `NSFetchRequest` for `Entry` objects
    - Perform that fetch request on the core data stack's `mainContext` using a do-try-catch block.
    - Return the results of the fetch request.
    - In the catch statement, handle any errors and return an empty array.
4. Create an `entries: [Entry]` computed property. Inside of the computed property, call `loadFromPersistentStore()`. This will allow any changes to the persistent store become immediately visible to the user when accessing this array (i.e. in the table view showing a list of entries).
5. Create a "Create" CRUD method that will:
    - Initialize an `Entry` object
    - Save it to the persistent store. 
    - **NOTE:** if Xcode is giving you a warning that the `Entry` object isn't being used, you can make the constant's name `_`, or add the `@discardableResult` attribute to the `Entry`'s convenience intializer in the extension you created.
6. Create an "Update" CRUD method. The method should:
    - Have title and bodyText parameters as well as the `Entry` you want to update.
    - Change the title and bodyText of the `Entry` to the new values passed in as parameters to the function.
    - Update the entry's timestamp to the current time as well.
    - Save these changes to the persistent store.
7. Create a "Delete" CRUD method. This method should:
    - Take an an `Entry` object to delete
    - Delete the `Entry` from the core data stack's `mainContext`
    - Save this deletion to the persistent store.

### Part 3 - View and View Controller Implementation

In the `EntryTableViewCell` class:

1. Add an `entry: Entry?` variable.
2. Create an `updateViews()` function that takes the values from the `entry` variable and places them in the outlets.
3. Add a `didSet` property observer to the `entry` variable. Call `updateViews()` in it.

In the `EntryDetailViewController`:

1. Add an `entry: Entry?` variable.
2. Add an `entryController: EntryController?` variable.

In the `EntryTableViewController`:

1. Add an `entryController` constant whose value is a new instance of `EntryController`.
2. Implement the `numberOfRows` method. It should return the amount of entries in the `entryController`.
3. Implement the `cellForRowAt` method. Remember to cast the call as `EntryTableViewCell`, then pass an `Entry` to the cell's `entry` property in order for it to call the `updateViews()` method to fill in the information for the cell's labels.
4. Add the `viewWillAppear` method. It should reload the table view.
5. Implement the `commit editingStyle` `UITableViewDataSource` method to allow the user to swipe to delete entries. You don't have to handle the `editingStyle` being `.insert`, just `.delete`.
6. Implement the `prepare(for segue: ...)` method. If the segue's identifier shows that the user is trying to create an entry, you will only need to pass the `entryController` to the destination view controller. If the identifier shows that they want to view an entry (by tapping a cell), pass the `entryController` and also the `Entry` that corresponds with the cell they tapped.

Back in the `EntryDetailViewController`:

1. Add an `updateViews()` method. Inside of it:
    - Make sure the view is loaded.
    - Set the view controller's title to the title of the `entry` if one was passed to this view controller, or "Create Entry" if not. 
    - This method should also fill in the text field and text view's `text` to the `title` and `bodyText` of the `entry` respectively.
2. Add a `didSet` to the `entry` variable, and call `updateViews()` in it. Also call `updateViews()` in the `viewDidLoad`.
3. In the bar button item's action:
    - Unwrap the text from both the text field and text view.
    - Unwrap the `entry` property separately. If there is an entry, call the `update` method in the `entryController`. If not, call the `createEntry` method in the `entryController` instead. Either way, pop the view controller off the navigation stack.
=======
4. Add the `numberOfSections(in tableView: ...)` method if you don't have it already. This should use the number of sections in the fetched results controller's `sections` array.
5. In the `numberOfRowsInSection`, Again, use the `section` parameter to get the section currently being set up to return the `numberOfObjects`.
6. In the `cellForRowAt`, use the fetched results controller's `object(at: IndexPath)` method to get the correct entry corresponding to the cell instead of using the `entries` array in the `EntryController.
7. In the `commit editingStyle`, use the `object(at: IndexPath)` method again to get the correct entry to be deleted instead of using the `entries` array in the `EntryController.
8. Use the same `object(at: IndexPath)` method in the `prepare(for segue: ...)` method to get the correct entry instead of using the `entries` array in the `EntryController.
>>>>>>> 0ea488aa741a070df3edaf5271896bc1b8dfed43
=======
1. In the `EntryController`, add a `baseURL: URL` constant that is the URL from the new Firebase database you created for this app.
2. Create a function called `put`, that takes in an entry and has an escaping completion closure. The closure should return an optional error. Give this completion closure a default value of an empty closure. (e.g. `{ _ in }` ). This will allow you to use the completion closure if you want to do something when `completion` is called or just not worry about doing anything after knowing the data task has completed. This method should:
    - Take the `baseURL` and append the identifier of the entry parameter to it. Add the `"json"` extension to the URL as well.
    - Create a `URLRequest` object. Set its HTTP method to PUT.
    - Using `JSONEncoder`, encode the entry's `entryRepresentation` into JSON data. Set the URL request's `httpBody` to this data.
    - Perform a `URLSessionDataTask` with the request, and handle any errors. Make sure to call completion and resume the data task.
3. Call the `put` method in the `createEntry` and `update(entry: ...)` methods.
4. Create a `deleteEntryFromServer` method. It should take in an entry, and a completion closure that returns an optional error. Again, give the closure a default value of an empty closure. This method should:
    - Create a URL from the `baseURL` and append the entry parameter's identifier to it. Also append the "json" extension to the URL as well. This URL should be formatted the same as the URL you would use to PUT an entry to Firebase.
    - Create a `URLRequest` object, and set its HTTP method to DELETE.
    - Perform a `URLSessionDataTask` with the request and handle any errors. Call completion and don't forget to resume the data task.
5. Call the `deleteEntryFromServer` method in your `delete(entry: ...)` method.
=======
Start by refactoring some of your code to be better prepared to switch to using a separate managed object context for syncing operations.
>>>>>>> ee35911f8b7c78cf68ad2369aeff1d126f3c7c5e

1. Change your convenience initalizer for creating an `Entry` from an `EntryRepresentation` to accept a context in which to create the new `Entry`.
2. Remove the `EntryController`'s `saveToPersistentStore` method and instead create a `save(context: NSManagedObjectContext)` method in your `CoreDataStack`. This should call `.performAndWait` on the context that is passed in, then save the same context. Handle any potential errors.

### Part 2 - Use Concurrency APIs to Ensure Correctness

<<<<<<< HEAD
#### Back to EntryController
=======
Even though you haven't yet updated your code to use multiple contexts, you can prepare for that by using Core Data's concurrency APIs to ensure that regardless of context, your code is concurrency-safe. Core Data is designed in such a way that you can write concurrency-correct code without having to keep track of and maintain the dispatch queues that each context has yourself.

Remember that **any** use of managed objects or a managed object context must be done in a `perform` or `performAndWait` call for non-main-queue contexts. Even for main-queue contexts, it is safe and valid to use `perform` or `performAndWait`.

1. Go through each function that deals with managed objects. Decide whether it should ensure concurrency correctness itself, or whether responsibility for correctness should be left up to its caller. 
2. Update each function to do its work using `perform()` or `performAndWait()` on the main context for now.
3. Run your app with the `-com.apple.CoreData.ConcurrencyDebug 1` launch argument. Exercise all functions of the app and verify that no Core Data concurrency assertions are triggered (i.e. the app shouldn't crash). 

### Part 3 - Use a Background Context for Syncing

While the app shouldn't crash anymore, it's still using the main context for operations that could potentially take a long time and block the main queue. In order to fix this:
>>>>>>> ee35911f8b7c78cf68ad2369aeff1d126f3c7c5e

1. Update your `updateEntries(with representations: ...)` method so that it creates a new background context, and does all Core Data work on this context. It should update/create tasks from the fetched data on this context.
2. Save the context only after the update/creation process is complete. Remember that `save()` itself must be called on the context's private queue using `perform()` or `performAndWait()`. (You already made a function to do this earlier that you can call to do this)
3. In your `CoreDataStack`, after creating the container, set its `viewContext`'s `automaticallyMergesChangesFromParent` property to true. This is required for the `viewContext` (ie. the main context) to be updated with changes saved in a background context. In this case, the `viewContext`'s parent is the persistent store coordinator, **not** another context. This will ensure that the viewContext gets the changes you made on a background context so the fetched results controller can see those changes and update the table view automatically.

### Part 4 - Testing

<<<<<<< HEAD
Back in the `EntryController`, you will make a couple methods that will help when fetching the entries from Firebase. 

1. Create a new "Update" function called `update`. It should take in an `Entry` whose values should be updated, and an `EntryRepresentation` to take the values from. This should simply set each of the `Entry`'s values to the `EntryRepresentation`'s corresponding values. **DO NOT** call `saveToPersistentStore` in this method. It will be explained why later on.
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
    
3. Create a function called `fetchEntriesFromServer`. It should have a completion closure that returns an optional error and its default value should be an empty closure. This method should:
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

**NOTE: The app will not automatically fetch posts when you change or add posts in the database.** At this point you must trigger the fetch manually, the simplest way being to relaunch the application. If you want, you could look up how to implement a refresh control on a table view controller which would allow you to drag down on the table view to refresh the table view and allow you to re-fetch the entries.

>>>>>>> 785a6c4f1ef9fcba0406a52f34f1e7df72ec1bc8
=======
Thoroughly test your app to be sure that all features continue to function correctly. From an end user perspective, the app should behave **exactly** as it did yesterday. While you're testing the app, be sure the `-com.apple.CoreData.ConcurrencyDebug 1` launch argument is set. Verify that no Core Data multithreading assertions are triggered.

If the app behaves correctly and doesn't trigger any assertions, you're done! Submit your pull request. If you have time left, try the suggestions in the Go Further section below.
>>>>>>> ee35911f8b7c78cf68ad2369aeff1d126f3c7c5e

## Go Further

If you'd like a further challenge, try using a separate managed object context in the detail view controller. This managed object context can be used a scratchpad, so that operations on the task being created/edited occur in it, and are only saved to the main context after the user taps the Save button. You can make the detail view controller's context a child of the main context. You can also use one of the other multiple managed object context setups. Because you can not "switch" which context an object instance is in, you'll need to use `NSManagedObjectID` and related APIs to communicate to the detail view controller which task it should be displaying/editing.

Just like yesterday, try to solidify today's concepts by starting over and rewriting the project from where you started today. Or even better, try to write the entire project with both today and yesterday's content from scratch. Use these instructions as sparingly as possible to help you practice recall.
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> 785a6c4f1ef9fcba0406a52f34f1e7df72ec1bc8
=======

>>>>>>> ee35911f8b7c78cf68ad2369aeff1d126f3c7c5e
