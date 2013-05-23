# MotionDataWrapper

## Introduction
Forked from the [mattgreen/nitron](https://github.com/mattgreen/nitron/) gem, this provides an intuitive way to query and persist data in CoreData, while letting you use the powerful Xcode data modeler and versioning tools for schema definitions.  Even includes automatatic lightweight migrations!

## Installation
Recommended installation is to use Bundle.r

### Bundler

Add the following to your project's `Gemfile` to work with bundler.

```ruby
gem "motion_data_wrapper"
```

Install with bundler:

```ruby
bundle install
```

## ActiveRecord Style Syntax
MotionDataWrapper offers lots of your favorite ActiveRecord features for querying and persisting objects, including the following methods.

### Querying
Most of the familiar Rails AR query methods are available, even dynamic finders, including the following:

* count
* find_all_by_**
* find_by_**
* first
* first!
* last
* last!
* limit
* offset
* order
* pluck
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
