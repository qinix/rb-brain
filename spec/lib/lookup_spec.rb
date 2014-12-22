describe 'Lookup' do
  it 'lookup_from_hash()' do
    lup = Brain::Lookup.lookup_from_hash({ a: 6, b: 7, c: 8 })

    expect(lup).to eq({ a: 0, b: 1, c: 2})
  end

  it 'build_lookup()' do
    lup = Brain::Lookup.build_lookup([{ x: 0, y: 0 },
                               { x: 1, z: 0 },
                               { q: 0 },
                               { x: 1, y: 1 }])

    expect(lup).to eq({ x: 0, y: 1, z: 2, q: 3 })
  end

  it 'to_array()' do
    lup = { a: 0, b: 1, c: 2 }

    array = Brain::Lookup.to_array(lup, { b: 8, notinlookup: 9 })

    expect(array).to eq([0, 8, 0])
  end

  it 'to_hash()' do
    lup = { b: 1, a: 0, c: 2 }

    hash = Brain::Lookup.to_hash(lup, [0, 9, 8])

    expect(hash).to eq({a: 0, b: 9, c: 8})
  end
end
