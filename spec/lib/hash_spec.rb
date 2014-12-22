describe 'hash input and output' do
  before :each do
    @net = Brain::NeuralNetwork.new
  end

  it 'runs correctly with array input and output' do
    @net.train([{input: { x: 0, y: 0 }, output: [0]},
                      {input: { x: 0, y: 1 }, output: [1]},
                      {input: { x: 1, y: 0 }, output: [1]},
                      {input: { x: 1, y: 1 }, output: [0]}])
    output = @net.run({x: 1, y: 0})

    expect(output[0]).to be > 0.9
  end

  it 'runs correctly with hash input' do
    @net.train([{input: { x: 0, y: 0 }, output: [0]},
               {input: { x: 0, y: 1 }, output: [1]},
               {input: { x: 1, y: 0 }, output: [1]},
               {input: { x: 1, y: 1 }, output: [0]}])
    output = @net.run({x: 1, y: 0})

    expect(output[0]).to be > 0.9
  end

  it 'runs correctly with hash output' do
    @net.train([{input: [0, 0], output: { answer: 0 }},
               {input: [0, 1], output: { answer: 1 }},
               {input: [1, 0], output: { answer: 1 }},
               {input: [1, 1], output: { answer: 0 }}])

    output = @net.run([1, 0])

    expect(output[:answer]).to be > 0.9
  end

  it 'runs correctly with hash input and output' do
    @net.train([{input: { x: 0, y: 0 }, output: { answer: 0 }},
               {input: { x: 0, y: 1 }, output: { answer: 1 }},
               {input: { x: 1, y: 0 }, output: { answer: 1 }},
               {input: { x: 1, y: 1 }, output: { answer: 0 }}])

    output = @net.run({x: 1, y: 0})

    expect(output[:answer]).to be > 0.9
  end

  it 'runs correctly with sparse hashes' do
      @net.train([{input: {}, output: {}},
                 {input: { y: 1 }, output: { answer: 1 }},
                 {input: { x: 1 }, output: { answer: 1 }},
                 {input: { x: 1, y: 1 }, output: {}}])


      output = @net.run({x: 1})

      expect(output[:answer]).to be > 0.9
  end

  it 'runs correctly with unseen input' do
      @net.train([{input: {}, output: {}},
                 {input: { y: 1 }, output: { answer: 1 }},
                 {input: { x: 1 }, output: { answer: 1 }},
                 {input: { x: 1, y: 1 }, output: {}}])

      output = @net.run({x: 1, z: 1})

      expect(output[:answer]).to be > 0.9
  end
end
