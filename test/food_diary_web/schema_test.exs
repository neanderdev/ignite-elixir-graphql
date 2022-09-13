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
end
