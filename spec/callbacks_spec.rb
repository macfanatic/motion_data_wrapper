# -*- coding: utf-8 -*-
describe MotionDataWrapper::Model do

  after do
    clean_core_data
  end
  
  it "should callbacked save and create when a new record was saved" do
    task = Task.new title:"Task1"
    task.save!.should == true
    task.callbacks.should == %w(before_save before_create after_create after_save)
  end
  
  it "should callbacked save and create when a new record was created" do
    task = Task.create title:"Task1"
    task.callbacks.should == %w(before_save before_create after_create after_save)
  end
  
  it "should callbacked save and update when the record was updated" do
    task = Task.create title:"Task1"
    task.clear_callbacks
    task.title = "Task2"
    task.save
    task.callbacks.should == %w(before_save before_update after_update after_save)
  end
  
  it "should callbacked destroy when the record was destroyed" do
    task = Task.create title:"Task1"
    task.clear_callbacks
    task.destroy
    task.callbacks.should == %w(before_destroy after_destroy)
  end
  
end

class Task
  attr_reader :callbacks

  def callbacks
    @callbacks ||= []
  end
  
  def clear_callbacks
    @callbacks = nil
  end
  
  def before_create
    callbacks << "before_create"
  end
  
  def after_create
    callbacks << "after_create"
  end
  
  def before_save
    callbacks << "before_save"
  end
  
  def after_save
    callbacks << "after_save"
  end
  
  def before_update
    callbacks << "before_update"
  end
  
  def after_update
    callbacks << "after_update"
  end
  
  def before_destroy
    callbacks << "before_destroy"
  end
  
  def after_destroy
    callbacks << "after_destroy"
  end
  
end
