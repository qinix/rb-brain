data = [{input: [0, 0], output: [0]},
        {input: [0, 1], output: [1]},
        {input: [1, 0], output: [1]},
        {input: [1, 1], output: [1]}]

describe 'train() options' do
  before :each do
    @net = Brain::NeuralNetwork.new
  end

  it 'train until error threshold reached' do
    error = @net.train(data,
      errorThresh: 0.2,
      iterations: 100000)[:error]

    expect(error).to be < 0.2
  end

  it 'train until max iterations reached' do
    stats = @net.train(data,
      errorThresh: 0.001,
      iterations: 1)

    expect(stats[:iterations]).to eq(1)
  end
end
