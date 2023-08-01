# Kotal Cherry Task Management App

This simple will helps you to create and view list of tasks. This project is created from scratch.

# Contents
1. Kotak Cherry Task Management App Features.
2. Architectural Design Components
3. Folder Structure
4. Data Flow 
5. Architecture Explanation
6. Supported Platforms
7. Know Bugs and Limitations

# Feature Set.
1. Create Task
2. View List of Tasks
3. Schedule Task Alerts and Notifications
4. Filter task list with 'Priority', 'Label' & 'Due Date'.
5. Sort task list with 'Priority' OR 'Due Date'
6. File attachments with Task.

## Kotak Cherry Task Management App Architecture Components
1. MVVM with Clean Architecture (Domain Layer)
2. Repository Pattern and Singleton Design Pattern
3. Multilayer Architecture (Data Layer, Business Layer(Domain or Use Cases, Entities), Presentation Layer)
4. Local Database used: Hive
5. Database Service for Local Database
6. Notification Library - Awesome Notifications
7. State Management Library: Provider

## App architecture overview.
I have created this project using MVVM with additional domain layer is used to keep the view models 
lean and more clear. For Accessing local data, repository classes are used. 

Folder structure is explained below. (Only Root folders explained).

**Data Folder** -> Implements Local and Remote data sources. (Only Local data in our case). "Data Repository" pattern is used to abstract data extraction.
        It also contains Model Classes for data layer. Two folders for Data Repositories.
        Database Repository -> For implementing Remote or Local database methods. 
        Task Repository -> To consume data from Database repository. It can also consume multiple data repositories and convert to single data object 
        depending upon the requirement.

**Domain Folder** -> It contains below use cases.
          <p>BaseUseCase -> Defines Repository object & invoke method.</p>
          <p>FetchTaskListUseCase -> Get all tasks from local database.</p>
          <p>SaveTaskUseCase -> Save task to database.</p>
          <p>SetCompletedTaskUseCase -> Mark task as 'completed' and saves to database.</p>
          <p>FetchCompletedTasksUseCase -> Get all completed tasks from database.</p>
          <p>FetchFilteredAndSortedTasksUseCase -> Get all tasks using filters and sort options.</p>
          <p>FetchFilteredCompletedTasksUseCase -> Get all completed tasks using filters and sort options.</p>
          
          This folder also contains BaseRepository & TaskRepository interface, which are imlemented in data folder.

**Entity Folder** -> It contains entities used throughout the app. 'BaseEntity' & 'TaskEntity'.

**UI Folder**-> It contains all common UI views and components, Feature folders (Create Task, Task List). It contains flutter widgets.

View Models Folder -> It contains View Models which uses 'Provider State Management' library.

## Data Flow (For Data Layer to Presentation Layer & vice-versa)

UI Layer -> View Models -> Use Cases -> Task Repo -> Database Repo -> Database Service.

1. 'DatabaseService' saves and retrieves data model objects from Local Database (Hive).
2. 'DatabaseRepoImp' class retrieves data from 'DataService' & maps to Entity classes.
3. 'TaskRepo' consumes data from 'DatabaseRepoImp' and provide data to Uses Cases.
4. 'UseCase' (Domain Layer) classes consumes data from 'TaskRepo' and implements required business logic.
5. 'ViewModels' consumes data from UseCases classes and provides data to Flutter Widgets (UI or Presentation Layer).

## Architectural Implementation
1. **'DatabaseService'** is a singleton class which will consume data from Hive database. This is simple key bases database.
   Note: For more complex scenarios and scalable app, SQlite will be used. I have avoided SQLite for now for simplistic implementation.
2. **Repository Pattern** is used for Data. It defines abstract interface, defining all methods which are required for task features. In our cases,
   there is only one implementation for Repository Imp i.e DatabaseRepoImp. (As no API service is used). If there are multiple data sources to be
   consume, multiple implementations will created.
3. **TaskRepo** interface is used handle multiple implementations. (Makes more sense in complex business apps).
4. **Uses Cases**: This will handle the app's business logic, e.g Filtering, Sorting etc. Then same Use Cases can be consumes in multiple View Models
   , keeping View Models clean, maintainable. It also help reusing same business logic code in multiple VMs.
5. Using View Models & Domain Use Cases, helps to implement cleaner Unit Test Cases.
6. **Notifications:** Only local notifications are implemented. No FCM is used. Flutter Library: 'awesome_notifications'. Toast notification is not 
   supported by this library. You will be able to see scheduled notification in 'Notification Center' of the android phone.
7. **Error Handling:** Using Result class is created. Result class have two subtypes: Success and Failure, which will return the either of the instance
   depending upon the Success or Failure of the code.

## Supported Platforms
Android, Web, iOS
Note: I have tested this app and UI only on Android OS.

## Known Bug and Limitations
1. Scheduled notification for Tasks will not show Toast.
2. No relation database is used to keep the development effort to minimal.
3. App is not tested in iOS and Web.

## Pointers
1. Dependency injection
2. Reason for not using SQLite
3. Singleton Pattern
4. Toast notification not working
5. Error Handing
6. Why use cases used.

