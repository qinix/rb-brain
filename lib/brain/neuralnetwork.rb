require 'brain/lookup'
require 'json'
require 'pry'
require 'hashr'

module Brain
  class NeuralNetwork
    def initialize(options = {})
      @learning_rate = options[:learning_rate] || 0.3
      @momentum = options[:momentum] || 0.1
      @hidden_sizes = options[:hidden_layers]
      @binary_thresh = options[:binary_thresh] || 0.5
    end

    def init(sizes)
      @sizes = sizes
      @output_layer = @sizes.length - 1

      @biases = [] # weights for bias nodes
      @weights = []
      @outputs = []

      # state for training
      @deltas = []
      @changes = [] # for momentum
      @errors = []

      (0..@output_layer).each do |layer|
        size = @sizes[layer]
        @deltas[layer] = Array.new size, 0
        @errors[layer] = Array.new size, 0
        @outputs[layer] = Array.new size, 0

        if layer > 0
          @biases[layer] = randos size
          @weights[layer] = Array.new size
          @changes[layer] = Array.new size

          (0...size).each do |node|
            prev_size = @sizes[layer - 1]
            @weights[layer][node] = randos prev_size
            @changes[layer][node] = Array.new prev_size, 0
          end
        end
      end
    end

    def run(input)
      input = Lookup.to_array(@input_lookup, input) if @input_lookup

      output = run_input input
      output = Lookup.to_hash(@output_lookup, output) if @output_lookup

      output
    end

    def run_input(input)
      @outputs[0] = input
      output = 0

      (1..@output_layer).each do |layer|
        (0...@sizes[layer]).each do |node|
          weights = @weights[layer][node]

          sum = @biases[layer][node]
          (0...weights.length).each do |k|
            sum += weights[k] * input[k]
          end
          @outputs[layer][node] = 1 / (1 + Math.exp(-sum))
        end
        output = input = @outputs[layer]
      end

      output
    end

    def train(data, options = {})
      data = format_data data

      iterations = options[:iterations] || 20000
      error_thresh = options[:error_thresh] || 0.003
      log = options[:log] || false
      log_period = options[:log_period] || 10
      learning_rate = options[:learning_rate] || @learning_rate || 0.3

      input_size = data[0][:input].length
      output_size = data[0][:output].length

      hidden_sizes = @hidden_sizes
      hidden_sizes = [[3, (input_size / 2.0).floor].max] unless hidden_sizes
      sizes = [input_size, hidden_sizes, output_size].flatten
      init sizes

      error = 1
      done_iterations = iterations
      (0...iterations).each do |i|
        unless error > error_thresh
          done_iterations = i
          break
        end
        sum = 0
        data.each do |d|
          err = train_pattern d[:input], d[:output], learning_rate
          sum += err
        end
        error = sum / data.length

        puts "iterations: #{i}, training error: #{error}" if log and (i % log_period == 0)
      end

      {
        error: error,
        iterations: done_iterations
      }
    end

    def train_pattern(input, target, learning_rate)
      learning_rate ||= @learning_rate

      # forward propogate
      run_input input
      calculate_deltas target
      adjust_weights learning_rate

      mse @errors[@output_layer]
    end

    def calculate_deltas(target)
      (0..@output_layer).to_a.reverse.each do |layer|
        (0...@sizes[layer]).each do |node|
          output = @outputs[layer][node]

          error = 0
          if layer == @output_layer
            error = target[node] - output
          else
            deltas = @deltas[layer + 1]
            (0...deltas.length).each do |k|
              error += deltas[k] * @weights[layer + 1][k][node]
            end
          end
          @errors[layer][node] = error
          @deltas[layer][node] = error * output * (1 - output)
        end
      end
    end

    def adjust_weights(learning_rate)
      (1..@output_layer).each do |layer|
        incoming = @outputs[layer - 1]

        (0...@sizes[layer]).each do |node|
          delta = @deltas[layer][node]

          (0...incoming.length).each do |k|
            change = @changes[layer][node][k]

            change = (learning_rate * delta * incoming[k]) + (@momentum * change)

            @changes[layer][node][k] = change
            @weights[layer][node][k] += change
          end
          @biases[layer][node] += learning_rate * delta
        end
      end
    end

    def format_data(data)
      unless data.is_a? Array
        data = [data]
      end

      #turn sparse hash input into arrays with 0s as filler
      unless data[0][:input].is_a? Array
        @input_lookup = Lookup.build_lookup data.map {|d| d[:input]} unless @input_lookup
        data.map! do |datum|
          array = Lookup.to_array @input_lookup, datum[:input]
          datum.merge({ input: array })
        end
      end

      unless data[0][:output].is_a? Array
        @output_lookup = Lookup.build_lookup data.map {|d| d[:output]} unless @output_lookup
        data.map! do |datum|
          array = Lookup.to_array @output_lookup, datum[:output]
          datum.merge({ output: array })
        end
      end

      data
    end

    def to_json
      # make json look like:
      # {
      #   layers: [
      #     { x: {},
      #       y: {}},
      #     {'0': {bias: -0.98771313, weights: {x: 0.8374838, y: 1.245858},
      #      '1': {bias: 3.48192004, weights: {x: 1.7825821, y: -2.67899}}},
      #     { f: {bias: 0.27205739, weights: {'0': 1.3161821, '1': 2.00436}}}
      #   ]
      # }
      layers = []
      (0..@output_layer).each do |layer|
        layers[layer] = {}

        if layer == 0 and @input_lookup
          nodes = @input_lookup.keys
        elsif layer == @output_layer and @output_lookup
          nodes = @output_lookup.keys
        else
          nodes = (0...@sizes[layer]).to_a
        end

        (0...nodes.length).each do |j|
          node = nodes[j]
          layers[layer][node] = {}

          if layer > 0
            layers[layer][node][:bias] = @biases[layer][j]
            layers[layer][node][:weights] = {}
            layers[layer - 1].each do |k,v|
              index = k
              if layer == 1 and @input_lookup
                index = @input_lookup[k]
              end
              layers[layer][node][:weights][k] = @weights[layer][j][index]
            end
          end
        end
      end

      {
        layers: layers,
        output_lookup: !!@output_lookup,
        input_lookup: !!@input_lookup
      }.to_json
    end

    def from_json(json)
      json = JSON.parse(json).deep_symbolize_keys
      size = json[:layers].length


      @output_layer = size - 1
      @sizes = Array.new size
      @weights = Array.new size
      @biases = Array.new size
      @outputs = Array.new size

      (0..@output_layer).each do |i|
        layer = json[:layers][i]
        if i == 0 and (!layer[0] or json[:input_lookup])
          @input_lookup = Lookup.lookup_from_hash layer
        elsif i == @output_layer and (!layer[0] or json[:output_lookup])
          @output_lookup = Lookup.lookup_from_hash layer
        end

        nodes = layer.keys
        @sizes[i] = nodes.length
        @weights[i] = []
        @biases[i] = []
        @outputs[i] = []

        (0...nodes.length).each do |j|

          node = nodes[j]
          @biases[i][j] = layer[node][:bias]
          @weights[i][j] = layer[node][:weights]
          @weights[i][j] = @weights[i][j].values unless @weights[i][j].nil?
        end
      end
    end

  private
    def random_weight
      Random.rand * 0.4 - 0.2
    end

    def randos(size)
      array = Array.new size
      array.map! {|item| item = random_weight}
    end

    def mse(errors)
      # mean squared error
      sum = 0
      errors.each do |e|
        sum += e ** 2
      end
      sum / errors.length
    end
  end
end
