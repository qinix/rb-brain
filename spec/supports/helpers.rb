module Helpers
  def test_bitwise(data, op)
    wiggle = 0.1

    net = Brain::NeuralNetwork.new
    net.train(data, error_thresh: 0.003)

    data.each do |item|
      output = net.run(item[:input])
      target = item[:output]
      expect(output[0]).to be_within(wiggle).of(target[0])
    end
  end
end
