class BracketsCase < OpenStruct
  def name
    'test_%s' % description.gsub(/[ -]/, '_')
  end

  def skipped
    index.zero? ? '# skip' : 'skip'
  end

  def test_body
    long_input? ? split_test : simple_test
  end

  def long_input?
    input.length > 80
  end

  def simple_test
    "#{assert_or_refute} Brackets.paired?('#{input}')"
  end

  def split_test
    "str = '#{split_input[0]}'\\
          '#{split_input[1]}'
    #{assert_or_refute} Brackets.paired?(str)"
  end

  def assert_or_refute
    expected ? 'assert' : 'refute'
  end

  def split_input
    @split_input ||= input.scan(/.{1,#{input.length / 2}}/)
  end
end

BracketsCases = proc do |data|
  JSON.parse(data)['cases'].map.with_index do |row, i|
    BracketsCase.new(row.merge('index' => i))
  end
end
