require 'spec_helper'
require 'models/kb_map'

describe KBLine do
  let!(:subj){KBLine.new}

  it 'should init from x and y' do
    subj.isReady.should be_false
    subj.addPoint KBPoint.new
    subj.isReady.should be_false
    subj.addPoint KBPoint.new
    subj.isReady.should be_true
  end

end

describe KBPoint do
  let!(:subj){KBPoint.new}

  it 'should init from x and y' do
    [subj.init(2, 4), subj.init([2, 4])].each do |res|
      [res.x, res.y].should eq [2,4]
      res.toArray.should eq [2,4]
    end
  end


end

describe KBMap do
  before(:all) {}
  let!(:subj){ KBMap.new.loadFromFile(DATAPATH + 'maps/viewpoints.txt') }

  context ' class and methods' do
    it { should be_a KBMap }
    it { should respond_to :loadFromFile}
  end
  
  context ' visibilityGraph' do
    it ' check points' do

      subj.viewpoints.map { |e|
        e.toArray # convert point object to array of coordinates
      }.should include([2, 1], [12, 2], [7, 8], [7, 8], [12, 2], [12, 2], [11, 6], [11, 6])

      subj.viewpoints.length.should eq(subj.viewpoints.uniq{|p| p.toArray.to_s}.length)
    end

    it ' check lines' do
      subj.lines.map { |l|
        l.toArray # convert point object to array of coordinates
      }.should include([[3, 1], [11, 2]], [[7, 7], [8, 3]], [[11, 3], [11, 5]])

      subj.lines.length.should eq(subj.lines.uniq{|l| l.toArray.to_s}.length)
    end

    it ' check lines kdtree' do
      subj.kdLines.nearestk(0,0,3).map{|i| subj.lines[i].toArray}.should eq [[[3, 1], [11, 2]], [[7, 7], [8, 3]], [[7, 7], [8, 3]]]
    end

    it ' check viewpoints kdtree' do
      subj.kdViewpoints.nearestk(0,0,3).map{|i| subj.viewpoints[i].toArray}.should eq [[2, 1], [7, 8], [12, 2]]
    end
  end


  after(:all) {}
end