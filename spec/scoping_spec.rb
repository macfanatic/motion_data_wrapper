describe 'MotionDataWrapper::Model scoping' do

  after do
    clean_core_data
  end

  describe 'starting from class' do
    it "#scope should define a class method" do
      Task.should.respond_to :mine
    end

    it "#scope should expect a symbol as the first argument" do
      should.raise(ArgumentError) { Task.send :scope, 'string', ->{} }
    end

    it "#scope should expect a proc as the second argument" do
      should.raise(ArgumentError) { Task.send :scope, :symbol, nil }
    end

    it "class method should return a relation" do
      Task.mine.class.should.be == MotionDataWrapper::Relation
    end

    it "should be able to define scope with arguments" do
      Task.create! title: "My Task"
      Task.should.respond_to :with_title

      relation = Task.with_title("task")
      relation.count.should.be == 1
    end
  end

  describe 'scoping a relation' do
    before do
      Task.create! due: NSDate.dateWithTimeIntervalSinceNow(-86400), title: "Yesterday Task"
      Task.create! due: NSDate.dateWithTimeIntervalSinceNow(86400), title: "Tommorrow Task"
    end

    it "should allow chaining" do
      relation = Task.with_title("task")

      relation.count.should.be == 2
      relation.overdue.count.should.be == 1
    end
  end

  describe 'redefing existing method' do
    it "should raise error if redefining existing class method" do
      should.raise(ArgumentError) { Task.send :scope, :create, ->{} }
    end

    it "should raise error if redefining existing instance method on Relation" do
      # Task.first! does not exist, but does exist on relation
      should.raise(ArgumentError) { Task.send :scope, :first!, ->{} }
    end
  end
end

class Task
  scope :mine,        ->{ where "title = ?", "My Task" }
  scope :with_title,  ->(title) { where "title contains[cd] ?", title }
  scope :overdue,     ->{ where "due < ?", NSDate.date }
end
