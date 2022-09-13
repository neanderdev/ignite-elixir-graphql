defmodule FoodDiaryWeb.Resolvers.Meal do
  alias FoodDiaryWeb.Endpoint
  alias FoodDiary.Meals
  alias Absinthe.Subscription

  def create(%{input: params}, _context) do
    {:ok, meal} = Meals.Create.call(params)

    Subscription.publish(Endpoint, meal, new_meal: "new_meal_topic")

    {:ok, meal}
  end
end
