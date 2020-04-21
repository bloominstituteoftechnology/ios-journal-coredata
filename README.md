# Journal (Core Data) Day 2

## Introduction

<<<<<<< HEAD
This version of Journal will allow you to implement each part of CRUD when working with Core Data.
=======
Today you will take the Journal project you made yesterday and add more functionality to it. This will help you practice migrating data in Core Data and `NSFetchedResultsController`.

Please look at the screen recording below to know what the finished project should look like:

![](https://user-images.githubusercontent.com/16965587/44080370-10aef76a-9f69-11e8-85de-289b9fea722a.gif)

>>>>>>> 0ea488aa741a070df3edaf5271896bc1b8dfed43

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

### Part 2 - Entry and EntryController Setup

#### CoreDataStack

Feel free to take the core data stack you used in the guided project and paste it in this file. You may need to change the name of the persistent container to match the name of your data model file.

#### Entry

You will be using a model object called `Entry`.

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
=======
4. Add the `numberOfSections(in tableView: ...)` method if you don't have it already. This should use the number of sections in the fetched results controller's `sections` array.
5. In the `numberOfRowsInSection`, Again, use the `section` parameter to get the section currently being set up to return the `numberOfObjects`.
6. In the `cellForRowAt`, use the fetched results controller's `object(at: IndexPath)` method to get the correct entry corresponding to the cell instead of using the `entries` array in the `EntryController.
7. In the `commit editingStyle`, use the `object(at: IndexPath)` method again to get the correct entry to be deleted instead of using the `entries` array in the `EntryController.
8. Use the same `object(at: IndexPath)` method in the `prepare(for segue: ...)` method to get the correct entry instead of using the `entries` array in the `EntryController.
>>>>>>> 0ea488aa741a070df3edaf5271896bc1b8dfed43

### UI Mockups

<<<<<<< HEAD
![Create entry view](https://raw.githubusercontent.com/LambdaSchool/ios-journal-coredata/master/CreateEntry-Blank.png)
![Entries table view](https://raw.githubusercontent.com/LambdaSchool/ios-journal-coredata/master/Tableview-with-Entry.png)
=======
Just like yesterday, try to solidify today's concepts by starting over and rewriting the project from where you started today. Or even better, try to write the entire project with both today and yesterday's content from scratch. Use these instructions as sparingly as possible to help you practice recall.
>>>>>>> 0ea488aa741a070df3edaf5271896bc1b8dfed43
