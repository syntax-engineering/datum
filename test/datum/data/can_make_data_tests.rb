
CanMakeDataTest = Datum.new :value_one, :value_two

CanMakeDataTest.new true, false
CanMakeDataTest.new false, 'strings'
CanMakeDataTest.new 1, nil