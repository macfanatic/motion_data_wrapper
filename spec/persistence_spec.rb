# -*- coding: utf-8 -*-
describe MotionDataWrapper::Model do

  before do
    @delegate = App.delegate
  end

  after do
    clean_core_data
  end
  
  it "should create task" do
    Task.create title:"Task1"
    Task.all.size.should == 1
  end
  
  it "should be stored to app support dir" do
    # prepare directory
    manager = NSFileManager.defaultManager
    dir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true)[0]
    manager.createDirectoryAtPath dir, withIntermediateDirectories:true, attributes:nil, error:nil

    # set store path
    path = File.join(dir, "#{@delegate.sqlite_store_name}.sqlite")
    @delegate.sqlite_path = path

    # write a data
    Task.create title:"Task1"

    manager.fileExistsAtPath(path).should == true
  end
  
end
