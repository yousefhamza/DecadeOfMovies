# Swvl Mobile Challenge 
## Installation
1. Install depenencies with cocoapods
```
pod install
```

# Technical Considerations

- Will use Core Data to handle caching, searching and sorting the data
- UI Tests were tested on iPhone 11 Pro Max
- Non-view Source files are added to the test target to be able to test it without relying on the app, which will make tests faster and more predictable 
- Stateful list was some old code of mine to fix the recurring problem of states in table/collection views
- API Key is kept in code for simplicity, but in production it should be pulled from a server for security
- KingFisher is used to cache images both in memory and on disk

## Milestones

### Pre-v1

This goal of this milestone to resolve high risk and fundamental components of the task 

- Prototype changing `predicate` on `NSFetchResultsController`, check [this tip](https://stackoverflow.com/questions/2482100/nsfetchedresultscontroller-changing-predicate-not-working)
- Measure performance of searching in tests (should be < 100ms)

#### Performance results
Perforamnce was measured using unit tests (runs on simulator only) on MBP 13" 2013

- Improrting takes 416ms
- Search takes 31ms

### v1

The goal of this milestone is to implement all functionalities at a very basic level

- Import movies on launch
- Add search controller
    - reload all data on search term change
- Display data with names only in a UITableView with years sections
- Display movie's  details
    - Add 3 buttons to show the lists of genres and cast and photos
- Add image loading/caching

![V1 demo](https://im7.ezgif.com/tmp/ezgif-7-fae6f7de0c53.gif)

### v2

The goal of this milestone is to add states to the different lists/collections in the app

- Add an import/error state with in the movies list
- Add an empty state for searching movies
- Add empty/error state for genres and cast and images lists
- Add loading state to image thumbnails

![V2 demo](https://im7.ezgif.com/tmp/ezgif-7-b7d805ff6f1c.gif)

### v3

The goal of this milestone is to polish the app by flattening the design, add more initiative interactions and using the space available to show more data

- Make genres an inline collection view
- Make case a collapsable list in the movies details page
- Open images by tapping and switch between them with swipes and close by swiping them down

[Add GIF to the flow]
