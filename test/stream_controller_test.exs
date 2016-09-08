defmodule Quizzy.StreamControllerTest do
    use Quizzy.ConnCase

    alias Quizzy.StreamController

    test "/stream/0", %{conn: conn} do
        # it's enough to test one stream, because it loads all streams
        conn = get conn, "/stream/0"
        assert json_response(conn, 200) 
    end
end