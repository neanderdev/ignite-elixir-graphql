defmodule FoodDiaryWeb.SchemaTest do
  use FoodDiaryWeb.ConnCase, async: true

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
  end
end
