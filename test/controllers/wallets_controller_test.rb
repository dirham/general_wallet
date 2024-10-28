require "test_helper"
require "minitest/autorun"
class WalletsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @wallet = @user.wallet || @user.create_wallet
    @amount = 50.20
    sign_in(@user)
  end

  test "should get balance" do
    get "/api/balance"
    assert_response :ok
    assert_equal @wallet.balance.to_f, JSON.parse(@response.body)["data"]
  end

  test "should deposit amount" do
    initial_balance = @wallet.balance.to_f
    post "/api/deposit", params: { amount: @amount }
    assert_response :ok
    assert_equal "success", JSON.parse(@response.body)["data"]
    assert_equal initial_balance + @amount, @wallet.reload.balance.to_f
  end

  test "should transfer amount" do
    target_user = users(:two)
    target_user.create_wallet unless target_user.wallet

    @user.wallet.deposit(100.00)

    post "/api/transfer", params: { user_id: target_user.id, amount: 10.0 }
    assert_response :ok
    assert_equal "success", JSON.parse(@response.body)["data"]
    assert_equal @wallet.balance.to_f, @wallet.reload.balance.to_f
  end

  test "should withdraw amount" do
    @user.wallet.deposit(100.00)

    post "/api/withdraw", params: { amount: @amount }
    assert_response :ok
    assert_equal "success", JSON.parse(@response.body)["data"]
    assert_equal @wallet.balance.to_f, @wallet.reload.balance.to_f
  end

  test "should handle deposit error" do
    post "/api/deposit", params: { amount: "e45" }  # Direct path

    # Validate that the response is the expected error response
    assert_response :unprocessable_entity
    assert_equal "Validation failed: Amount is not a number", JSON.parse(@response.body)["error"]
  end

  test "should handle withdrawal balance not enough" do
    post "/api/withdraw", params: { amount: @amount }  # Direct path
    assert_response :unprocessable_entity
    assert_equal "Insufficient funds", JSON.parse(@response.body)["error"]
  end

  test "should handle transfer error" do
    target_user = users(:two)
    target_user.create_wallet unless target_user.wallet  # Ensure the target user has a wallet
    post "/api/transfer", params: { user_id: target_user.id, amount: @amount }  # Direct path
    assert_response :unprocessable_entity
    assert_equal "Insufficient funds", JSON.parse(@response.body)["error"]
  end
end
