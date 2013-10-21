describe "MotionDataWrapper::Model dynamic finders " do

  before do
    Task.create! id: 1, title: "Duplicate"
    Task.create! id: 2, title: "Duplicate"
    Task.create! id: 3, title: "Second Task", due: NSDate.date
  end

  after do
    clean_core_data
  end

  it "#find_by_title should return only 1 of the 2 records" do
    task = Task.find_by_title "Duplicate"
    task.should.be.kind_of Task
  end

  it "#find_all_by_title should return both instances" do
    tasks = Task.find_all_by_title "Duplicate"
    tasks.should.be.instance_of Array
    tasks.count.should.be == 2
  end

  it "#fnd_by_title! should raise error if no match" do
    ->{ Task.find_by_title! "None" }.should.raise MotionDataWrapper::RecordNotFound
  end

  it "#find_all_by_title should return empty array if no matches" do
    tasks = Task.find_all_by_title "None"
    tasks.should.be.empty
  end

  it "#find_by should raise error if attribute is undefined" do
    ->{ Task.find_by_me "Unknown" }.should.raise NoMethodError
  end

  it "#find_all_by should raise error if attribute is undefined" do
    ->{ Task.find_all_by_me "Unknown" }.should.raise NoMethodError
  end
end
