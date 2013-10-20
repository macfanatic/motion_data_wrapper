# -*- coding: utf-8 -*-
describe MotionDataWrapper::Model do

  before do
    @task = Task.create! title: "First Task", id: 1
  end

  after do
    clean_core_data
  end

  describe '#all' do
    before { @task2 = Task.create! title: "Second Task" }

    it "should return an array" do
      Task.all.should.be.instance_of Array
    end

    it "should return 2 tasks" do
      Task.all.should == [@task, @task2]
    end

    it "should return 2 records from a relation" do
      Task.limit(10).all.should == [@task, @task2]
    end
  end

  describe '#count' do
    it "should return 1 for the only task" do
      Task.count.should == 1
    end

    it "should return 2 when there are 2 tasks" do
      Task.create!
      Task.count.should == 2
    end

    it "should return 0 when there are no matching records" do
      task_relation_without_matches.count.should == 0
    end
  end

  describe '#destroy_all' do
    it "should destroy all matched results" do
      task = Task.create! id: 2

      Task.where("id = ?", task.id).destroy_all
      Task.where("id = ?", task.id).count.should == 0
    end
  end

  describe '#empty' do
    it "should not be empty when there are records" do
      Task.should.not.be.empty
    end

    it "should be empty when there are not matching records" do
      task_relation_without_matches.count.should == 0
      task_relation_without_matches.empty?.should.be == true
    end
  end

  describe '#except' do
    it "should allow ignoring :limit" do
      relation = Task.limit(1)
      relation.fetchLimit.should.be == 1

      relation.except(:limit).fetchLimit.should.be == 0
    end

    it "should allow ignoring :order" do
      relation = Task.order(:title)
      relation.sortDescriptors.should.not.be.empty

      relation.except(:order).sortDescriptors.should.be.nil
    end

    it "should raise error if type is unknown" do
      relation = Task.limit(1)
      ->{ relation.except(:garbage) }.should.raise ArgumentError
    end
  end

  describe '#exists' do
    it "should be true when there are records" do
      Task.should.be.exists
    end

    it "should be false when there are no records" do
      task_relation_without_matches.count.should == 0
      task_relation_without_matches.exists?.should.be == false
    end
  end

  describe '#find' do
    it "should raise exception when object_id does not exist" do
      ->{ Task.find(100) }.should.raise MotionDataWrapper::RecordNotFound
    end

    it "should return task when queried" do
      Task.find(@task.id).should == @task
    end
  end

  describe '#first' do
    it "should return the only task" do
      Task.first.should == @task
    end

    it "should return 1 task from a relation" do
      Task.limit(10).first.should == @task
    end

    it "should return nil if no matching records" do
      task_relation_without_matches.first.should.be.nil?
    end

    it "should raise exception if called with bang" do
      ->{ task_relation_without_matches.first! }.should.raise MotionDataWrapper::RecordNotFound
    end
  end
  
  describe '#last' do
    it "should return the only task" do
      Task.last.should == @task
    end

    it "should return 1 task from a relation" do
      Task.limit(10).last.should == @task
    end

    it "should return nil if no matching records" do
      task_relation_without_matches.last.should.be.nil?
    end

    it "should raise exception if called with bang" do
      ->{ task_relation_without_matches.last! }.should.raise MotionDataWrapper::RecordNotFound
    end
  end

  describe '#limit' do
    before { Task.create! }

    it "should only return 1 task" do
      Task.count.should == 2
      Task.limit(1).count.should == 1
    end

    it "should raise error if limit is less than zero" do
      ->{ Task.limit(-1) }.should.raise ArgumentError
    end

    it "should return all records if limit is set to 0" do
      Task.limit(0).count.should == 2
    end
  end

  describe '#offset' do
    before { @task2 = Task.create! }

    it "should return the 2nd task when using offset" do
      Task.offset(1).first.should == @task2
    end

    it "should raise error if limit is less than zero" do
      ->{ Task.offset(-1) }.should.raise ArgumentError
    end

    it "should return all records if offset is set to 0" do
      Task.offset(0).count.should == 2
    end

    it "should return no tasks if the offset is too high" do
      Task.offset(100).all.should.be.empty
    end
  end

  describe 'ordering' do
    before { @task2 = Task.create! title: "A task before 'First Post'" }

    it "should use default ordering to return by CoreData created by" do
      Task.all.should.be == [@task, @task2]
    end

    it "should default to ascending when specifying an order" do
      Task.order(:title).all.should.be == [@task2, @task]
    end

    it "should allow ordering by title asc" do
      Task.order(:title, ascending: true).all.should.be == [@task2, @task]
    end

    it "should allow ordering by title desc" do
      Task.order(:title, ascending: false).all.should.be == [@task, @task2]
    end

    it "should allow you to reorder a relation" do
      relation = Task.order(:title, ascending: false)
      relation.all.should.be == [@task, @task2]

      relation.reorder(:title).all.should.be == [@task2, @task]
    end
  end

  describe '#pluck' do
    it "should return array of titles" do
      titles = Task.pluck(:title)
      titles.should.be.instance_of Array
      titles.should.include "First Task"
    end

    it "should raise error if attribute does not exist" do
      ->{ Task.pluck(:unknown) }.should.raise ArgumentError
    end
  end

  describe '#uniq' do
    it "should return uniq title" do
      @duplicate_task = Task.create! title: "First Task"
      Task.pluck(:title).should == ["First Task", "First Task"]
      Task.uniq.pluck(:title).should == ["First Task"]
    end
  end
end

def task_relation_without_matches
  Task.where('title contains[cd] ?', 'no records')
end
