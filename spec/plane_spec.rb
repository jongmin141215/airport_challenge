describe Plane do
  it { is_expected.to respond_to(:take_off) }
  it { is_expected.to respond_to(:land) }

  describe "#take_off" do
    it "changes plane status to :flying" do
      expect(subject.take_off).to eq(:flying)
    end
  end

  describe "#land" do
    it "changes plane status to :landed" do
      expect(subject.land).to eq(:landed)
    end
  end

  it 'can check plane status' do
    subject.land
    expect(subject.plane_status).to eq(:landed)
  end
end
