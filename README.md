# Journal (Core Data) Day 3

## Introduction

Today's project will continue to add more functionality to the Journal project. You will add syncing between Core Data and a server. In this case, Firebase will be used as the server. Since we have already set up an `NSFetchedResultsController` to update the table view when the persistent store's managed objects change, you will only need to do work on the model and model controller layers. This is a good example of adding functionality without having to tear up your entire application.

Please look at the screen recording below to know what the finished project should look like:

![](https://user-images.githubusercontent.com/16965587/44161634-2a8b6480-a07b-11e8-948d-0c7e7c43bc78.gif)

## Instructions

Use the Journal project you made yesterday. Create a new branch called `day3`. When you finish today's instructions and go to make a pull request, be sure to select the original repository's `day3` branch as the base branch, and your own `day3` branch as the compare branch.

### Part 1 - PUTting and deleting Entries

First, you'll set up the ability to PUT entries to Firebase. Since the `Entry` entity already has an `identifier` attribute, there is no need to make a new model version.

1. Create a new Firebase project for this application. Choose to use the "Realtime Database" and set it to testing mode so no authentication is required.

<details><summary>Click to expand these step-by-step instructions if you need some further guidance setting up your database.</summary>

1. Go to https://console.firebase.google.com
    - sign in if you need to
2. Click the big "Add Project" button. Give your project a name.
    - For now you can disable Google Analytics.
3. After you've created the project and it's finished instantiating, you should end up on the project dashboard. Click the "Database" option in the menu on the left.
4. Scroll down until you find the section labeled "Realtime Database." Click the "Create database" button in this section.
5. In the "Security rules" popup window, select "Start in test mode," and click "Enable."
6. Your database is set up! Use the provided URL on this screen as your base URL.
</details>

#### EntryRepresentation

Something to keep in mind when trying to sync multiple databases like we are in this case is that you need to make sure you don't duplicate data. For example, say you have an entry saved in your persistent store on the device, and on Firebase. If you were to go about fetching the entries from Firebase and decoding them into `Entry` objects like you've done previously before today, you would end up with a duplicate of the entry in your persistent store. This would occur every single time that you fetch the entry from Firebase. 

The way to prevent this is to create an intermediate data type between the JSON and the `Entry` class that will serve as a temporary representation of an `Entry` without being added to a managed object context.

1. Create a new Swift file called "EntryRepresentation". In the file, create a struct called `EntryRepresentation`.
2. Adopt the `Codable` protocol.
3. Add a property in this struct for each attribute in the `Entry` model. Their names should match exactly or else the JSON from Firebase will not decode into this struct properly.
4. In the "Entry+Convenience.swift" file, add a new convenience initializer. This initializer should be failable. It should take in an `EntryRepresentation` parameter and an `NSManagedObjectContext`. This should simply pass the values from the entry representation to the convenience initializer you made earlier in the project. 
5. In the `Entry` extension, create a `var entryRepresentation: EntryRepresentation` computed property. It should simply return an `EntryRepresentation` object that is initialized from the values of the `Entry`.

#### EntryController

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

Test the app at this point. You should be able to both create and update entries and they will be sent to Firebase as well as to the `NSPersistentStore` on the device. You should also be able to delete entries from Firebase also.

#### Part 2 - Syncing Databases

#### Back to EntryController

The goal when fetching the entries from Firebase is to go through each fetched entry and check a couple things:
- **Is there a corresponding entry in the device's persistent store?**
    - No, so create a new `Entry` object. (This would happen if someone else created an entry on their device and you don't have it on your device yet)
    - Yes. Are its values different from the entry fetched from Firebase? If so, then update the entry in the persistent store with the new values from the entry from Firebase.

You'll use the `EntryRepresentation` to do this. It will let you decode the JSON as `EntryRepresentation`s, perform these checks and either create an actual `Entry` if one doesn't exist on the device or update an existing one with its decoded values.

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


## Go Further

Just like yesterday, try to solidify today's concepts by starting over and rewriting the project from where you started today. Or even better, try to write the entire project with both today and yesterday's content from scratch. Use these instructions as sparingly as possible to help you practice recall.

