# Journal (Core Data)

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

### UI Mockups

![Create entry view](https://raw.githubusercontent.com/LambdaSchool/ios-journal-coredata/master/CreateEntry-Blank.png)
![Entries table view](https://raw.githubusercontent.com/LambdaSchool/ios-journal-coredata/master/Tableview-with-Entry.png)