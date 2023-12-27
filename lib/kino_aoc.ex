defmodule KinoAOC do
  @moduledoc """

  A helper for Advent of Code (a smart cell) for Elixir [Livebook](https://github.com/livebook-dev/livebook) using [Kino](https://github.com/livebook-dev/kino).

  ## Installation

  To bring KinoAOC to Livebook all you need to do is `Mix.install/2`:

  ```
  Mix.install([
    {:kino_aoc, "~> 0.1"}
  ])
  ```

  ## Usage

  You only need add the smart cell `Advent of Code Helper` and select the `YEAR`,
  `DAY`, set the `SESSION` and the output `ASSIGN TO`.

  In `SESSION` you can configure a `secret` or set a `string` directly.
  The session id is a cookie which is set when you login to AoC. You can
  find it with your browser inspector.

  > **Warning:** \\
  > The session string mode saves the content directly in the notebook. \\
  > Be careful to share it.

  """

  def download_puzzle(year, day, session) do
    {:ok, res} =
      Req.get("https://adventofcode.com/#{year}/day/#{day}/input",
        headers: [{"cookie", "session=#{session}"}]
      )

    case res.status do
      200 -> {:ok, String.slice(res.body, 0..-2//1)}
      _ -> raise "\nStatus: #{inspect(res.status)}\nError: #{inspect(String.trim(res.body))}"
    end
  end
end
