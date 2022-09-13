defmodule FoodDiaryWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  @desc "Logic user representation"
  object :user do
    field :id, non_null(:id), description: "Users id, needs to be an integer."
    field :name, non_null(:string), description: "Users name, needs to be an string."
    field :email, non_null(:string), description: "Users email, needs to be an string."
  end

  input_object :create_user_input do
    field :name, non_null(:string), description: "Users name"
    field :email, non_null(:string), description: "Users email"
  end
end
