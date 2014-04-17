require 'model_test'

class StocksTest < ModelTest
  setup { @stock = stocks(:stock) }

  test 'update last trade functionality' do
    symbol = @stock.symbol
    assert_respond_to @stock, :update_last_trade?, 'Stock cannot update last trade'

    # Test when stop symbol is invalid
    @stock.symbol = 'Invalid'
    last_trade = @stock.last_trade
    assert_raises (RetrievalError) { @stock.update_last_trade? }
    assert_equal last_trade, @stock.last_trade, 'Last trade does not still equal previous value'

    # Test when last_trade is nil
    @stock.symbol = symbol
    @stock.last_trade = nil
    assert_nothing_raised { assert @stock.update_last_trade?, 'Stock was not updated despite nil last trade' }
    assert_not_equal last_trade, @stock.last_trade , 'Last trade still equals previous value'

    # Test when last_trade has changed
    @stock.last_trade = -1
    assert_nothing_raised { assert @stock.update_last_trade?, 'Stock was not updated despite negative last trade' }
    assert_not_equal -1, @stock.last_trade , 'Last trade still equals previous value'

    # Test when last_trade has not changed
    last_trade = @stock.last_trade
    assert_nothing_raised { assert !@stock.update_last_trade?, 'Stock was updated despite still being equal to previous value' }
    assert_equal last_trade, @stock.last_trade , 'Last trade does not still equal previous value'
  end

  test 'validate highest_price presence' do
    test_field_presence @stock, :highest_price
  end

  test 'validate highest_price under range' do
    @stock.highest_price = 0
    assert !@stock.valid?, 'Stock is considered valid'
    assert !@stock.save, 'Stock saved with a highest price equal to 0'
    assert @stock.errors[:highest_price].any?, 'Stock does not have an error on highest_price'
  end

  test 'validate highest_time presence' do
    test_field_presence @stock, :highest_time
  end

  test 'validate last_trade presence' do
    test_field_presence @stock, :last_trade
  end

  test 'validate last_trade under range' do
    @stock.last_trade = 0
    assert !@stock.valid?, 'Stock is considered valid'
    assert !@stock.save, 'Stock saved with a last_trade equal to 0'
    assert @stock.errors[:last_trade].any?, 'Stock does not have an error on last_trade'
  end

  test 'validate symbol presence' do
    test_field_presence @stock, :symbol
  end

  test 'validate symbol validity' do
    @stock.symbol = 'Invalid'
    assert !@stock.save, 'Stock saved with an invalid symbol'
    assert @stock.errors[:symbol].any?, 'Stock does not have an error on symbol'
  end

  test 'validate lowest_price presence' do
    test_field_presence @stock, :lowest_price
  end

  test 'validate lowest_price under range' do
    @stock.lowest_price = 0
    assert !@stock.valid?, 'Stock is considered valid'
    assert !@stock.save, 'Stock saved with a lowest price equal to 0'
    assert @stock.errors[:lowest_price].any?, 'Stock does not have an error on lowest_price'
  end

  test 'validate lowest_time presence' do
    test_field_presence @stock, :lowest_time
  end
end
