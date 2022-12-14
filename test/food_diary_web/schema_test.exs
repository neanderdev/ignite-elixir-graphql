defmodule FoodDiaryWeb.SchemaTest do
  use FoodDiaryWeb.ConnCase, async: true
  use FoodDiaryWeb.SubscriptionCase

  alias FoodDiary.{User, Users}

  describe "users query" do
    test "when a valid id is giver, returns the user", %{conn: conn} do
      params = %{email: "teste@teste.com", name: "Teste"}

      {:ok, %User{id: user_id}} = Users.Create.call(params)

      query = """
        {
          user(id: "#{user_id}"){
            name,
            email,
          }
        }
      """

      expected_response = %{
        "data" => %{
          "user" => %{
            "email" => "teste@teste.com",
            "name" => "Teste"
          }
        }
      }

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end

    test "when the user does not exist, returns an error", %{conn: conn} do
      query = """
        {
          user(id: "123456789"){
            name,
            email,
          }
        }
      """

      expected_response = %{
        "data" => %{"user" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 5, "line" => 2}],
            "message" => "User not found",
            "path" => ["user"]
          }
        ]
      }

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(:ok)

      assert response == expected_response
    end
  end

  describe "users mutation" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Teste",
            email: "teste@email.com.br",
          }){
            id,
            name,
            email,
          }
        }
      """

      response =
        conn
        |> post("api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "email" => "teste@email.com.br",
                   "id" => _id,
                   "name" => "Teste"
                 }
               }
             } = response
    end
  end

  describe "subscriptions" do
    test "meals subscription", %{socket: socket} do
      params = %{email: "teste@teste.com", name: "Teste"}

      {:ok, %User{id: user_id}} = Users.Create.call(params)

      mutation = """
        mutation {
          createMeal(input: {
            userId: #{user_id},
            description: "Pizza de frango",
            calories: 370.59,
            category: FOOD,
          }){
            description,
            calories,
            category,
          }
        }
      """

      subscription = """
        subscription {
          newMeal {
            description,
          }
        }
      """

      # Setup da Subscription
      socket_ref = push_doc(socket, subscription)
      assert_reply socket_ref, :ok, %{subscriptionId: subscription_id}

      # Setup da Mutation
      socket_ref = push_doc(socket, mutation)
      assert_reply socket_ref, :ok, mutation_response

      expected_mutation_response = %{
        data: %{
          "createMeal" => %{
            "calories" => 370.59,
            "category" => "FOOD",
            "description" => "Pizza de frango"
          }
        }
      }

      expected_subscription_response = %{
        result: %{
          data: %{
            "newMeal" => %{"description" => "Pizza de frango"}
          }
        },
        subscriptionId: subscription_id
      }

      assert mutation_response == expected_mutation_response

      assert_push "subscription:data", subscription_response
      assert subscription_response == expected_subscription_response
    end
  end
end
