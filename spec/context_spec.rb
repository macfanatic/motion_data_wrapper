describe 'MotionDataWrapper::Model context support' do
  before do
    @second_context = NSManagedObjectContext.alloc.init
    @second_context.persistentStoreCoordinator = App.delegate.persistentStoreCoordinator

    # Add a task to the main context, just don't save the context
    # If saved, then @second_context would have the task from the persistent store
    @task = Task.new
    App.delegate.managedObjectContext.insertObject @task
  end

  after do
    clean_core_data
  end

  describe '#with_context' do
    it "should return task from second context only" do
      Task.with_context(@second_context).all.should.be.empty

      new_task = Task.new
      @second_context.insertObject new_task

      Task.with_context(@second_context).all.should.be == [new_task]
      Task.limit(1).with_context(@second_context).all.should.be == [new_task]
    end
  end
end
