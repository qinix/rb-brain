describe 'JSON' do
  it 'to_json()/from_json()' do
    net = Brain::NeuralNetwork.new

    net.train([{input:  {a: Random.rand, b: Random.rand},
                output: {c: Random.rand, a: Random.rand}},
               {input:  {a: Random.rand, b: Random.rand},
                output: {c: Random.rand, a: Random.rand}}])

    json = net.to_json()
    net2 = Brain::NeuralNetwork.new
    net2.from_json json

    input = {a: Random.rand, b: Random.rand}

    output1 = net.run(input)
    output2 = net2.run(input)

    expect(output1).to eq output2
  end
end
