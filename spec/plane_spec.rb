describe Plane do

  subject(:plane) { described_class.new }
  it { is_expected.to respond_to(:take_off) }
  it { is_expected.to respond_to(:land) }

  describe "#take_off" do
    it "changes plane status to :flying" do
      expect(plane.take_off).to eq(:flying)
    end
  end

  describe "#land" do
    it "changes plane status to :landed" do
      expect(plane.land).to eq(:landed)
    end
  end

  it 'can check plane status' do
    plane.land
    expect(plane.plane_status).to eq(:landed)
  end
end
