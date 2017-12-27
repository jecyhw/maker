FactoryGirl.define do
  canteen_worker = CanteenWorker.find_by_account('41112190')
  factory :canteen_worker do
    account canteen_worker.account
    password canteen_worker.password
  end
end