# -*- coding: utf-8 -*-
describe MotionDataWrapper::Model do

  before do
    @task = Task.create! title: "Matt", id: 1
  end

  after do
    clean_core_data
  end

  describe '#all' do

    before do
      @task2 = Task.create! title: "Second Task"
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
end

def task_relation_without_matches
  Task.where('title contains[cd] ?', 'no records')
end
