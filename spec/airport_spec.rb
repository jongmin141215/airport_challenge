describe Airport do

  let(:plane) { double :plane, land: :landed, take_off: :flying }
  let(:plane_2) { double :plane_2, land: :landed, take_off: :flying }
  let(:weather) { double :weather }

  before do
    allow(subject).to receive(:weather_report) { :sunny }
  end

  it { is_expected.to respond_to(:clear_for_landing).with(2).argument }
  it { is_expected.to respond_to(:clear_for_takeoff).with(2).argument }
  it { is_expected.to respond_to(:weather_report).with(1).argument }

  describe "#planes" do
    it "returns all the planes at the airport" do
      subject.clear_for_landing(plane, weather)
      expect(subject.planes).to contain_exactly(plane)
    end
  end

  describe "#capacity" do
    it "returns capacity of airport" do
      expect(Airport.new(67).capacity).to eq(67)
    end
  end

  describe "#weather_report" do
    it "calls a method from the weather class" do
      expect(subject.weather_report).to eq(:stormy).or eq(:sunny)
    end
  end

  context "when the weather is stormy" do
    describe "#clear_for_landing(plane)" do
      it "cannot accept planes" do
        allow(subject).to receive(:weather_report) { :stormy }
        expect{ subject.clear_for_landing(plane, weather) }.
          to raise_error('Too stormy')
      end
    end

    describe "#clear_for_takeoff(plane)" do
      it "doesn't allow plane to take off" do
        subject.clear_for_landing(plane, weather)
        allow(subject).to receive(:weather_report) { :stormy }
        expect { subject.clear_for_takeoff(plane, weather) }.
          to raise_error('Too stormy')
      end
    end
  end

  context "when the weather is sunny" do
    context "when it's full" do
      describe "#clear_for_landing(plane)" do
        it "cannot accept planes more than its capacity" do
          50.times { subject.clear_for_landing(plane, weather) }
          expect { subject.clear_for_landing(plane, weather) }.
            to raise_error('Airport full')
        end
      end
    end

    context "when it's empty" do
      describe "#clear_for_takeoff(plane)" do
        it "cannot instruct a plane to take off" do
          expect { subject.clear_for_takeoff(plane, weather) }.
            to raise_error('Airport empty')
        end
      end
    end

    context "when it's not full" do
      describe "#clear_for_landing(plane)" do
        it "accepts a plane" do
          my_plane = subject.clear_for_landing(plane, weather).last
          expect(my_plane).to eq(plane)
        end
        it "changes plane status to :landed" do
          my_plane = subject.clear_for_landing(plane, weather).last
          allow(my_plane).to receive(:plane_status) { :landed }
          expect(my_plane.plane_status).to eq(:landed)
        end
      end

      describe "#clear_for_takeoff(plane)" do
        it "instructs a specific plane to take off" do
          subject.clear_for_landing(plane, weather)
          subject.clear_for_landing(plane_2, weather)
          expect(subject.clear_for_takeoff(plane, weather)).to eq(plane)
        end
        it "changes plane status to :flying" do
          subject.clear_for_landing(plane, weather)
          allow(plane).to receive(:plane_status) { :flying }
          expect(plane.plane_status).to eq(:flying)
        end
        it "removes the specific plane from airport" do
          subject.clear_for_landing(plane, weather)
          subject.clear_for_takeoff(plane, weather)
          expect(subject.planes).not_to contain_exactly(plane)
        end
      end
    end
  end
end
