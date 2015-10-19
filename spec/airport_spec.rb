describe Airport do

  let(:plane) { double :plane, land: :landed, take_off: :flying }
  let(:plane_2) { double :plane_2, land: :landed, take_off: :flying }
  let(:weather) { double :weather }
  subject(:airport) { described_class.new }
  before do
    allow(subject).to receive(:weather_report) { :sunny }
  end

  it { is_expected.to respond_to(:clear_for_landing).with(2).argument }
  it { is_expected.to respond_to(:clear_for_takeoff).with(2).argument }
  it { is_expected.to respond_to(:weather_report).with(1).argument }

  describe "#planes" do
    it "returns all the planes at the airport" do
      subject.clear_for_landing(plane, weather)
      expect(airport.planes).to contain_exactly(plane)
    end
  end

  describe "#capacity" do
    it "returns capacity of airport" do
      expect(Airport.new(67).capacity).to eq(67)
    end
  end

  describe "#weather_report" do
    it "calls a method from the weather class" do
      expect(airport.weather_report).to eq(:stormy).or eq(:sunny)
    end
  end

  context "when the weather is stormy" do
    describe "#clear_for_landing(plane)" do
      it "cannot accept planes" do
        allow(airport).to receive(:weather_report) { :stormy }
        expect{ airport.clear_for_landing(plane, weather) }.
          to raise_error('Too stormy')
      end
    end

    describe "#clear_for_takeoff(plane)" do
      it "doesn't allow plane to take off" do
        subject.clear_for_landing(plane, weather)
        allow(airport).to receive(:weather_report) { :stormy }
        expect { airport.clear_for_takeoff(plane, weather) }.
          to raise_error('Too stormy')
      end
    end
  end

  context "when the weather is sunny" do
    context "when it's full" do
      describe "#clear_for_landing(plane)" do
        it "cannot accept planes more than its capacity" do
          50.times { airport.clear_for_landing(plane, weather) }
          expect { airport.clear_for_landing(plane, weather) }.
            to raise_error('Airport full')
        end
      end
    end

    context "when it's empty" do
      describe "#clear_for_takeoff(plane)" do
        it "cannot instruct a plane to take off" do
          expect { airport.clear_for_takeoff(plane, weather) }.
            to raise_error('Airport empty')
        end
      end
    end

    context "when it's not full" do
      describe "#clear_for_landing(plane)" do
        it "accepts a plane" do
          my_plane = airport.clear_for_landing(plane, weather).last
          expect(my_plane).to eq(plane)
        end
        it "changes plane status to :landed" do
          my_plane = airport.clear_for_landing(plane, weather).last
          allow(my_plane).to receive(:plane_status) { :landed }
          expect(my_plane.plane_status).to eq(:landed)
        end
      end

      describe "#clear_for_takeoff(plane)" do
        it "instructs a specific plane to take off" do
          airport.clear_for_landing(plane, weather)
          airport.clear_for_landing(plane_2, weather)
          expect(airport.clear_for_takeoff(plane, weather)).to eq(plane)
        end
        it "changes plane status to :flying" do
          airport.clear_for_landing(plane, weather)
          allow(plane).to receive(:plane_status) { :flying }
          expect(plane.plane_status).to eq(:flying)
        end
        it "removes the specific plane from airport" do
          airport.clear_for_landing(plane, weather)
          airport.clear_for_takeoff(plane, weather)
          expect(airport.planes).not_to contain_exactly(plane)
        end
      end
    end
  end
end
