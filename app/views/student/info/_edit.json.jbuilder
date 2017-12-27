json.status 0
json.result  {
  json.message @message
  json.extract!(@canteen_worker, :name, :account)
}