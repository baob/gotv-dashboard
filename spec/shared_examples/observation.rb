RSpec.shared_examples 'observation' do
  # Assumption: subject is already set

  specify { expect(described_class).to respond_to(:observed_for) }
  specify { expect(subject).to respond_to(:past_counts) }
end
  