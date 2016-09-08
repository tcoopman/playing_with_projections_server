defmodule Quizzy.StreamControllerTest do
    use Quizzy.ConnCase

    test "/stream/0", %{conn: conn} do
        conn = get conn, "/stream/0"
        assert json_response(conn, 200) 
    end
    
    test "/stream/1", %{conn: conn} do
        conn = get conn, "/stream/1"
        assert json_response(conn, 200) 
    end
end