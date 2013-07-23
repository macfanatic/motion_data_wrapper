# -*- coding: utf-8 -*-
describe MotionDataWrapper::Model do

  after do
    clean_core_data
  end
  
  it "should create task" do
    Task.create title:"Task1"
    Task.all.size.should == 1
  end
  
end
