describe 'bitwase functions' do
  it 'NOT function' do
    data_not = [{input: [0], output: [1]},
           {input: [1], output: [0]}]
    test_bitwise data_not, 'not'
  end

  it 'XOR function' do
    data_xor = [{input: [0, 0], output: [0]},
           {input: [0, 1], output: [1]},
           {input: [1, 0], output: [1]},
           {input: [1, 1], output: [0]}]
    test_bitwise data_xor, 'xor'
  end

  it 'OR function' do
    data_or = [{input: [0, 0], output: [0]},
          {input: [0, 1], output: [1]},
          {input: [1, 0], output: [1]},
          {input: [1, 1], output: [1]}]
    test_bitwise data_or, 'or'
  end

  it 'AND function' do
    data_and = [{input: [0, 0], output: [0]},
           {input: [0, 1], output: [0]},
           {input: [1, 0], output: [0]},
           {input: [1, 1], output: [1]}]
    test_bitwise data_and, 'and'
  end
end
