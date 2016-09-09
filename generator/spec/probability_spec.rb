require 'rspec'
require_relative '../statistical_generator'

describe Statistics::Generator do
  describe '#weighted_by' do
    def sample(array, attribute)
      subject.weighted_by(array, attribute)
    end

    let(:one){ SimpleType.new(1) }
    let(:two){ SimpleType.new(2) }

    it { expect(sample([], :foo)).to eq [] }
    it { expect(sample([one], :foo)).to eq [one] }
    it { expect(sample([one, one], :foo)).to eq [one, one] }
    it { expect(sample([one, two], :foo)).to eq [one, two, two] }
  end
end

class SimpleType
  attr_reader :foo
  def initialize value
    @foo = value
  end
end