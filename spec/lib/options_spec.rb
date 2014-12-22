require 'json'
require 'hashr'

describe 'neural network options' do
  it 'hiddenLayers' do
    net = Brain::NeuralNetwork.new({ hidden_layers: [8, 7] })

    net.train([{input: [0, 0], output: [0]},
               {input: [0, 1], output: [1]},
               {input: [1, 0], output: [1]},
               {input: [1, 1], output: [0]}])

    json = net.to_json
    json = JSON.parse json
    json.deep_symbolize_keys!

    expect(json[:layers].length).to eq(4)
    expect(json[:layers][1].length).to eq(8)
    expect(json[:layers][2].length).to eq(7)
  end

  it 'hiddenLayers default expand to input size' do
    net = Brain::NeuralNetwork.new()

    net.train([{input: [0, 0, 1, 1, 1, 1, 1, 1, 1], output: [0]},
               {input: [0, 1, 1, 1, 1, 1, 1, 1, 1], output: [1]},
               {input: [1, 0, 1, 1, 1, 1, 1, 1, 1], output: [1]},
               {input: [1, 1, 1, 1, 1, 1, 1, 1, 1], output: [0]}])

    json = net.to_json
    json = JSON.parse json
    json.deep_symbolize_keys!

    expect(json[:layers].length).to eq(3)
    expect(json[:layers][1].length).to eq(4)
  end


  it 'learning_rate - higher learning rate should train faster' do
    data = [{input: [0, 0], output: [0]},
            {input: [0, 1], output: [1]},
            {input: [1, 0], output: [1]},
            {input: [1, 1], output: [1]}]

    net1 = Brain::NeuralNetwork.new()
    iters1 = net1.train(data, learning_rate: 0.5)[:iterations]

    net2 = Brain::NeuralNetwork.new()
    iters2 = net2.train(data, learning_rate: 0.8)[:iterations]

    expect(iters1).to be > (iters2 * 1.1)
  end

  it 'learning_rate - backwards compatibility' do
    data = [{input: [0, 0], output: [0]},
            {input: [0, 1], output: [1]},
            {input: [1, 0], output: [1]},
            {input: [1, 1], output: [1]}]

    net1 = Brain::NeuralNetwork.new(learning_rate: 0.5)
    iters1 = net1.train(data)[:iterations]

    net2 = Brain::NeuralNetwork.new(learning_rate: 0.8)
    iters2 = net2.train(data)[:iterations]

    expect(iters1).to be > (iters2 * 1.1)
  end

  it 'momentum - higher momentum should train faster' do
    data = [{input: [0, 0], output: [0]},
            {input: [0, 1], output: [1]},
            {input: [1, 0], output: [1]},
            {input: [1, 1], output: [1]}]

    net1 = Brain::NeuralNetwork.new(momentum: 0.1)
    iters1 = net1.train(data)[:iterations]

    net2 = Brain::NeuralNetwork.new(momentum: 0.5)
    iters2 = net2.train(data)[:iterations]

    expect(iters1).to be > (iters2 * 1.1)
  end
end
