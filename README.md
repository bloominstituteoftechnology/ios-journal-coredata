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
    - Create a sort descriptor that will sort the entries based on their `timestamp`. This can be either ascending or descending depending on your preference.
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


### Part 1 - Storyboard Layout

This application will implement the Master-Detail pattern that you're surely familiar with by now.

#### EntriesTableViewController and EntryTableViewCell

1. Delete the view controller scene that comes with the Main.storyboard
2. Add a `UITableViewController` scene, then embed it in a navigation controller. Set the navigation controller as the initial view controller. 
3. Add a `UIViewController` scene as well. Leave it blank for now.
4. On the table view controller scene, change its navigation item's title to "Journal".
5. Add a bar button item on the right side of the navigation bar. Change its "System Item" to "Add". 
6. Create a segue from the bar button item to the blank `UIViewController` scene. This segue will be used to create new entries. Give it an appropriate identifier.
7. Create a second segue from the table view's prototype cell. This segue will be used to view existing entries. Give it an appropriate identifier as well.
8. Create a Cocoa Touch subclass of `UITableViewController` called `EntriesTableViewController`. Set this table view controller scene's class to it.
8. This prototype cell will be a custom cell. Add three labels. One for the entry's title, timestamp, and body text.
9. Create a Cocoa Touch subclass of `UITableViewCell` called `EntryTableViewCell`. Set this cell's class to it.
10. Create outlets for the three labels in the `EntryTableViewCell` class.

#### EntryDetailViewController

1. In the `UIViewController` scene, add a `UITextField`. Set its placeholder text to "Enter a title:"
2. Add a `UITextView`. Remove the Lorem Ipsum text from it. Constrain the text field right below the navigation bar, and the text view below that.
3. Add a navigation item to the view controller, then add a bar button item on the right side of the navigation bar. Change its "System Item" to "Save".
4. Create a Cocoa Touch subclass of `UIViewController` called `EntryDetailViewController`. Set this scene's class to the newly created subclass in the Identity Inspector.
5. Create an outlet from the text field and one from the text view. Also, create an action from the bar button item.

### Part 2 - Entry and EntryController Setup

#### CoreDataStack

Create a swift file for your core data stack. Feel free to take the core data stack you used in this morning's project and paste it in this file. You may need to change the name of the persistent container to match the name of your data model file.

#### Entry

You will be using a model object called `Entry`.

1. Create a new Data Model file under the Core Data section. Make the name of the file match the name of your project.
2. Create a new entity and call it `Entry`. Keep the codegen as "Class Definition".
3. Add the following attributes to the `Entry` entity:
    - A `title` string.
    - A `bodyText` string.
    - A `timestamp` `Date`.
    - An `identifier` string.

4. Create a new swift file called "Entry+Convenience.swift". 
5. Import `CoreData` in this file.
6. Add an extension on `Entry`.
7. Create a convenience initializer that takes in values for each of the `Entry` entity's attributes, and an instance of `NSManagedObjectContext`. Consider giving default values to the timestamp and identifier parameters in this initializer. This initializer should:
    - Call the `Entry` class' initializer that takes in an `NSManagedObjectContext`
    - Set the value of attributes you defined in the data model using the parameters of the initializer.

#### EntryController

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

## Go Further

Just like yesterday, try to solidify today's concepts by starting over and rewriting the project from where you started today. Or even better, try to write the entire project with both today and yesterday's content from scratch. Use these instructions as sparingly as possible to help you practice recall.
