module Brain
  class Lookup
    class << self
      def build_lookup(hashes)
        # [{a: 1}, {b: 6, c: 7}] -> {a: 0, b: 1, c: 2}
        h = hashes.reduce do |memo, hash|
          memo.merge hash
        end
        lookup_from_hash h
      end

      def lookup_from_hash(hash)
        # {a: 6, b: 7} -> {a: 0, b: 1}
        lookup = {}
        index = 0
        hash.each do |k, v|
          lookup[k] = index
          index += 1
        end
        lookup
      end

      def to_array(lookup, hash)
        # {a: 0, b: 1}, {a: 6} -> [6, 0]
        array = []
        lookup.each do |k, v|
          array[lookup[k]] = hash[k] || 0
        end
        array
      end

      def to_hash(lookup, array)
        # {a: 0, b: 1}, [6, 7] -> {a: 6, b: 7}
        hash = {}
        lookup.each do |k, v|
          hash[k] = array[lookup[k]]
        end
        hash
      end

      def lookup_from_array(array)
        lookup = {}
        z = 0
        array.reverse.each do |i|
          lookup[i] = z
          z += 1
        end
      end
    end
  end
end
