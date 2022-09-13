defmodule FoodDiaryWeb.Resolvers.Meal do
  # alias FoodDiaryWeb.Endpoint
  alias FoodDiary.Meals
  # alias Absinthe.Subscription

  # def create(%{input: params}, _context) do
  #   with {:ok, meal} <- Meals.Create.call(params) do
  #     Subscription.publish(Endpoint, meal, new_meal: "new_meal_topic")
  #     {:ok, meal}
  #   else
  #     error -> error
  #   end
  # end

  # USANDO TRIGGER PARA FAZER SUBSCRIPTION
  def create(%{input: params}, _context), do: Meals.Create.call(params)
end
