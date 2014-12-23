# rb-brain

`rb-brain` is an easy-to-use [neural network](http://en.wikipedia.org/wiki/Artificial_neural_network) library written in Ruby. Here's an example of using it to approximate the XOR function:

```ruby
require 'brain'

net = Brain::NeuralNetwork.new

net.train([{input: [0, 0], output: [0]},
           {input: [0, 1], output: [1]},
           {input: [1, 0], output: [1]},
           {input: [1, 1], output: [0]}])

output = net.run([1, 0])  # [0.948]
```

## Installation

Install the latest release:

    gem install rb-brain

Require it in your code:

    require 'brain'

Or, you can add it to your Gemfile:

    gem 'rb-brain', :require => 'brain'

## Training
Use `train()` to train the network with an array of training data. The network has to be trained with all the data in bulk in one call to `train()`. The more training patterns, the longer it will probably take to train, but the better the network will be at classifiying new patterns.

#### Data format
Each training pattern should have an `input` and an `output`, both of which can be either an array of numbers from `0` to `1` or a hash of numbers from `0` to `1`. For hash it looks something like this:

```ruby
require 'brain'

net = Brain::NeuralNetwork.new

net.train([{input: {x: 0,y: 0}, output: {result: 0}},
           {input: {x: 0,y: 1}, output: {result: 1}},
           {input: {x: 1,y: 0}, output: {result: 1}},
           {input: {x: 1,y: 1}, output: {result: 0}}])

output = net.run({x: 1,y: 0})  # {result: 0.948}
```

#### Options
`train()` takes a hash of options as its second argument:

```ruby
net.train(data,
  error_thresh: 0.005,  # error threshold to reach
  iterations: 20000,    # maximum training iterations
  log: true,            # print progress periodically
  log_period: 10,       # number of iterations between logging
  learning_rate: 0.3    # learning rate
)
```

The network will train until the training error has gone below the threshold (default `0.003`) or the max number of iterations (default `20000`) has been reached, whichever comes first.

By default training won't let you know how its doing until the end, but set `log` to `true` to get periodic updates on the current training error of the network. The training error should decrease every time.

The learning rate is a parameter that influences how quickly the network trains. It's a number from `0` to `1`. If the learning rate is close to `0` it will take longer to train. If the learning rate is closer to `1` it will train faster but it's in danger of training to a local minimum and performing badly on new data. The default learning rate is `0.3`.

#### Output
The output of `train()` is a hash of information about how the training went:

```ruby
{
  error: 0.0039139985510105032,  # training error
  iterations: 406                # training iterations
}
```

#### Failing
If the network failed to train, the error will be above the error threshold. This could happen because the training data is too noisy (most likely), the network doesn't have enough hidden layers or nodes to handle the complexity of the data, or it hasn't trained for enough iterations.

If the training error is still something huge like `0.4` after 20000 iterations, it's a good sign that the network can't make sense of the data you're giving it.

## JSON
Serialize or load in the state fo a trained network with JSON:

```ruby
json = net.to_json

net.from_json(json)
```

## Options
`NeuralNetwork` takes a hash of options:

```ruby
net = Brain::NeuralNetwork.new(
  hidden_layers: [4],
  learning_rate: 0.6 # global learning rate
)
```

#### hidden_ayers
Specify the number of hidden layers in the network and the size of each layer. For example, if you want two hidden layers - the first with 3 nodes and the second with 4 nodes, you'd give:

```
hidden_layers: [3, 4]
```

By default `brain` uses one hidden layer with size proportionate to the size of the input array.

## Tests
To run the tests, make sure you've installed the dependencies with this command:

```
bundle install
```

Then you can run all tests using `rake`

# Acknowledgement
I learned a lot from [harthur/brain](https://github.com/harthur/brain), Most of the code is rewritten from this repo. I would like to thank the author of the repo.
