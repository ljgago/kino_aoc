defmodule KinoAOC.HelperCellTest do
  use ExUnit.Case, async: true

  import Kino.Test

  alias KinoAOC.HelperCell

  setup :configure_livebook_bridge

  @attrs %{
    "variable" => "puzzle_input",
    "year" => "2021",
    "day" => "1",
    "session" => "MY_SESSION_ID",
    "session_secret" => "MY_SECRET_SESSION_ID",
    "use_session_secret" => true
  }

  describe "initialization" do
    test "returns default source when started with missing attrs" do
      {_kino, source} =
        start_smart_cell!(HelperCell, %{
          "variable" => "puzzle_input",
          "year" => "2021",
          "day" => "1"
        })

      assert source ==
               ~s"""
               {:ok, puzzle_input} = KinoAOC.download_puzzle("2021", "1", "")\
               """
    end
  end

  describe "code generation" do
    test "restores source code from attrs for secret_session" do
      attrs = HelperCell.to_attrs(%{assigns: %{fields: @attrs}})

      assert HelperCell.to_source(attrs) === ~s"""
             {:ok, puzzle_input} =
               KinoAOC.download_puzzle("2021", "1", System.fetch_env!("LB_MY_SECRET_SESSION_ID"))\
             """
    end

    test "restores source code from attrs for session" do
      attrs = Map.replace(@attrs, "use_session_secret", false)
      attrs = HelperCell.to_attrs(%{assigns: %{fields: attrs}})

      assert HelperCell.to_source(attrs) === ~s"""
             {:ok, puzzle_input} = KinoAOC.download_puzzle("2021", "1", "MY_SESSION_ID")\
             """
    end

    test "update year" do
      {kino, _source} = start_smart_cell!(HelperCell, %{"year" => "2015"})

      push_event(kino, "update_field", %{"field" => "year", "value" => "2021"})

      assert_broadcast_event(kino, "update", %{"fields" => %{"year" => "2021"}})
    end

    test "update day" do
      {kino, _source} = start_smart_cell!(HelperCell, %{"day" => "1"})

      push_event(kino, "update_field", %{"field" => "day", "value" => "25"})

      assert_broadcast_event(kino, "update", %{"fields" => %{"day" => "25"}})
    end

    test "update variable" do
      {kino, _source} = start_smart_cell!(HelperCell, %{"variable" => "puzzle_input"})

      push_event(kino, "update_field", %{"field" => "day", "value" => "input"})

      assert_broadcast_event(kino, "update", %{"fields" => %{"day" => "input"}})
    end

  end
end
