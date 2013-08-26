# MotionDataWrapper

![Travis CI](https://secure.travis-ci.org/macfanatic/motion_data_wrapper.png?branch=master)

Easy CoreData integration for querying and persistence provided for RubyMotion projects for iOS and Mac OS X.

## Introduction
Forked from the [mattgreen/nitron](https://github.com/mattgreen/nitron/) gem, this provides an intuitive way to query and persist data in CoreData, while letting you use the powerful Xcode data modeler and versioning tools for schema definitions.  Even includes automatatic lightweight migrations!

## Installation
Recommended installation is to use Bundler.

### Bundler

Add the following to your project's `Gemfile` to work with bundler.

```ruby
gem "motion_data_wrapper"
```

Install with bundler:

```ruby
bundle install
```

### Xcode Data Modeler
MotionDataWrapper does not provide schema or migration classes wrapping any of the provided tools from Apple. Instead, we load in the data model file created in Xcode and let CoreData map out the entities, relationships, validations, and migrations.  This allows you to have the full toolset provided by CoreData, without being limited by our implementation.

What we do provide is an easy way to integrate with CoreData for the most common tasks, such as persistence and querying the object graph.

### Getting Started
Follow these instructions to get started on your project with MotionDataWrapper:

1. Add the gem to your Gemfile if not done already
2. Create a new Xcode project in the root of your RubyMotion project, add the "name.xcodeproj" file to your .gitignore file as it is not needed
3. Inside Xcode, create a new "Data Model" file and save that in your "resources" folder for RubyMotion to automatically compile when running `rake`.
4. From the "Editor" menu, select "Add Model Version..." and type whatever name you want.
5. Select this new model version and in the attributes inspector, provide a "Core Data Model" identifier, ie "1.0"
6. Set this version as the current version of your CoreData object model, [with these instructions](http://stackoverflow.com/a/5374485).
7. Setup your entities, relationships, validations and migrations in Xcode, which is outside the scope of this tutorial.
8. Include the `MotionDataWrapper::Delegate` module into your application delegate.  For available options to customize this behavior for injecting the needed methods to setup CoreData in your iOS/Mac project, see [this file](https://github.com/macfanatic/motion_data_wrapper/blob/master/lib/motion_data_wrapper/delegate.rb).
9. Define your model classes in Ruby code to correspond to each entity defined in Xcode.
10. Utilize your new model classes as documented farther down.

```ruby
# app/app_delegate.rb
class AppDelegate
  include MotionDataWrapper::Delegate
end

# app/models/post.rb
class Post < MotionDataWrapper::Model
end
```

## ActiveRecord Style Syntax
MotionDataWrapper offers lots of your favorite ActiveRecord features for querying and persisting objects, including the following methods.

### Querying
Most of the familiar Rails AR query methods are available, even dynamic finders, including the following:

* all
* count
* empty?
* exists?
* find_all_by
* find_by
* find_by!
* first
* first!
* last
* last!
* limit
* offset
* order
* pluck
* take
* take!
* uniq
* where

```ruby
# Querying Tasks

Task.all # Array of tasks

Task.pluck(:assignee_id) # returns array of non-distinct values
Task.uniq.pluck(:assignee_id) # now the array of id values is distinct

Task.first # First task or nil
Task.first! # First task or MotionDataWrapper::RecordNotFound exception

Task.limit(1) # returns one task
Task.offset(5).limit(1) # grab the 6th task, as an array with one item in it
Task.where("title contains[cd] ?", "some") # grab all tasks with the title containing "some", case insensitive
Task.where("title contains[cd] ?", "some").count # db call to count the objects matching the conditions

Task.count # number of tasks in the system

Task.order(:title, ascending: false) # Tasks order in reverse alphabetical order on title attribute

# Testing for existance
Task.where("title contains[cd] ?", "some").exists?
Task.where("title contains[cd] ?", "some").empty?

# Overriding existing query
scope = Task.where("status = ?", :open)
scope.except(:where).where("status = ?", :closed) # realized I really wanted closed items
scope.order(...).except(:order)
scope.limit(...).except(:limit)

# Daisy Chaining
Task.where(...).order(...).where(...).offset(10).limit(5).count # Yep, this works!
Task.where(...).order(...).all # array of the results

# Dynamic Finders
Task.find_by_status :open # returns the first task with a status of open, or nil
Task.find_all_by_status :open # returns array containing Tasks matching that status


# Search in a specific managed object context
Task.with_context(bg_ctx).where(...) # searches using a specific context, default is App.delegate.managedObjectContext
```

### Persistence
MotionDataWrapper supports the normal convention of `#save`, `#save!`, `#create` and `#create!` from ActiveRecord.  However, always be aware that in CoreData there is no way to save just one instance in the managed object context to the persistent store, it's all or nothing.  As such, calling any of these persistence methods will cause all unstored instances to be persisted to the context.

MotionDataWrapper includes support for model validations, defined in your Xcode data model file.  On the above methods, CoreData will automatically run the validations anyway and MotionDataWrapper provides more helpful user-friendly error messages to display to the user, as well as the familiar `#errors` hash.

Supported persistence methods:

* create
* create!
* destroy
* destroy_all
* errors
* persisted?
* save
* save!
* valid?

```ruby
# Creating tasks
Task.create assignee_id: 1, title: "some title" # runs validations, saves object into the default context if validations pass
Task.create! # MotionDataWrapper::RecordNotSaved thrown if validations fail
Task.new # creates a new Task object, outside of a NSManagedObjectContext, optionally takes attributes

task = Task.new
task.save # will save, true if successful, false if failed
task.save! # will throw MotionDataWrapper::RecordNotSaved if failed, contains errors object for validation messages
```
